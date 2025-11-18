import SwiftUI

struct NewThreadSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var threadText = ""
    @State private var isDialogPresented = false
    
    @Binding var selectedTab: Int
    
    private var isAbleToPost: Bool {
        !threadText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    selectedTab = 0
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .tint(Colors.tintColor)
                
                Spacer()
                
                Text("New Thread")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Colors.title)
                
                Spacer()
                
                Button {
                    selectedTab = 0
                    dismiss()
                    threadText = ""
                } label: {
                    Text("Post")
                        .fontWeight(.semibold)
                }
                .disabled(!isAbleToPost)
            }
            .padding()
            
            Divider()
                .background(Colors.divider)
            
            HStack(alignment: .top, spacing: 14) {
                ProfileImage(
                    imageUrl: "https://images.pexels.com/photos/32948745/pexels-photo-32948745.jpeg",
                    isMe: false,
                    size: 34
                )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("username")
                        .font(.subheadline)
                    
                    TextField(
                        "Start a thread...",
                        text: $threadText,
                        axis: .vertical
                    )
                    .font(.subheadline)
                    .padding(.bottom)
                    
                }
            }
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    NewThreadSheet(selectedTab: .constant(0))
}
