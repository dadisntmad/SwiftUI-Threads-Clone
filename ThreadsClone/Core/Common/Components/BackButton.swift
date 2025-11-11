import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(Icons.chevronLeft)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
    }
}

#Preview {
    BackButton()
}
