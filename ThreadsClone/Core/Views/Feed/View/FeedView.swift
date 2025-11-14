import SwiftUI

struct FeedView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Logo(size: 28)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(0..<15) { _ in
                            ThreadContainer()
                                .padding()
                            
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FeedView()
}
