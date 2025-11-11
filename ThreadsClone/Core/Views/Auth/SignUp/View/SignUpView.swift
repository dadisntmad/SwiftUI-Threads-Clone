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
