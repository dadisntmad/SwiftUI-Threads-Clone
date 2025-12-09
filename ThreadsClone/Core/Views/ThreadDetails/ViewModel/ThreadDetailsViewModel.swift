import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class ThreadDetailsViewModel {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    var status: LoadingStatusEnum = .unknown
    
    var replies: [ThreadModel] = []
    
    var isLoading: Bool {
        status == .loading
    }
    
    func reply(threadId: String, parentId: String?, text: String) async throws {
        guard let uid = auth.currentUser?.uid else { return }
        
        let ref = db.collection("threads").document()
        let newId = ref.documentID
        
        let newThread = ThreadModel(
            id: newId,
            threadId: threadId,
            parentId: parentId,
            authorId: uid,
            text: text,
            imageUrls: [],
            createdAt: .now,
            updatedAt: nil,
            likes: [],
            comments: [],
            reposts: []
        )
        
        do {
            try ref.setData(from: newThread)
        } catch {
            debugPrint("DEBUG: Failed to reply: \(error.localizedDescription)")
        }
    }
    
    func getReplies(threadId: String) {
        status = .loading
        
        db.collection("threads")
            .whereField("threadId", isEqualTo: threadId)
            .whereField("parentId", isNotEqualTo: "")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snap, err in
                if let err = err {
                    print("Failed: \(err.localizedDescription)")
                    self.status = .error
                    return
                }
                
                guard let docs = snap?.documents else { return }
                
                self.replies.removeAll()
                
                for doc in docs {
                    do {
                        let thread = try doc.data(as: ThreadModel.self)
                        self.replies.append(thread)
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                    }
                }
                
                Task {
                    try await self.getRepliesData()
                }
                
                self.status = .loaded
            }
    }
    
    private func getRepliesData() async throws {
        for i in 0..<replies.count {
            let authorId = replies[i].authorId
            let authorUser = try await UserService.getUserById(uid: authorId)
            replies[i].user = authorUser
        }
    }
}
