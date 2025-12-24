import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(Icons.chevronLeft)
                .renderingMode(.template)
                .foregroundStyle(Colors.tintColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
    }
}

#Preview {
    BackButton()
}
