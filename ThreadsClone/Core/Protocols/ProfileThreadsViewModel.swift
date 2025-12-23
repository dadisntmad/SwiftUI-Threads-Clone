protocol ProfileThreadsViewModel: AnyObject {
    var uid: String { get }
    var ownThreads: [ThreadModel] { get set }
    var allThreads: [ThreadModel] { get set }
    var status: LoadingStatusEnum { get set }
}
