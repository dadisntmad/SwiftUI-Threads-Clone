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
    
    var user: UserModel?
    
    static let data = [
        ThreadModel(
            id: "48TvSsFgRwgdBa4eSHJS",
            threadId: "48TvSsFgRwgdBa4eSHJS",
            parentId: "",
            authorId: "R380CAezUxY834C8VIuwpkNGTym1",
            text: "Q",
            imageUrls: [],
            createdAt: .now,
            updatedAt: nil,
            likes: [],
            comments: [],
            reposts: [],
        ),
        ThreadModel(
            id: "wl4eM9K9tkjvmYGHcNNq",
            threadId: "wl4eM9K9tkjvmYGHcNNq",
            parentId: "",
            authorId: "M975zfsTB3X1tfhou7DRkePo6am2",
            text: "My thread with a single image",
            imageUrls: ["https://firebasestorage.googleapis.com:443/v0/b/threads-clone-f90ea.firebasestorage.app/o/M975zfsTB3X1tfhou7DRkePo6am2%2Fthreads%2F377F2917-45CA-4600-AC8D-C440CA0FB181?alt=media&token=5248ae57-32d2-4d88-a17e-36c0c82cec6c"],
            createdAt: .now,
            updatedAt: nil,
            likes: [],
            comments: [],
            reposts: [],
        )
    ]
}
