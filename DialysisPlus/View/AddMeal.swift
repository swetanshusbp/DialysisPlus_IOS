//
//  AddMeal.swift
//  DialysisPlus
//
//  Created by user1 on 17/01/24.
//
//
//  AddMeal.swift
//  DialysisPlus
//
//  Created by user1 on 17/01/24.
//

import SwiftUI
import UIKit.UIImage
import GoogleGenerativeAI
import PhotosUI

struct AddMeal: View {
    @Binding var isPresented: Bool
    
    @EnvironmentObject var DailyIntakeManager: dailyIntakeManager
    @Environment(\.presentationMode) var presentationMode
    
    @State var foodName : String = ""
    @State var sodium : String = ""
    @State var potassium : String = ""
    @State var notFood : Bool = false
    @State var sodiumContent : Double = 0
    @State var potassiumContent : Double = 0
    
    @State private var showAlert: Bool = false
    @State private var alertDone : Bool = false
    @State private var alertDoneK : Bool = false
    @State private var alertDoneNa : Bool = false
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?
    
    @State private var isSubmitButtonVisible = true
    @State private var showAddIngredientSheet = false
    
    
    //open edit ingredient View
    @State private var pickerSourceType: UIImagePickerController.SourceType = .camera
    
    // api variables
    
    @State var ingredients : [Ingredient] = []
    
    @State var data : String = ""
    
    @State var check : String = ""

    let prompt = ". Give me the ingredients and used to make this dish in a json format which includes the quantity of the ingredient in grams or mg or count, and the sodium and potassium content. Include salt as an ingredient. Let the name be `ingredients`. Let the format of the elements of ingredients be { name : , quantity : , sodium: , potassium : }. For quantity, just give the value in numerical forms. Every value is in the form of a string. If the entered value is not a food, then return `not a food` in string format. Dont give any wrong answer."
    
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    let visionModel = GenerativeModel(name: "gemini-pro-vision", apiKey: APIKey.default)
    
    @State var isLoading :Bool = false
    @State var modelRunning : Bool = false
    
    @EnvironmentObject var IngredientsManager : Ingredients
    
    @State var Check : Bool = false
    var title : String
    @State private var previewImage: UIImage?
    
    
    //editing ingredients in place
    
    @State var sodiumChanged :Double = 0.0
    @State var potassiumChanged : Double = 0.0
    @State var quantity : String = ""
    @State var nameFoodChanged = ""

    @State var showSheet :Bool = false
    var body: some View {
        NavigationStack{
            ScrollView{
                
            VStack {
                if notFood {
                    Text("The given input is not a food item. Please try again.")
                        .foregroundStyle(Color.red)
                    
                }
                Button(action: {
                    showSheet = true
                }, label: {
                    Image(systemName: "camera")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                })
                .actionSheet(isPresented: $showSheet, content: {
                    ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [
                        .default(Text("Photo Library"), action: {
                            pickerSourceType = .photoLibrary
                            isImagePickerPresented = true
                        }),
                        .default(Text("Camera"), action: {
                            pickerSourceType = .camera
                            isImagePickerPresented = true
                        }),
                        .cancel()
                        
                    ])
                })
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $previewImage, sourceType: pickerSourceType)
                }
                
                if let image = previewImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350)
                        .onAppear{
                            modelRunning = true
                            getDescription(generatedImage: image) {
                                generatedDescription in
                                   if let generatedDescription = generatedDescription {
                                       foodName = generatedDescription
                                       modelRunning = false
                                   }

                            }

                        }
                        
                }

                if modelRunning{
                    ProgressView()
                }
                else{
                    if foodName == "" {
                        Text("Take a photo of your Food")
                            .font(.title3)
                            .bold()
                    }
                    else {
                        if foodName != " Not a food" {
                            Text("Did you have \(foodName)")
                                .font(.title3)
                                .bold()
                        }
                        else{
                            Text("Please enter an image of a food item")
                                .font(.title3)
                                .bold()

                        }
                    }
                }
                
                Text("Or")
                    .padding(.vertical)
            
                
                TextField("Enter your food", text: $foodName)
                    .multilineTextAlignment(.center)
                .frame(height: 55 )
                .cornerRadius(10)
                .padding(.horizontal)

             
                
                if !IngredientsManager.ingredients.isEmpty {
                    HStack {
                        
                        Text(" Na : \(sodium) mg")
                            .multilineTextAlignment(.center)
                            .frame(height: 55)
                            .cornerRadius(10)
                        
                        Text(" K : \(potassium) mg")
                            .multilineTextAlignment(.center)
                            .frame(height: 55)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                
                
                Button(action: {
                    if IngredientsManager.ingredients.isEmpty {
                        calculateIngredients()
                    }
                    
                    else {
                        potassiumContent = str2double(number: potassium)
                        sodiumContent = str2double(number: sodium)
                        addFood(title: title, foodName: foodName, potassiumContent: potassiumContent, sodiumContent: sodiumContent, DailyIntakeManager: DailyIntakeManager)
                        
                        IngredientsManager.ingredients.removeAll()
                        
                        if !DailyIntakeManager.dailyIntake.above75K && !DailyIntakeManager.dailyIntake.above75Na{
//                            isPresented.toggle()
                        }
                        if alertDone || alertDoneK || alertDoneNa {
                            showAlert = false
                        }
                        else {
                            if !DailyIntakeManager.dailyIntake.above75K && DailyIntakeManager.dailyIntake.above75Na {
                                showAlert = true
                                alertDoneNa = true
                            }
                            else  if DailyIntakeManager.dailyIntake.above75K && !DailyIntakeManager.dailyIntake.above75Na {
                                showAlert = true
                                alertDoneK = true
                            }
                            else  if DailyIntakeManager.dailyIntake.above75K && DailyIntakeManager.dailyIntake.above75Na{
                                showAlert = true
                                alertDoneK = true
                            }
                        }
                        isPresented.toggle()
                        
                   }
                }, label: {
                    if isLoading {
                        ProgressView()
                    }
                    else {
                        if IngredientsManager.ingredients.isEmpty {
                            Text("Submit")
                                .frame(width: 100)
                                .padding()
                                .background(Color(.blue))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        
                        else {
                            Text("Add Meal")
                                .frame(width: 100)
                                .padding()
                                .background(Color(.blue))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    }
                }).disabled(foodName.isEmpty)
                
                TextField("Enter your food", text: $foodName)
                    .hidden()
                
                

                if IngredientsManager.ingredients.isEmpty {
                    Text("Empty")
                }
                else{
                    Text("True")
                }
                
                
                if !IngredientsManager.ingredients.isEmpty {
                    
                    NavigationLink {
                        List {
                            ForEach(IngredientsManager.ingredients.indices, id: \.self) { index in
                                var ingredient = IngredientsManager.ingredients[index]
                                NavigationLink(destination: editIngredientsList(ingredientName: ingredient.name, quantity: ingredient.quantity ?? "") { updatedName, updatedQuantity, updatedSodium, updatedPotassium in
                                    
                                    if let updatedIndex = IngredientsManager.ingredients.firstIndex(where: { $0.name == updatedName }) {
                                        IngredientsManager.ingredients[updatedIndex].quantity = updatedQuantity
                                        IngredientsManager.ingredients[updatedIndex].sodium = updatedSodium
                                        IngredientsManager.ingredients[updatedIndex].potassium = updatedPotassium
                                        
                                        
                                        
                                        IngredientsManager.recalculateValues()
                                    }
                                })
                                {
                                    VStack {
                                        HStack{
                                            Text("\(ingredient.name) : \(String(describing: ingredient.quantity ?? "-"))")
                                            Spacer()
                                        }
                                        HStack{
                                            Text("Sodium: \(String(describing: ingredient.sodium ?? 0.0))")
                                            Spacer()
                                            Text("Potassium: \(String(describing: ingredient.potassium ?? 0.0))")
                                            Spacer()
                                        }
                                        
                                        Spacer()
                                    }

                                }
                            }
                            .onDelete { indexSet in
                                IngredientsManager.ingredients.remove(atOffsets: indexSet)
                                
                                IngredientsManager.recalculateValues()
                                sodium = String(IngredientsManager.totalSodium)
                                potassium = String(IngredientsManager.totalPotassium)
                                
                                
                                
                            }
                        }
                        .navigationTitle("Ingredients ")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    showAddIngredientSheet = true
                                }) {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                        .sheet(isPresented: $showAddIngredientSheet) {                    AddIngredientView()
                        }
                        .listStyle(.plain)
                    } label: {
                        Text("Check out the Ingredients used !!")
                    }
                    
                }
             
            }
        }
        .navigationTitle("Add Meal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Close") {
                withAnimation {
                    isPresented.toggle()
                }
            }
            
        }
        .alert(isPresented: $showAlert) {
            
            if !DailyIntakeManager.dailyIntake.above75K && DailyIntakeManager.dailyIntake.above75Na {
                return Alert(
                    title: Text("Alert"),
                    message: Text("Your Sodium intake has reached 75%"),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
            
            else if DailyIntakeManager.dailyIntake.above75K && !DailyIntakeManager.dailyIntake.above75Na {
                return Alert(
                    title: Text("Alert"),
                    message: Text("Your Potassium intake has reached 75%"),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
            
            else {
                return Alert(
                    title: Text("Alert"),
                    message: Text("Your Sodium and Potassium intake has reached 75%"),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
}
    
    func calculateIngredients(){
        
        print(IngredientsManager.ingredients.count)
        
        Task {
            do {
                isLoading = true
                let prompt = foodName + prompt
                
                let response = try await model.generateContent(prompt)
                    
                guard let text = response.text else {
                    data = "Sorry I could not process that"
                    return
                }
                
                
                if text == "not a food"{
                    
                    notFood = true
                    isLoading = false
                        
                }
                else {
                    if let startIndex = text.firstIndex(of: "{"),
                       let endIndex = text.firstIndex(of: "]") {
                        let substring = text[startIndex..<text.index(after: endIndex)]
                        data = String(substring)
                    }
                    print(data)
                    
                    isLoading = false
                    IngredientsManager.parseJSONString(data)
                    potassium = String(IngredientsManager.totalPotassium)
                    sodium = String(IngredientsManager.totalSodium)
                    
                    print(IngredientsManager.ingredients)
                    print(IngredientsManager.ingredients.count)
                    
                }

               
            } catch {
                data = "\(error.localizedDescription)"
            }
        }
    }
    
    func getDescription( generatedImage  : UIImage? ,completion: @escaping (String?) -> Void) {
        guard let image = generatedImage  else {
            print("No image selected")
            completion("No image selected")
            return
        }
        
        let prompt = "Only return this food name. If it is not a food return `Not a food`"
        
        Task {
            do {
                let response = try await visionModel.generateContent(prompt, image)
                
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


#Preview {
    NavigationStack{
        
        AddMeal(isPresented: .constant(false), title: "Breakfast")
            .environmentObject(dailyIntakeManager())
            .environmentObject(Ingredients())
    }
}
