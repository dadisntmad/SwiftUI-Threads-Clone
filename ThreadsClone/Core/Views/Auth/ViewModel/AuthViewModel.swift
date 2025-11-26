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
    
    var didSignUp = false
    var didOnboard = false
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
                imageUrl: "",
                bio: "",
                link: "",
                followers: [],
                following: []
            )
            
            try db.collection("users").document(fbUser.uid).setData(from: userModel)
            
            status = .loaded
            didSignUp = status != .error && status == .loaded
            
        } catch {
            errMessage = error.localizedDescription
            didSignUp = false
            status = .error
        }
    }
    
    func onboardUser(fullName: String, bio: String, link: String, image: UIImage?) async {
        guard let uid = fbUser?.uid else { return }
        
        let docRef = db.collection("users").document(uid)
        
        errMessage = nil
        status = .loading
        
        do {
            let isValidBio = !bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            let isValidLink = !link.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            let imageUrl = try await MediaUploaderService.upload(folderName: "profile_image", image: image)
            
            try await docRef.updateData([
                "fullName": fullName,
                "bio":  isValidBio ? bio : "",
                "link": isValidLink ? link : "",
                "imageUrl": imageUrl == nil ? "" : imageUrl!
            ])
            
            status = .loaded
            didOnboard = status != .error && status == .loaded
            
        } catch {
            errMessage = error.localizedDescription
            didOnboard = false
            status = .error
        }
    }
}

