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
}
