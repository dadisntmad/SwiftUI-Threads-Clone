import Foundation

struct NotificationModel: Codable, Identifiable {
    let notificationId: String
    let threadId: String
    let authorId: String
    let receiverId: [String]
    let createdAt: Date
    let type: NotificationTypeEnum
    
    var id: String { notificationId }
    
    var user: UserModel?
    
    var message: String {
        switch type {
        case .reply:
            "replied to your thread"
        case .like:
            "liked your thread"
        case .follow:
            "followed you"
        case .unknown:
            "sent you a notification"
        }
    }
}
