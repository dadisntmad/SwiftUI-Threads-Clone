import FirebaseFirestore

extension ProfileThreadsViewModel {
    
    var replies: [ThreadModel] {
        allThreads.filter { $0.comments.contains(uid) }
    }
    
    var media: [ThreadModel] {
        ownThreads.filter { !$0.imageUrls.isEmpty }
    }
    
    var reposts: [ThreadModel] {
        allThreads.filter { $0.reposts.contains(uid) }
    }
    
    func loadThreads(db: Firestore) async {
        status = .loading
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.getOwnThreads(db: db) }
            group.addTask { await self.getAllThreads(db: db) }
        }
        
        status = .loaded
    }
    
    func getOwnThreads(db: Firestore) async {
        do {
            let snap = try await db.collection("threads")
                .whereField("authorId", isEqualTo: uid)
                .getDocuments()
            
            ownThreads = try snap.documents.compactMap {
                try $0.data(as: ThreadModel.self)
            }
            
            try await attachAuthorToOwnThreads()
            
        } catch {
            status = .error
        }
    }
    
    func getAllThreads(db: Firestore) async {
        do {
            let snap = try await db.collection("threads").getDocuments()
            
            allThreads = try snap.documents.compactMap {
                try $0.data(as: ThreadModel.self)
            }
            
            try await getUserData()
            
        } catch {
            status = .error
        }
    }
    
    private func attachAuthorToOwnThreads() async throws {
        let author = try await UserService.getUserById(uid: uid)
        for i in ownThreads.indices {
            ownThreads[i].user = author
        }
    }
    
    private func getUserData() async throws {
        for i in 0..<allThreads.count {
            let authorId = allThreads[i].authorId
            let authorUser = try await UserService.getUserById(uid: authorId)
            allThreads[i].user = authorUser
        }
    }
}
