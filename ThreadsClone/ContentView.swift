import SwiftUI

struct ContentView: View {
    @State private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            switch authViewModel.authState {
            case .unknown:
                ProgressView()
            case .onboarded:
                NavigationStack {
                    CreateProfileView(isBackButtonPresented: false)
                }
            case .authenticated:
                MainView()
            case .unauthenticated:
                NavigationStack {
                    SignInView()
                }
            }
        }
        .environment(authViewModel)
    }
}


#Preview {
    ContentView()
}
