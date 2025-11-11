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
                
                // form
                VStack {
                    VStack(alignment: .leading) {
                        Text("Email")
                            .fontWeight(.semibold)
                        
                        TextField("+ Enter your email", text: $email)
                            .frame(height: 24)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                    }
                    
                    Divider()
                        .background(Colors.divider)
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading) {
                        Text("Password")
                            .fontWeight(.semibold)
                        
                        SecureField("+ Enter your password", text: $password)
                            .frame(height: 24)
                    }
                }
                .padding()
                .font(.caption)
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Colors.formBorder, lineWidth: 1.5)
                }
                .padding()
                
                AuthButton(
                    action: {},
                    label: "Sign In"
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
    NavigationStack {
        SignInView()
    }
}
