import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    
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
                    action: {},
                    label: "Sign In",
                    isLoading: false,
                    isDisabled: false
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
    }
}


#Preview {
    SignInView()
}
