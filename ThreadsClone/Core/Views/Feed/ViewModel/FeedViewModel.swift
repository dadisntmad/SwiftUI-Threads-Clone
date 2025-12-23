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
            .addSnapshotListener { [weak self] snap, err in
                guard let self else { return }
                
                if let err {
                    print("Failed: \(err.localizedDescription)")
                    self.status = .error
                    return
                }
                
                guard let docs = snap?.documents else { return }
                
                self.threads = docs.compactMap {
                    try? $0.data(as: ThreadModel.self)
                }
                
                Task {
                    do {
                        try await self.getUserThreadData()
                        self.status = .loaded
                    } catch {
                        self.status = .error
                    }
                }
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

