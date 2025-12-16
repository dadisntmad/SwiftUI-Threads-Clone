import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class ExploreViewModel {
    private var auth = Auth.auth()
    private var db = Firestore.firestore()
    
    var users: [UserModel] = []
    var usersStatus: LoadingStatusEnum = .unknown
    
    var usersLoading: Bool {
        usersStatus == .loading
    }
    
    init() {
        Task { await getUsers() }
    }
    
    func toggleFollow(for documentId: String) async {
        guard let uid = auth.currentUser?.uid else { return }
        
        do {
            let ref = db.collection("users").document(documentId)
            
            try await ref.updateData([
                "followers": FieldValue.arrayUnion([uid])
            ])
            
            users.removeAll(where: { $0.uid == documentId })
            
        } catch {
            debugPrint("DEBUG: Failed to follow / unfollow the user: \(error.localizedDescription)")
        }
    }
    
    private func getUsers() async {
        usersStatus = .loading
        
        guard let uid = auth.currentUser?.uid else { return }
        
        do {
            let snap = try await db.collection("users").getDocuments()
            
            users = snap.documents.compactMap { doc in
                let user = try? doc.data(as: UserModel.self)
                guard let user, user.id != uid, !user.followers.contains(uid) else { return nil }
                return user
            }
            
            usersStatus = .loaded
        } catch {
            debugPrint("DEBUG: Failed to fetch users: \(error.localizedDescription)")
            usersStatus = .error
        }
    }
    
}
