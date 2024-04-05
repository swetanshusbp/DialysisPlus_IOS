//
//  AddMeal.swift
//  DialysisPlus
//
//  Created by user1 on 17/01/24.
//

import SwiftUI

struct AddMeal: View {

    @EnvironmentObject var DailyIntakeManager: dailyIntakeManager
    @Environment(\.presentationMode) var presentationMode
    
    @State var foodName : String = ""
    @State var sodium : String = ""
    @State var potassium : String = ""
    
    @State var sodiumContent : Double = 0
    @State var potassiumContent : Double = 0
    
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?
    
    var title : String
    var body: some View {
        
        VStack {
        
            Button(action: {
                isImagePickerPresented.toggle()
            }, label: {
                Image(systemName: "camera")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,height: 100)
                        .background(Color.accentColor)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            })
            .sheet(isPresented: $isImagePickerPresented) {
                                ImagePicker(selectedImage: $selectedImage)
            }
        
        
            Text("Take a photo of your Food")
                .font(.title3)
                .bold()
            
            Text("Or")
                .padding(.vertical)
            
            TextField("Enter your food", text: $foodName)
                .multilineTextAlignment(.center)
                .frame(height: 55 )
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.892, opacity: 0.748))
                .cornerRadius(10)
                .padding(.horizontal)
        }

        HStack {
            TextField("Potassium content", text: $potassium)
                .multilineTextAlignment(.center)
                .frame(height: 55)
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.892, opacity: 0.748))
                .cornerRadius(10)
                .padding(.leading)
    
            TextField("Sodium content", text: $sodium)
                .multilineTextAlignment(.center)
                .frame(height: 55)
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.892, opacity: 0.748))
                .cornerRadius(10)
                .padding(.trailing)
            
        }

        
        Button("Add Meal") {
            potassiumContent = str2double(number: potassium)
            sodiumContent = str2double(number: sodium)
            
            addFood(title: title, foodName: foodName, potassiumContent: potassiumContent, sodiumContent: sodiumContent, DailyIntakeManager: DailyIntakeManager)
            
            presentationMode.wrappedValue.dismiss()
            
        }
        .textCase(.uppercase)
        .foregroundStyle(Color.white)
        .font(.headline)
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .background(Color.accentColor)
        .cornerRadius(10)
        .padding()
        
        Spacer()
        
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .camera
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


#Preview {
    AddMeal(title: "Breakfast")
        .environmentObject(dailyIntakeManager())
}
