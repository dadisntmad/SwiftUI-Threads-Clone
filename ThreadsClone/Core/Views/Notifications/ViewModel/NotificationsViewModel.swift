import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class NotificationsViewModel {
    private var auth = Auth.auth()
    private var db = Firestore.firestore()
    
    var dataLoadingStatus: LoadingStatusEnum = .unknown
    var actionStatus: LoadingStatusEnum = .unknown
    
    var notifications: [NotificationModel] = []
    
    var followingStatus: [String: Bool] = [:]
    
    var isLoading: Bool {
        dataLoadingStatus == .loading
    }
    
    var isActionInProgress: Bool {
        actionStatus == .loading
    }
    
    init() {
        Task { await getNotifications() }
    }
    
    func toggleFollow(for documentId: String) async {
        actionStatus = .loading
        guard let uid = auth.currentUser?.uid else { return }
        
        do {
            let ref = db.collection("users").document(documentId)
            let notificationRef = db.collection("notifications").document()
            let notificationId = notificationRef.documentID
            
            let isFollowing = followingStatus[documentId] ?? false
            followingStatus[documentId] = !isFollowing
            
            if isFollowing {
                try await db.collection("users").document(uid).updateData([
                    "following": FieldValue.arrayRemove([documentId])
                ])
                
                try await ref.updateData([
                    "followers": FieldValue.arrayRemove([uid])
                ])
            } else {
                try await db.collection("users").document(uid).updateData([
                    "following": FieldValue.arrayUnion([documentId])
                ])
                
                try await ref.updateData([
                    "followers": FieldValue.arrayUnion([uid])
                ])
                
                let notificationModel = NotificationModel(
                    notificationId: notificationId,
                    threadId: "",
                    authorId: uid,
                    receiverId: [documentId],
                    createdAt: .now,
                    type: .follow
                )
                
                try notificationRef.setData(from: notificationModel)
            }
            
            actionStatus = .loaded
            
        } catch {
            debugPrint("DEBUG: Failed to follow / unfollow the user: \(error.localizedDescription)")
            actionStatus = .error
        }
    }
    
    private func getNotifications() async {
        dataLoadingStatus = .loading
        guard let uid = auth.currentUser?.uid else { return }
        
        do {
            let snap = try await db.collection("notifications")
                .whereField("receiverId", arrayContains: uid)
                .order(by: "createdAt", descending: true)
                .getDocuments()
            
            if snap.isEmpty || snap.documents.isEmpty {
                dataLoadingStatus = .loaded
                return
            }
            
            notifications = snap.documents.compactMap { doc in
                let notification = try? doc.data(as: NotificationModel.self)
                return notification
            }
            
            try await getUserData()
            
            dataLoadingStatus = .loaded
        } catch {
            debugPrint("DEBUG: Failed to fetch notifications: \(error.localizedDescription)")
            dataLoadingStatus = .error
        }
    }
    
    private func getUserData() async throws {
        guard let uid = auth.currentUser?.uid else { return }
        let currentUser = try await UserService.getUserById(uid: uid)
        
        for i in 0..<notifications.count {
            let authorId = notifications[i].authorId
            let authorUser = try await UserService.getUserById(uid: authorId)
            notifications[i].user = authorUser
            followingStatus[authorId] = currentUser.following.contains(authorId)
        }
    }
}
