import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var selectedSection: ProfileSectionEnum = .threads
    @State private var profileViewModel = ProfileViewModel()
    
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            VStack {
                Logo(size: 24)
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(authViewModel.user?.fullName ?? "")
                                    .font(.title)
                                    .bold()
                                
                                Text(authViewModel.username)
                                    .fontWeight(.medium)
                                
                                if let bio = authViewModel.user?.bio {
                                    Text(bio)
                                }
                                
                                if let link = authViewModel.user?.link,
                                   let url = URL(string: link) {
                                    
                                    Link(link, destination: url)
                                        .font(.footnote)
                                        .foregroundStyle(.blue)
                                }
                            }
                            .font(.body)
                            
                            Spacer()
                            
                            ProfileImage(
                                imageUrl: (authViewModel.user?.isImageUrlValid ?? false) ? authViewModel.user?.imageUrl : nil,
                                isMe: false,
                                size: 64
                            )
                        }
                        .padding()
                        
                        HStack {
                            if let followersCount = authViewModel.user?.followersCount {
                                Text("\(followersCount == 1 ? "1 follower" : "\(followersCount) followers")")
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
                        
                        NavigationLink {
                            CreateProfileView(
                                subtitle: "Update your Threads profile",
                                buttonLabel: "Update",
                                isUpdateProfileView: true
                            )
                            .navigationBarBackButtonHidden()
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
                            let threads = selectedSection.threads(from: profileViewModel)
                            
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
}

#Preview {
    ProfileView()
        .environment(AuthViewModel())
}
