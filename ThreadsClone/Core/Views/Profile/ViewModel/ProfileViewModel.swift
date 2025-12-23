import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class ProfileViewModel: ProfileThreadsViewModel {

    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    var uid: String {
        auth.currentUser!.uid
    }

    var ownThreads: [ThreadModel] = []
    var allThreads: [ThreadModel] = []
    var status: LoadingStatusEnum = .unknown

    init() {
        Task { await loadThreads(db: db) }
    }
}
