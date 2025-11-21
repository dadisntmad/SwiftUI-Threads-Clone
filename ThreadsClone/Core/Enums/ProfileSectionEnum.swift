enum ProfileSectionEnum: Int, CaseIterable, Identifiable {
    case threads
    case replies
    case media
    case reposts
    
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
