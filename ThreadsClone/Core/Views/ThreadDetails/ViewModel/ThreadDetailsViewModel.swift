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
    
    func reply(threadId: String, receiverId: String, parentId: String?, text: String) async throws {
        guard let uid = auth.currentUser?.uid else { return }
        
        let ref = db.collection("threads").document()
        let notificationRef = db.collection("notifications").document()
        let newId = ref.documentID
        let notificationId = notificationRef.documentID
        
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
            
            try await db.collection("threads")
                .document(threadId)
                .updateData(["comments": FieldValue.arrayUnion([uid])])
            
            let notificationModel = NotificationModel(
                notificationId: notificationId,
                threadId: threadId,
                authorId: uid,
                receiverId: [receiverId],
                createdAt: .now,
                type: .reply
            )
            
            try notificationRef.setData(from: notificationModel)
            
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
            .addSnapshotListener { [weak self] snap, err in
                guard let self else { return }
                
                if let err = err {
                    print("Failed: \(err.localizedDescription)")
                    self.status = .error
                    return
                }
                
                guard let docs = snap?.documents else { return }
                
                self.replies = docs.compactMap {
                    try? $0.data(as: ThreadModel.self)
                }
                
                Task {
                    do {
                        try await self.getRepliesData()
                        self.status = .loaded
                    } catch {
                        self.status = .error
                    }
                }
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
