import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class ThreadDetailsViewModel {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
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
}
