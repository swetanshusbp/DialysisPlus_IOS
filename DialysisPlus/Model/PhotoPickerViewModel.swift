//
//  PhotoPickerViewModel.swift
//  DialysisPlus
//
//  Created by Meghs on 03/03/24.
//
import SwiftUI
import Foundation
import PhotosUI
import GoogleGenerativeAI

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelected: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelected)
        }
    }
    
    let model = GenerativeModel(name: "gemini-pro-vision", apiKey: APIKey.default)
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection = selection else { return }
        
        Task {
            do {
                if let data = try await selection.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            } catch {
                print("Error loading image data: \(error)")
            }
        }
    }
    
    func getDescription(completion: @escaping (String?) -> Void) {
        guard let image = selectedImage else {
            print("No image selected")
            completion("No image selected")
            return
        }
        
        let prompt = "Only return this food name. If it is not a food return `Not a food`"
        
        Task {
            do {
                let response = try await model.generateContent(prompt, image)
                
                guard let text = response.text else {
                    print("Sorry, I could not process the image.")
                    completion(nil)
                    return
                }
                completion(text)
            } catch {
                print("Error generating description: \(error)")
                completion(nil)
            }
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = sourceType // Set the source type
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            
            picker.dismiss(animated: true)
        }
    }
}
