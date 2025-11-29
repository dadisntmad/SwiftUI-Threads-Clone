enum AuthStateEnum {
    case unknown
    case authenticated
    case needsOnboarding(uid: String)
    case unauthenticated
}
