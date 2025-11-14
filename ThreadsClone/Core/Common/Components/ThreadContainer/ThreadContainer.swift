import SwiftUI

struct ThreadContainer: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            ProfileImage(
                imageUrl: "https://images.pexels.com/photos/32948745/pexels-photo-32948745.jpeg",
                isMe: false,
                size: 36
            )
            
            VStack(alignment: .leading) {
                // author
                HStack {
                    Text("john.doe")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("31/10/2025")
                        .font(.caption)
                        .foregroundColor(Colors.subtitle)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(Icons.menu)
                            .renderingMode(.template)
                            .foregroundStyle(Colors.buttonBg)
                    }
                }
                
                // thread
                Text("Let's talk about the incredible power of perseverance and how it can change your life. 🚀 ")
                    .font(.body)
                    .padding(.bottom)
                
                // action buttons
                HStack(spacing: 18) {
                    ThreadActionButton(
                        action: {},
                        icon: Icons.heart,
                        count: 3,
                        size: nil,
                    )
                    
                    ThreadActionButton(
                        action: {},
                        icon: Icons.message,
                        count: 10,
                        size: nil,
                    )
                    
                    ThreadActionButton(
                        action: {},
                        icon: Icons.repost,
                        count: 7,
                        size: 14,
                    )
                    
                    ThreadActionButton(
                        action: {},
                        icon: Icons.send,
                        count: nil,
                        size: 14,
                    )
                }
            }
        }
    }
}

#Preview {
    ThreadContainer()
}
