import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @State private var isPresented = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("", image: selectedTab == 0 ? Icons.feedFilled : Icons.feed, value: 0) {
                FeedView()
            }
            
            Tab("", image: selectedTab == 1 ? Icons.exploreFilled : Icons.explore, value: 1) {
                ExploreView()
            }
            
            Tab("", image: selectedTab == 2 ? Icons.writeFilled : Icons.write, value: 2) {
                EmptyView()
            }
            
            Tab("", image: selectedTab == 3 ? Icons.heartFilled : Icons.heart, value: 3) {
                NotificationsView()
            }
            
            Tab("", image: selectedTab == 4 ? Icons.profileFilled : Icons.profile, value: 4) {
                ProfileView()
            }
        }
        .sheet(isPresented: $isPresented) {
            NewThreadSheet(selectedTab: $selectedTab)
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 2 {
                isPresented = true
            }
        }
    }
}

#Preview {
    MainView()
}
