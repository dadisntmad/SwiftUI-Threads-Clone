import SwiftUI
import PhotosUI
import Observation

@Observable
class ImagePickerService {
    var selectedImage: PhotosPickerItem? {
        didSet {  Task { await pickImage(from: selectedImage) } }
    }
    
    var profileImage: Image?
    private var uiImage: UIImage?
    
    
    private func pickImage(from item: PhotosPickerItem?) async {
        guard let item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        
        guard let uiImage = UIImage(data: data) else { return }
        
        self.uiImage = uiImage
        
        profileImage = Image(uiImage: uiImage)
    }
    
    func deleteImage() {
        selectedImage = nil
        profileImage = nil
    }
}
