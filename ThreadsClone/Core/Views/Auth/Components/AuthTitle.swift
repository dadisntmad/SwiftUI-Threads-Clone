import SwiftUI

struct AuthTitle: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.title)
                .bold()
                .foregroundStyle(.primary)
            
            Text(subtitle)
                .font(.footnote)
                .foregroundStyle(Colors.subtitle)
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}

#Preview {
    AuthTitle(title: "Sign In", subtitle: "Enter your email and password")
}
