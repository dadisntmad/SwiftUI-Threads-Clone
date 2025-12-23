struct UserModel: Codable, Identifiable {
    let uid: String
    let email: String
    let fullName: String
    let imageUrl: String?
    let bio: String?
    let link: String?
    let followers: [String]
    let following: [String]
    
    var id: String { uid }
    
    var username: String {
        fullName.split(separator: " ").joined(separator: "_").lowercased()
    }
    
    var followersCount: Int {
        followers.count
    }
    
    var followingCount: Int {
        following.count
    }
    
    var isImageUrlValid: Bool {
        imageUrl != nil && !(imageUrl?.isEmpty ?? false)
    }
    
    static var testUser = UserModel(
        uid: "123",
        email: "test@gmail.com",
        fullName: "First Last",
        imageUrl: nil,
        bio: "my bio",
        link: "https://www.google.com/",
        followers: [],
        following: []
    )
}
