import SwiftUI

struct AuthForm: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
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
}

#Preview {
    AuthForm(email: .constant(""), password: .constant(""))
}
