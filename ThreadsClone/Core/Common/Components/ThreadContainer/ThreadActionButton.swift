import SwiftUI

struct ThreadActionButton: View {
    let action: () -> Void
    let icon: String
    let count: Int?
    let size: Double?
    let color: Color?
    
    var body: some View {
        HStack(spacing: 5) {
            Button {
                action()
            } label: {
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size ?? 16, height: size ?? 16)
                    .foregroundStyle(color ?? Colors.buttonBg)
            }
            
            if let count = count, count > 0 {
                Text(String(count))
                    .font(.caption2)
                    .foregroundStyle(Colors.subtitle)
            }
        }
    }
}

#Preview {
    ThreadActionButton(
        action: {},
        icon: Icons.heart,
        count: 3,
        size: 16,
        color: .red,
    )
}
