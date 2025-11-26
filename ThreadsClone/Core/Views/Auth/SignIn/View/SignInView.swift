import SwiftUI

struct SignInView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    var isDisabled: Bool {
        email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.count < 5
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                Logo(size: 75)
                    .padding()
                
                AuthTitle(
                    title: "Sign In",
                    subtitle: "Enter your email and password"
                )
                
                CustomForm {
                    AuthForm(
                        email: $email,
                        password: $password
                    )
                }
                
                AuthButton(
                    action: {
                        Task {
                            try await authViewModel.signIn(
                                email: email,
                                password: password
                            )
                        }
                    },
                    label: "Sign In",
                    isLoading: authViewModel.isLoading,
                    isDisabled: isDisabled || authViewModel.isLoading
                )
            }
            .scrollBounceBehavior(.basedOnSize)
            
            Spacer()
            
            Divider()
                .background(Colors.divider)
            
            HStack {
                Text("Don't have an account?")
                    .font(.caption)
                
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Sign Up")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(Colors.buttonBg)
                }
            }
            .padding(.top)
        }
        .navigationDestination(isPresented: Binding(get: { authViewModel.didSignIn }, set: { authViewModel.didSignIn = $0 })) {
            MainView()
                .navigationBarBackButtonHidden()
        }
    }
}


#Preview {
    SignInView()
        .environment(AuthViewModel())
}
