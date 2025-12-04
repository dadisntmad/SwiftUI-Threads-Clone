import Observation
import FirebaseFirestore

@Observable
class FeedViewModel {
    private var db = Firestore.firestore()
    
    var status = LoadingStatusEnum.unknown
    
    var threads: [ThreadModel] = []
    
    var isLoading: Bool {
        status == .loading
    }
    
    init() {
        getThreads()
    }
    
    private func getThreads() {
        status = .loading
        
        db.collection("threads")
            .whereField("parentId", isEqualTo: "")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snap, err in
                if let err = err {
                    print("Failed: \(err.localizedDescription)")
                    self.status = .error
                    return
                }
                
                guard let docs = snap?.documents else { return }
                
                self.threads.removeAll()
                
                for doc in docs {
                    do {
                        let thread = try doc.data(as: ThreadModel.self)
                        self.threads.append(thread)
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                    }
                }
                
                Task {
                    try await self.getUserThreadData()
                }
                
                self.status = .loaded
            }
    }
    
    
    private func getUserThreadData() async throws {
        for i in 0..<threads.count {
            let authorId = threads[i].authorId
            let authorUser = try await UserService.getUserById(uid: authorId)
            threads[i].user = authorUser
        }
    }
}

