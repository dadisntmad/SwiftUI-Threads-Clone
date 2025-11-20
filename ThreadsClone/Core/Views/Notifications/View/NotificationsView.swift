import SwiftUI

struct NotificationsView: View {
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ForEach(0..<25) { _ in
                    VStack {
                        HStack(spacing: 16) {
                            ProfileImage(
                                imageUrl: "https://images.pexels.com/photos/32948745/pexels-photo-32948745.jpeg",
                                isMe: false,
                                size: 36
                            )
                            
                            VStack(alignment: .leading) {
                                HStack(spacing: 4) {
                                    Text("username")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    Text("5m")
                                        .font(.caption2)
                                        .foregroundStyle(Colors.subtitle)
                                }
                                
                                Text("Notification status")
                                    .font(.subheadline)
                                    .foregroundStyle(Colors.subtitle)
                            }
                            Spacer()
                            // TODO: show only if notification status is follows
                            BorderedButton(action: {}, label: "Follow")
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

#Preview {
    NotificationsView()
}
