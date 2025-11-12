import SwiftUI
import PhotosUI

struct CreateProfileView: View {
    @State private var name = ""
    @State private var bio = ""
    @State private var link = ""
    
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
                            selectedImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())
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
                .padding()
                .font(.caption)
                .background(Colors.formBg, in: RoundedRectangle(cornerRadius: 18))
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Colors.formBorder, lineWidth: 1.5)
                }
                .padding()
                
                AuthButton(
                    action: {},
                    label: "Next"
                )
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    CreateProfileView()
}
