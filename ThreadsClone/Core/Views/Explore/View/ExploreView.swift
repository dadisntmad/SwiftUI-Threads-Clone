import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ForEach(0..<15) { _ in
                    VStack {
                        HStack {
                            HStack(alignment: .top, spacing: 16) {
                                ProfileImage(
                                    imageUrl: "https://images.pexels.com/photos/32948745/pexels-photo-32948745.jpeg",
                                    isMe: false,
                                    size: 36
                                )
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("john.doe")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                    
                                    Text("John Doe")
                                        .font(.caption)
                                        .foregroundStyle(Colors.subtitle)
                                        .padding(.bottom, 4)
                                    
                                    Text("1k Followers")
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
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search")
        }
    }
}

#Preview {
    ExploreView()
}
