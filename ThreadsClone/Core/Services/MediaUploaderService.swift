import UIKit
import FirebaseAuth
import FirebaseStorage

final class MediaUploaderService {
    static func upload(folderName: String, image: UIImage?) async throws -> String? {
        let auth = Auth.auth()
        let storage = Storage.storage()
        
        guard let uid = auth.currentUser?.uid else { return nil }
        
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return nil }
        
        let fileName = UUID().uuidString
        
        let ref = storage.reference(withPath: "\(uid)/\(folderName)/\(fileName)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        do {
            let _ = try await ref.putDataAsync(imageData, metadata: metadata)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            debugPrint("DEBUG: Failed to uplodate an image \(error.localizedDescription)")
            return nil
        }
    }
}
