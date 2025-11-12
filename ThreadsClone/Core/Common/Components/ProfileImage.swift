import SwiftUI
import Kingfisher

struct ProfileImage: View {
    let imageUrl: String?
    let isMe: Bool
    let size: Double
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let imageUrl = imageUrl {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                
            } else {
                Circle()
                    .fill(Colors.avatarBg)
                    .frame(width: size, height: size)
                    .overlay {
                        Image(Icons.profileFilled)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                    }
            }
            
            if isMe {
                Circle()
                    .frame(width: 14, height: 14)
                    .overlay {
                        Image(systemName: Icons.plus)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Colors.background)
                            .frame(width: 7, height: 7)
                    }
            }
        }
    }
}

#Preview {
    ProfileImage(
        imageUrl: "https://images.pexels.com/photos/32948745/pexels-photo-32948745.jpeg",
        isMe: false,
        size: 48
    )
}

