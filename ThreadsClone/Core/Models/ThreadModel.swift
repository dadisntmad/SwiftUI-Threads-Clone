import Foundation

struct ThreadModel: Identifiable, Codable {
    let id: String
    let threadId: String
    let parentId: String?
    let authorId: String
    let text: String
    let imageUrls: [String?]
    let createdAt: Date
    let updatedAt: Date?
    let likes: [String?]
    let comments: [String?]
    let reposts: [String?]
}
