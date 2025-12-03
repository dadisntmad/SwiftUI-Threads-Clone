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
    
    var authState: AuthStateEnum = .unknown
    
    var isLoading: Bool {
        status == .loading
    }
    
    var username: String {
        user?.fullName.split(separator: " ").joined(separator: "_").lowercased() ?? ""
    }
    
    init() {
        Task {
            await checkAuthState()
        }
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
            authState = .needsOnboarding(uid: fbUser.uid)
            
        } catch {
            errMessage = error.localizedDescription
            status = .error
        }
    }
    
    func onboardUser(fullName: String, bio: String, link: String, image: UIImage?) async {
        guard let uid = auth.currentUser?.uid else { return }
        
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
            let user = await getCurrentUser()
            self.user = user
            authState = .authenticated
            
        } catch {
            debugPrint("DEBUG: Error uploading user data: \(error.localizedDescription)")
            errMessage = error.localizedDescription
            status = .error
            authState = .unauthenticated
        }
    }
    
    func signIn(email: String, password: String) async throws {
        errMessage = nil
        status = .loading
        
        do {
            let res = try await auth.signIn(withEmail: email, password: password)
            let fbUser = res.user
            
            self.fbUser = fbUser
            let user = await getCurrentUser()
            self.user = user
            
            status = .loaded
            authState = .authenticated
        } catch  {
            errMessage = error.localizedDescription
            status = .error
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            fbUser = nil
            user = nil
            authState = .unauthenticated
        } catch {
            debugPrint("DEBUG: failed to sign out: \(error.localizedDescription)")
        }
    }
    
    private func getCurrentUser() async -> UserModel? {
        guard let uid = auth.currentUser?.uid else { return nil }
        
        let docRef = db.collection("users").document(uid)
        
        do {
            let snap = try await docRef.getDocument()
            let user = try snap.data(as: UserModel.self)
            return user
        } catch  {
            debugPrint("DEBUG: Failed to get current user: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func checkAuthState() async {
        guard let uid = auth.currentUser?.uid else {
            authState = .unauthenticated
            return
        }
        
        let user = await getCurrentUser()
        let fullName = user?.fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let fullName, !fullName.isEmpty {
            self.user = user
            authState = .authenticated
        } else {
            authState = .needsOnboarding(uid: uid)
        }
    }
}

