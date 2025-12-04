import SwiftUI

struct FeedView: View {
    @State private var feedViewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Logo(size: 28)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(feedViewModel.threads) { thread in
                            ThreadContainer(thread: thread)
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
