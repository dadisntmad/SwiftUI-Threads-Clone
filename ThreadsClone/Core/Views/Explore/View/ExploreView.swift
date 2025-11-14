import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    
    var body: some View {
        List {
            ForEach(0..<15) { _ in
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
                    
                    Button {
                        
                    } label: {
                        Text("Follow")
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Colors.title)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Colors.buttonBorder, lineWidth:  1)
                            }
                    }
                }
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Search")
    }
}

#Preview {
    ExploreView()
}
