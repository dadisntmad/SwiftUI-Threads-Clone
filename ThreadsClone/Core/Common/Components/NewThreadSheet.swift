import SwiftUI
import PhotosUI

struct NewThreadSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var threadText = ""
    @State private var isDialogPresented = false
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var selectedIndexForDeletion: Int?
    
    @Binding var selectedTab: Int
    
    private var isAbleToPost: Bool {
        !threadText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    selectedTab = 0
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .tint(Colors.tintColor)
                
                Spacer()
                
                Text("New Thread")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Colors.title)
                
                Spacer()
                
                Button {
                    selectedTab = 0
                    dismiss()
                    threadText = ""
                } label: {
                    Text("Post")
                        .fontWeight(.semibold)
                }
                .disabled(!isAbleToPost)
            }
            .padding()
            
            Divider()
                .background(Colors.divider)
            
            HStack(alignment: .top, spacing: 14) {
                ProfileImage(
                    imageUrl: "https://images.pexels.com/photos/32948745/pexels-photo-32948745.jpeg",
                    isMe: false,
                    size: 34
                )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("username")
                        .font(.subheadline)
                    
                    TextField(
                        "Start a thread...",
                        text: $threadText,
                        axis: .vertical
                    )
                    .font(.subheadline)
                    .padding(.bottom)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 75, height: 75)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(.bottom)
                                    .onTapGesture {
                                        selectedIndexForDeletion = index
                                        isDialogPresented = true
                                    }
                            }
                        }
                    }
                    .confirmationDialog("Select", isPresented: $isDialogPresented) {
                        Button("Delete", role: .destructive) {
                            if let index = selectedIndexForDeletion {
                                selectedImages.remove(at: index)
                            }
                            selectedIndexForDeletion = nil
                        }
                    }
                    
                    PhotosPicker(selection: $selectedItems, matching: .images) {
                        Image(Icons.attach)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 18, height: 18)
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .onChange(of: selectedItems) { _, newItems in
            selectedItems.removeAll()
            for item in newItems {
                item.loadTransferable(type: Data.self) { result in
                    if case .success(let data?) = result {
                        if let image = UIImage(data: data) {
                            selectedImages.append(image)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NewThreadSheet(selectedTab: .constant(0))
}
