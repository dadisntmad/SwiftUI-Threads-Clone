import SwiftUI

struct ThreadDetailsView: View {
    @State private var threadText = ""
    
    let thread: ThreadModel
    
    var body: some View {
        VStack {
            BackButton()
            
            Spacer()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    ThreadContainer(thread: thread)
                        .padding()
                    
                    Divider()
                        .background(Colors.divider)
                }
                
                LazyVStack {
                    ForEach(0..<25) { _ in
                        ThreadContainer(thread: thread)
                            .padding()
                        
                        Divider()
                            .background(Colors.divider)
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            
            TextField("Reply to \(thread.user?.username ?? "this thread")", text: $threadText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 100))
                .padding([.horizontal, .bottom], 12)
                .submitLabel(.send)
                .onSubmit {
                    
                }
        }
    }
}

#Preview {
    ThreadDetailsView(thread: ThreadModel.data[0])
        .environment(AuthViewModel())
}
