import SwiftUI
import PhotosUI
import AlertToast

struct CreateProfileView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var name = ""
    @State private var bio = ""
    @State private var link = ""
    
    @State private var isDialogPresented = false
    @State private var showToast = false
    
    @State private var imagePickerService = ImagePickerService()
    
    let isBackButtonPresented: Bool
    let subtitle: String
    let buttonLabel: String
    let isUpdateProfileView: Bool
    
    init(
        isBackButtonPresented: Bool = true,
        subtitle: String = "Customize your Threads profile",
        buttonLabel: String = "Next",
        isUpdateProfileView: Bool = false
    ) {
        self.isBackButtonPresented = isBackButtonPresented
        self.subtitle = subtitle
        self.buttonLabel = buttonLabel
        self.isUpdateProfileView = isUpdateProfileView
    }
    
    var isDisabled: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack {
            if isBackButtonPresented {
                BackButton()
            }
            
            Spacer()
            
            ScrollView(showsIndicators: false) {
                AuthTitle(
                    title: "Profile",
                    subtitle: subtitle
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
                                    let imageUrl = authViewModel.user?.imageUrl
                                    let isValidImageUrl = imageUrl != nil && !(imageUrl?.isEmpty ?? true)
                                    
                                    ProfileImage(
                                        imageUrl: isValidImageUrl ? imageUrl : nil,
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
                    action: {
                        Task {
                            await authViewModel.onboardUser(
                                fullName: name,
                                bio: bio,
                                link: link,
                                image: imagePickerService.uiImage
                            )
                            
                            if authViewModel.errMessage != nil {
                                showToast.toggle()
                            }
                        }
                    },
                    label: buttonLabel,
                    isLoading: authViewModel.isLoading,
                    isDisabled: isDisabled
                )
                .disabled(isDisabled)
                
                if isUpdateProfileView {
                    Button(role: .destructive) {
                        authViewModel.signOut()
                    } label: {
                        Text("Sign Out")
                    }
                    .padding(.top)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .toast(isPresenting: $showToast) {
            Toast.show(authViewModel.errMessage)
        }
        .onAppear {
            if !isUpdateProfileView {
                return
            }
            
            if let user = authViewModel.user {
                name = user.fullName
                bio = user.bio ?? ""
                link = user.link ?? ""
            }
        }
    }
}

#Preview {
    CreateProfileView(isBackButtonPresented: true)
        .environment(AuthViewModel())
}
