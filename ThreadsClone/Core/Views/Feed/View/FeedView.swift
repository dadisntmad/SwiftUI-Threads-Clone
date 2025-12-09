import SwiftUI

struct FeedView: View {
    @State private var feedViewModel = FeedViewModel()
    
    var body: some View {
        if feedViewModel.isLoading {
            ProgressView()
        } else {
            NavigationStack {
                VStack {
                    Logo(size: 28)
                    
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(feedViewModel.threads) { thread in
                                NavigationLink {
                                    ThreadDetailsView(thread: thread)
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    ThreadContainer(thread: thread)
                                        .padding()
                                        .tint(Colors.tintColor)
                                }
                                
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FeedView()
        .environment(AuthViewModel())
}
