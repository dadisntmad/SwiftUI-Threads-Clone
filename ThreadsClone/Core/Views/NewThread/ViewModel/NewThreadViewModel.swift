import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class NewThreadViewModel {
    private var auth = Auth.auth()
    private var db = Firestore.firestore()
    
    var status: LoadingStatusEnum = .unknown
    
    var isLoading: Bool {
        status == .loading
    }
    
    func createThread(text: String) async {
        guard let uid = auth.currentUser?.uid else { return }
        
        status = .loading
        
        let docRef = db.collection("threads").document()
        let newId = docRef.documentID
        
        let threadModel = ThreadModel(
            id: newId,
            threadId: newId,
            parentId: nil,
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
            try docRef.setData(from: threadModel)
            
            status = .loaded
        } catch  {
            debugPrint("DEBUG: Failed to create a thread: \(error.localizedDescription)")
            status = .error
        }
    }
}
