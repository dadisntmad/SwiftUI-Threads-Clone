import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class UserProfileViewModel: ProfileThreadsViewModel {
    
    private let db = Firestore.firestore()
    
    let uid: String
    var ownThreads: [ThreadModel] = []
    var allThreads: [ThreadModel] = []
    var status: LoadingStatusEnum = .unknown
    
    init(uid: String) {
        self.uid = uid
        Task { await loadThreads(db: db) }
    }
}
