import SwiftUI

struct NotificationsView: View {
    @State private var notificationsViewModel = NotificationsViewModel()
    
    var body: some View {
        NavigationStack {
            if notificationsViewModel.isLoading {
                ProgressView()
            } else {
                if notificationsViewModel.notifications.isEmpty {
                    Text("You don't have any notifications".capitalized)
                        .font(.title3)
                        .fontWeight(.medium)
                        .frame(maxHeight: .infinity, alignment: .center)
                }
                
                ScrollView(showsIndicators: false) {
                    ForEach(notificationsViewModel.notifications) { notification in
                        VStack {
                            HStack(spacing: 16) {
                                let imageUrl = notification.user?.imageUrl
                                let isImageUrlValid = imageUrl != nil && !(imageUrl?.isEmpty ?? false)
                                
                                ProfileImage(
                                    imageUrl: isImageUrlValid ? imageUrl : nil,
                                    isMe: false,
                                    size: 36
                                )
                                
                                VStack(alignment: .leading) {
                                    let username = notification.user?.username ?? "unknown user"
                                    
                                    HStack(spacing: 4) {
                                        Text(username)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        
                                        Text(notification.createdAt.formatThreadDate())
                                            .font(.caption2)
                                            .foregroundStyle(Colors.subtitle)
                                    }
                                    
                                    Text("\(username) \(notification.message)")
                                        .font(.subheadline)
                                        .foregroundStyle(Colors.subtitle)
                                }
                                Spacer()
                                
                                if notification.type == .follow {
                                    BorderedButton(
                                        action: {},
                                        label: "Follow"
                                    )
                                }
                            }
                            .padding(.horizontal)
                            
                            Divider()
                                .padding(.leading)
                                .padding(.leading, 52)
                                .background(Colors.divider)
                        }
                    }
                }
                .navigationTitle("Activity")
            }
        }
    }
}

#Preview {
    NotificationsView()
}
