protocol ThreadsProvider {
    var ownThreads: [ThreadModel] { get }
    var replies: [ThreadModel] { get }
    var media: [ThreadModel] { get }
    var reposts: [ThreadModel] { get }
}

extension ProfileViewModel: ThreadsProvider {}
extension UserProfileViewModel: ThreadsProvider {}
