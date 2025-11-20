import SwiftUI

struct BorderedButton: View {
    let action: () -> Void
    let label: String
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Colors.title)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Colors.buttonBorder, lineWidth:  1)
                }
        }
    }
}

#Preview {
    BorderedButton(action: {}, label: "Follow")
}
