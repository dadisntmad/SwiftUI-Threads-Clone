import SwiftUI

struct ContentView: View {
    @State private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            switch authViewModel.authState {
            case .unknown:
                ProgressView()
            case .unauthenticated:
                NavigationStack {
                    SignInView()
                }
            case .needsOnboarding:
                NavigationStack {
                    CreateProfileView(isBackButtonPresented: false)
                        .navigationBarBackButtonHidden()
                }
            case .authenticated:
                MainView()
            }
        }
        .environment(authViewModel)
    }
}


#Preview {
    ContentView()
}
