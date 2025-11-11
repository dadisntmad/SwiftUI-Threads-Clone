import SwiftUI

struct AuthButton: View {
    let action: () -> Void
    let label: String
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .font(.callout)
                .fontWeight(.semibold)
                .background(Colors.buttonBg, in: RoundedRectangle(cornerRadius: 16))
                .foregroundStyle(Colors.buttonText)
                .padding(.horizontal)
        }
    }
}

#Preview {
    AuthButton(action: {}, label: "Sign In")
}
