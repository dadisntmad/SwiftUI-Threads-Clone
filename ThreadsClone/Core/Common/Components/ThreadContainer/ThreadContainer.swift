import SwiftUI
import Kingfisher

struct ThreadContainer: View {
    private var images = [
        "https://images.pexels.com/photos/34629969/pexels-photo-34629969.jpeg",
        "https://images.pexels.com/photos/15112647/pexels-photo-15112647.jpeg",
        "https://images.pexels.com/photos/30097108/pexels-photo-30097108.jpeg"
    ]
    
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
                
                if !images.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(images, id: \.self) { imageUrl in
                                KFImage(URL(string: imageUrl))
                                    .resizable()
                                    .aspectRatio(1.0, contentMode: .fill)
                                    .frame(width: 250, height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .clipped()

                            }
                        }
                    }
                    .frame(height: 300)
                    .scrollTargetBehavior(.paging)
                    .padding([.trailing, .bottom])
                }
                
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
