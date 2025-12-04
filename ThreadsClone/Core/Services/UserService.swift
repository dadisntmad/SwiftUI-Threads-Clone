import FirebaseFirestore


final class UserService {
    static func getUserById(uid: String) async throws -> UserModel {
        let snap = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snap.data(as: UserModel.self)
    }
}
