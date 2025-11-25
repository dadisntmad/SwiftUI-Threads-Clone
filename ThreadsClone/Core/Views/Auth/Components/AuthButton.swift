import SwiftUI

struct AuthButton: View {
    let action: () -> Void
    let label: String
    let isLoading: Bool
    let isDisabled: Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isLoading ? Colors.buttonBg.opacity(0.5) : Colors.buttonBg, in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
            } else {
                Text(label)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .background(isDisabled ? Colors.buttonBg.opacity(0.5) : Colors.buttonBg, in: RoundedRectangle(cornerRadius: 16))
                    .foregroundStyle(Colors.buttonText)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    AuthButton(
        action: {},
        label: "Sign In",
        isLoading: false,
        isDisabled: false
    )
}
