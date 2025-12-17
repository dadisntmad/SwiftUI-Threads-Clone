import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class NotificationsViewModel {
    private var auth = Auth.auth()
    private var db = Firestore.firestore()
    
    var status: LoadingStatusEnum = .unknown
    
    var notifications: [NotificationModel] = []
    
    var isLoading: Bool {
        status == .loading
    }
    
    init() {
        Task { await getNotifications() }
    }
    
    
    private func getNotifications() async {
        status = .loading
        guard let uid = auth.currentUser?.uid else { return }
        
        do {
            let snap = try await db.collection("notifications")
                .whereField("receiverId", arrayContains: uid)
                .order(by: "createdAt", descending: true)
                .getDocuments()
            
            if snap.isEmpty || snap.documents.isEmpty {
                status = .loaded
                return
            }
            
            notifications = snap.documents.compactMap { doc in
                let notification = try? doc.data(as: NotificationModel.self)
                return notification
            }
            
            try await getUserData()
            
            status = .loaded
        } catch {
            debugPrint("DEBUG: Failed to fetch notifications: \(error.localizedDescription)")
            status = .error
        }
    }
    
    private func getUserData() async throws {
        for i in 0..<notifications.count {
            let authorId = notifications[i].authorId
            let authorUser = try await UserService.getUserById(uid: authorId)
            notifications[i].user = authorUser
        }
    }
}
