import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    
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
                    action: {},
                    label: "Sign Up"
                )
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
    }
}

#Preview {
    SignUpView()
}
