import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class UserProfileViewModel {
    private var auth = Auth.auth()
    private var db = Firestore.firestore()
    
    let uid: String
    
    var ownThreads: [ThreadModel] = []
    var allThreads: [ThreadModel] = []
    
    var status: LoadingStatusEnum = .unknown
    
    var isLoading: Bool {
        status == .loading
    }
    
    var replies: [ThreadModel] {
        allThreads.filter { $0.comments.contains(uid) }
    }
    
    var media: [ThreadModel] {
        ownThreads.filter { !$0.imageUrls.isEmpty }
    }
    
    var reposts: [ThreadModel] {
        allThreads.filter { $0.reposts.contains(uid) }
    }
    
    init(uid: String) {
        self.uid = uid
        
        Task {
            status = .loading
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.getOwnThreads() }
                group.addTask { await self.getAllThreads() }
            }
            status = .loaded
        }
    }
    
    private func getOwnThreads() async {
        do {
            let snap = try await db.collection("threads")
                .whereField("authorId", isEqualTo: uid)
                .getDocuments()
            
            if snap.isEmpty || snap.documents.isEmpty {
                status = .loaded
                return
            }
            
            ownThreads = try snap.documents.compactMap { doc in
                let data = try doc.data(as: ThreadModel.self)
                return data
            }
            
            try await getOwnThreadsData()
            
        } catch {
            debugPrint("DEBUG: Failed to fetch threads: \(error.localizedDescription)")
            status = .error
        }
    }
    
    private func getAllThreads() async {
        do {
            let snap = try await db.collection("threads").getDocuments()
            
            if snap.isEmpty || snap.documents.isEmpty {
                status = .loaded
                return
            }
            
            allThreads = try snap.documents.compactMap { doc in
                let data = try doc.data(as: ThreadModel.self)
                return data
            }
            
        } catch {
            debugPrint("DEBUG: Failed to fetch threads: \(error.localizedDescription)")
            status = .error
        }
    }
    
    private func getOwnThreadsData() async throws {
        let authorUser = try await UserService.getUserById(uid: uid)
        
        for i in 0..<ownThreads.count {
            ownThreads[i].user = authorUser
        }
    }
    
    private func getUserThreadsData() async throws {
        for i in 0..<allThreads.count {
            let authorId = allThreads[i].authorId
            let authorUser = try await UserService.getUserById(uid: authorId)
            allThreads[i].user = authorUser
        }
    }
}
