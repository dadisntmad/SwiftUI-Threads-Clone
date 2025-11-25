import SwiftUI

struct ContentView: View {
    @State private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainView()
            } else {
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
