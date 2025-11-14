import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = true
    
    var body: some View {
        Group {
            if isAuthenticated {
                MainView()
            } else {
                NavigationStack {
                    SignInView()
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
