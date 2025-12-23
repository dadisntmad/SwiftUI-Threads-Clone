enum ProfileSectionEnum: Int, CaseIterable, Identifiable {
    case threads
    case replies
    case media
    case reposts
    
    func threads(from provider: ThreadsProvider) -> [ThreadModel] {
        switch self {
        case .threads: return provider.ownThreads
        case .replies: return provider.replies
        case .media: return provider.media
        case .reposts: return provider.reposts
        }
    }
    
    func placeholder() -> String {
        switch self {
        case .threads: return "No threads yet."
        case .replies: return "No replies yet."
        case .media: return "No media yet."
        case .reposts: return "No reposts yet."
        }
    }
    
    var title: String {
        switch self {
        case .threads: return "Threads"
        case .replies: return "Replies"
        case .media: return "Media"
        case .reposts: return "Reposts"
        }
    }
    
    var id: Int { self.rawValue }
}
