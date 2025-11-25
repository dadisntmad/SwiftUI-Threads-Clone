import SwiftUI
import PhotosUI

struct CreateProfileView: View {
    @State private var name = ""
    @State private var bio = ""
    @State private var link = ""
    
    @State private var isDialogPresented = false
    
    @State private var imagePickerService = ImagePickerService()
    
    var body: some View {
        VStack {
            BackButton()
            
            Spacer()
            
            ScrollView(showsIndicators: false) {
                AuthTitle(
                    title: "Profile",
                    subtitle: "Customize your Threads profile"
                )
                
                CustomForm {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Name")
                                    .fontWeight(.bold)
                                
                                TextField("+ Add name", text: $name)
                                
                                Divider()
                                    .background(Colors.divider)
                                    .padding(.vertical, 4)
                            }
                            
                            if let selectedImage = imagePickerService.profileImage {
                                Button {
                                    isDialogPresented = true
                                } label: {
                                    selectedImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipShape(Circle())
                                }
                                .confirmationDialog("Select", isPresented: $isDialogPresented) {
                                    Button(role: .destructive) {
                                        imagePickerService.deleteImage()
                                        isDialogPresented = false
                                    } label: {
                                        Text("Delete")
                                    }
                                    
                                }
                                
                            } else {
                                PhotosPicker(selection: $imagePickerService.selectedImage) {
                                    ProfileImage(
                                        imageUrl: nil,
                                        isMe: true,
                                        size: 48
                                    )
                                    .tint(Colors.tintColor)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Bio")
                                .fontWeight(.bold)
                            
                            TextField("+ Add bio", text: $bio)
                            Divider()
                                .background(Colors.divider)
                                .padding(.vertical, 4)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Link")
                                .fontWeight(.bold)
                            
                            TextField("+ Add link", text: $link)
                                .textInputAutocapitalization(.never)
                                .foregroundStyle(Colors.primaryBlue)
                        }
                    }
                }
                
                AuthButton(
                    action: {},
                    label: "Next",
                    isLoading: false,
                    isDisabled: false
                )
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    CreateProfileView()
}
