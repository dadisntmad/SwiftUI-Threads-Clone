import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var selectedSection: ProfileSectionEnum = .threads
    
    @Namespace private var animation
    
    
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
                        
                        GeometryReader { geometry in
                            let count = CGFloat(ProfileSectionEnum.allCases.count)
                            let width = geometry.size.width / count - 5
                            
                            VStack {
                                HStack {
                                    ForEach(ProfileSectionEnum.allCases, id: \.id) { section in
                                        VStack {
                                            Text(section.title)
                                                .font(.subheadline)
                                                .foregroundStyle(selectedSection == section ? Colors.title : Colors.subtitle)
                                                .fontWeight(selectedSection == section ? .semibold : .regular)
                                            
                                            if selectedSection == section {
                                                Rectangle()
                                                    .frame(width: width, height: 1)
                                                    .matchedGeometryEffect(id: "item", in: animation)
                                            } else {
                                                Rectangle()
                                                    .fill(.clear)
                                                    .frame(width: width, height: 1)
                                            }
                                        }
                                        .onTapGesture {
                                            withAnimation {
                                                selectedSection = section
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                        
                        LazyVStack {
                            ForEach(0..<25, id: \.self) { _ in
                                ThreadContainer()
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
