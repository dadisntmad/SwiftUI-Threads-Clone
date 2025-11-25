struct UserModel: Codable {
    let uid: String
    let email: String
    let fullName: String
    let imageUrl: String?
    let bio: String?
    let link: String?
    let followers: [String]
    let following: [String]
}
