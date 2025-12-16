import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class ExploreViewModel {
    private var auth = Auth.auth()
    private var db = Firestore.firestore()
    
    var users: [UserModel] = []
    var usersStatus: LoadingStatusEnum = .unknown
    var isFollowing: [String: Bool] = [:]
    
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
            let user = try await ref.getDocument(as: UserModel.self)
            let followers = user.followers
            
            if followers.contains(uid) {
                isFollowing[documentId] = false
                
                try await ref.updateData([
                    "followers": FieldValue.arrayRemove([uid])
                ])
            } else {
                isFollowing[documentId] = true
                
                try await ref.updateData([
                    "followers": FieldValue.arrayUnion([uid])
                ])
            }
        } catch {
            debugPrint("DEBUG: Failed to follow / unfollow the user: \(error.localizedDescription)")
        }
    }
    
    private func getUsers() async {
        usersStatus = .loading
        
        guard let uid = auth.currentUser?.uid else { return }
        
        do {
            let snap = try await db.collection("users").getDocuments()
            
            if snap.isEmpty || snap.documents.isEmpty { return }
            
            for doc in snap.documents {
                let data = try doc.data(as: UserModel.self)
                let followers = data.followers
                // skip the current and following users
                if uid != doc.documentID && !(followers.contains(uid)) {
                    users.append(data)
                }
            }
            
            usersStatus = .loaded
            
        } catch {
            debugPrint("DEBUG: Failed to fetch users: \(error.localizedDescription)")
            usersStatus = .error
        }
    }
}
