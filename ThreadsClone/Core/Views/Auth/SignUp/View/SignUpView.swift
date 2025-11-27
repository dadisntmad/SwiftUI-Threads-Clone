import SwiftUI
import AlertToast

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var showToast = false
    
    var isDisabled: Bool {
        email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.count < 5
    }
    
    var body: some View {
        VStack {
            BackButton()
            
            ScrollView(showsIndicators: false) {
                Logo(size: 75)
                    .padding()
                
                AuthTitle(
                    title: "Sign Up",
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
                            try await authViewModel.signUp(
                                email: email,
                                password: password
                            )
                            
                            if authViewModel.errMessage != nil {
                                showToast.toggle()
                            }
                        }
                    },
                    label: "Sign Up",
                    isLoading: authViewModel.isLoading,
                    isDisabled: isDisabled
                )
                .disabled(isDisabled || authViewModel.isLoading)
            }
            .scrollBounceBehavior(.basedOnSize)
            
            Spacer()
            
            Divider()
                .background(Colors.divider)
            
            HStack {
                Text("Already have an account?")
                    .font(.caption)
                
                Button {
                    dismiss()
                } label: {
                    Text("Sign In")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(Colors.buttonBg)
                }
            }
            .padding(.top)
        }
        .navigationDestination(isPresented: Binding(
            get: { authViewModel.didSignUp },
            set: { authViewModel.didSignUp = $0 }
        )) {
            CreateProfileView()
                .navigationBarBackButtonHidden()
        }
        .toast(isPresenting: $showToast) {
            Toast.show(authViewModel.errMessage)
        }
    }
}

#Preview {
    SignUpView()
        .environment(AuthViewModel())
}
