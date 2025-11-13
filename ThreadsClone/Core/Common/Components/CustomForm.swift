import SwiftUI

struct CustomForm<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .padding()
        .font(.caption)
        .background(Colors.formBg, in: RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Colors.formBorder, lineWidth: 1.5)
        }
        .padding()
    }
}

#Preview {
    CustomForm {
        EmptyView()
    }
}
