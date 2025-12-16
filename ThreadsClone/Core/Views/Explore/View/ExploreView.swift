import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @State private var exploreViewModel = ExploreViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(exploreViewModel.users) { user in
                        HStack {
                            HStack(alignment: .top, spacing: 16) {
                                let isValid = user.imageUrl != nil && !(user.imageUrl?.isEmpty ?? false)
                                
                                ProfileImage(
                                    imageUrl: isValid ? user.imageUrl : nil,
                                    isMe: false,
                                    size: 36
                                )
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(user.username)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                    
                                    Text(user.fullName)
                                        .font(.caption)
                                        .foregroundStyle(Colors.subtitle)
                                        .padding(.bottom, 4)
                                    
                                    Text("\(user.followers.count) Followers")
                                        .font(.footnote)
                                }
                                .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            BorderedButton(action: {}, label: "Follow")
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        
                        Divider()
                            .padding(.leading, 70)
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search")
        }
    }
}

#Preview {
    ExploreView()
}
