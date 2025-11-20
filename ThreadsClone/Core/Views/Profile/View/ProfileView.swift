import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var sections = [
        "Threads",
        "Replies",
        "Media",
        "Reposts"
    ]
    
    @State private var selectedSection = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Logo(size: 24)
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Full Name")
                                    .font(.title)
                                    .bold()
                                
                                Text("username")
                                    .fontWeight(.medium)
                                
                                Text("Passionate about art, photography, and all things creative 🎨✨")
                                
                                Text("https://www.google.com/")
                                    .font(.footnote)
                                
                            }
                            .font(.body)
                            
                            Spacer()
                            
                            ProfileImage(
                                imageUrl: "https://images.pexels.com/photos/32948745/pexels-photo-32948745.jpeg",
                                isMe: false,
                                size: 64
                            )
                        }
                        .padding()
                        
                        HStack {
                            Text("10 Followers")
                                .font(.caption)
                                .foregroundStyle(Colors.subtitle)
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Image(Icons.menuCircle)
                                
                            }
                        }
                        .padding(.horizontal)
                        
                        Button {
                            
                        } label: {
                            Text("Edit Profile")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Colors.buttonBg, in: RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(colorScheme == .light ? .white : .black)
                        }
                        .padding()
                     
                        HStack {
                            ForEach(Array(sections.enumerated()), id: \.offset) { index, section in
                                Spacer()
                                
                                Button {
                                    selectedSection = index
                                } label: {
                                    Text(section)
                                        .font(.body)
                                        .foregroundStyle(selectedSection == index ? Colors.title : Colors.subtitle)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        Divider()
                            .background(Colors.divider)
                        
                        ForEach(0..<25) { _ in
                            ThreadContainer()
                                .padding()
                            
                            Divider()
                                .background(Colors.divider)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
