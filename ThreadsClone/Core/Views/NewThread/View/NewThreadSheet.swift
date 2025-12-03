import SwiftUI
import PhotosUI

struct NewThreadSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var threadText = ""
    @State private var isDialogPresented = false
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var selectedIndexForDeletion: Int?
    
    @State private var newThreadViewModel = NewThreadViewModel()
    
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
                    Task {
                        await newThreadViewModel.createThread(text: threadText)
                    }
                } label: {
                    Text("Post")
                        .fontWeight(.semibold)
                }
                .disabled(!isAbleToPost || newThreadViewModel.isLoading)
            }
            .padding()
            
            Divider()
                .background(Colors.divider)
            
            HStack(alignment: .top, spacing: 14) {
                let isValidImageUrl = authViewModel.user?.imageUrl != nil && authViewModel.user?.imageUrl != ""
                
                ProfileImage(
                    imageUrl: isValidImageUrl ? authViewModel.user?.imageUrl : nil,
                    isMe: false,
                    size: 34
                )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(authViewModel.username)
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
        .onChange(of: newThreadViewModel.status) { _, newValue in
            if newValue == LoadingStatusEnum.loaded {
                selectedTab = 0
                dismiss()
                threadText = ""
            }
        }
    }
}

#Preview {
    NewThreadSheet(selectedTab: .constant(0))
        .environment(AuthViewModel())
}
