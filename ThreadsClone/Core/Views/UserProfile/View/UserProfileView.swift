import SwiftUI

struct UserProfileView: View {
    let user: UserModel
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var selectedSection: ProfileSectionEnum = .threads
    @State private var userProfileViewModel: UserProfileViewModel
    
    @Namespace private var animation
    
    init(user: UserModel) {
        self.user = user
        userProfileViewModel = UserProfileViewModel(uid: user.uid)
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    BackButton()
                    Spacer()
                }
                Logo(size: 24)
            }
            
            Spacer()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(user.fullName)
                                .font(.title)
                                .bold()
                            
                            Text(user.username)
                                .fontWeight(.medium)
                            
                            if let bio = user.bio {
                                Text(bio)
                            }
                            
                            if let link = user.link,
                               let url = URL(string: link) {
                                
                                Link(link, destination: url)
                                    .font(.footnote)
                                    .foregroundStyle(.blue)
                            }
                        }
                        .font(.body)
                        
                        Spacer()
                        
                        ProfileImage(
                            imageUrl: user.isImageUrlValid ? user.imageUrl : nil,
                            isMe: false,
                            size: 64
                        )
                    }
                    .padding()
                    
                    HStack {
                        if user.followersCount > 0 {
                            Text("\(user.followersCount == 1 ? "1 follower" : "\(user.followersCount) followers")")
                                .font(.caption)
                                .foregroundStyle(Colors.subtitle)
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(Icons.menuCircle)
                            
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        
                    }, label: {
                        Text("Follow")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Colors.buttonBg, in: RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(colorScheme == .light ? .white : .black)
                    })
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
                        let threads = selectedSection.threads(from: userProfileViewModel)
                        
                        if threads.isEmpty {
                            Text(selectedSection.placeholder())
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        } else {
                            ForEach(threads) { thread in
                                ThreadContainer(thread: thread)
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
}

#Preview {
    UserProfileView(user: UserModel.testUser)
}
