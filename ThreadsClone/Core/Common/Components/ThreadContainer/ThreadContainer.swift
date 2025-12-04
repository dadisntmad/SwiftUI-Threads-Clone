import SwiftUI
import Kingfisher

struct ThreadContainer: View {
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var isLiked = false
    @State private var showHeart = false
    
    let thread: ThreadModel
    
    private func toggleLike() {
        isLiked.toggle()
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            let imageUrl = thread.user?.imageUrl
            let isImageUrlValid = imageUrl != nil && !(imageUrl?.isEmpty ?? false)
            
            ProfileImage(
                imageUrl: isImageUrlValid ? imageUrl : nil,
                isMe: false,
                size: 36
            )
            
            VStack(alignment: .leading) {
                // author
                HStack {
                    Text(thread.user?.username ?? "")
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
                Text(thread.text)
                    .font(.body)
                    .padding(.bottom)
                
                if !thread.imageUrls.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(thread.imageUrls, id: \.self) { imageUrl in
                                KFImage(URL(string: imageUrl ?? ""))
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
                    Button {
                        withAnimation {
                            toggleLike()
                        }
                    } label: {
                        HStack(spacing: 5) {
                            ZStack {
                                Image(isLiked ? Icons.heartFilled : Icons.heart)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(isLiked ? Color.red : Colors.buttonBg)
                                
                                Image(Icons.heartFilled)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.red)
                                    .offset(x: 0, y: isLiked ? 0 : -24)
                                    .opacity(isLiked ? 1 : 0)
                            }
                            if !thread.likes.isEmpty {
                                Text(String(5))
                                    .font(.caption2)
                                    .foregroundStyle(Colors.subtitle)
                            }
                            
                        }
                    }
                    
                    ThreadActionButton(
                        action: {},
                        icon: Icons.message,
                        count: thread.comments.count,
                        size: nil,
                        color: nil,
                    )
                    
                    ThreadActionButton(
                        action: {},
                        icon: Icons.repost,
                        count: thread.reposts.count,
                        size: 14,
                        color: nil,
                    )
                    
                    ThreadActionButton(
                        action: {},
                        icon: Icons.send,
                        count: nil,
                        size: 14,
                        color: nil,
                    )
                }
            }
        }
    }
}

#Preview {
    ThreadContainer(
        thread: ThreadModel.data[0]
    )
    .environment(AuthViewModel())
}
