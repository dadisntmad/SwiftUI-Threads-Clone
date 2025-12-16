import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class ExploreViewModel {
    private var auth = Auth.auth()
    private var db = Firestore.firestore()
    
    var users: [UserModel] = []
    
    init() {
        Task { await getUsers() }
    }
    
    private func getUsers() async {
        do {
            let snap = try await db.collection("users").getDocuments()
            
            if snap.isEmpty || snap.documents.isEmpty { return }
            
            for doc in snap.documents {
                let data = try doc.data(as: UserModel.self)
                users.append(data)
            }
            
        } catch {
            debugPrint("DEBUG: Failed to fetch users: \(error.localizedDescription)")
        }
    }
}
