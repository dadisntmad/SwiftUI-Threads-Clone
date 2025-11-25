import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class AuthViewModel {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    var user: UserModel?
    var fbUser: User?
    
    var status: LoadingStatusEnum = .unknown
    
    var errMessage: String?
    
    var isSuccess = false
    var isAuthenticated = false
    
    var isLoading: Bool {
        status == .loading
    }
    
    func signUp(email: String, password: String) async throws {
        errMessage = nil
        status = .loading
        
        do {
            let res = try await auth.createUser(withEmail: email, password: password)
            
            let fbUser = res.user
            
            self.fbUser = fbUser
            
            let userModel = UserModel(
                uid: fbUser.uid,
                email: email,
                fullName: "",
                imageUrl: nil,
                bio: nil,
                link: nil,
                followers: [],
                following: []
            )
            
            try db.collection("users").document(fbUser.uid).setData(from: userModel)
            
            status = .loaded
            isSuccess = status != .error && status == .loaded
            
        } catch {
            errMessage = error.localizedDescription
            isSuccess = false
            status = .error
        }
    }
}

