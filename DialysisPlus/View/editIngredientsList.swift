//
//  addIngredientView.swift
//  DialysisPlus
//
//  Created by user1.0 on 25/02/24.
//

import SwiftUI
import GoogleGenerativeAI


struct editIngredientsList: View {
    @EnvironmentObject private var ingredientsManager : Ingredients
       
    @Environment(\.presentationMode) var presentationMode
    
    @State var ingredientName : String
    @State var quantity : String
    @State private var foodDetails: FoodDetails?
    @State private var isLoading = false
    @State private var showAddButton = true // New state variable
    @State private var isDataFetched = false // New state variable
    let units = ["pieces", "teaspoon", "tablespoon", "grams", "milliliters"]
    @State private var selectedUnit = "grams"
    
    var onUpdateIngredient: ((String, String?, Double?, Double? ) -> Void)?

    var body: some View {
 
        
        NavigationView {
            Form {
                Section(header: Text("Ingredient Details")) {
                    Text(ingredientName)
                    HStack {
                        TextField("Quantity", text: $quantity )
                            .keyboardType(.numberPad)
                        Picker("Unit", selection: $selectedUnit) {
                            ForEach(units, id: \.self) { unit in
                                Text(unit)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 100)
                    }
                    
                if let sodium = foodDetails?.totalNutrients.NA.quantity,
                       let potassium = foodDetails?.totalNutrients.K.quantity {
                        Text("Sodium: \(sodium) mg")
                        Text("Potassium: \(potassium) mg")
                    }

                }
                
                

                if isLoading {
                    ProgressView()
                } else {
                    if showAddButton { // Show different button if showAddButton is true
                        Button("Add Ingredient") {
                            fetchData()
                            showAddButton = false
                        }
                        .disabled(ingredientName.isEmpty || quantity.isEmpty)
                    } else { // Show a different button when isLoading is false
                        Button("Done") {
                            let newIngredient = Ingredient(name: ingredientName, quantity: quantity + " " + selectedUnit, sodium:foodDetails?.totalNutrients.NA.quantity , potassium: foodDetails?.totalNutrients.K.quantity)
                                
                            onUpdateIngredient?(ingredientName, quantity + " " + selectedUnit, foodDetails?.totalNutrients.NA.quantity, foodDetails?.totalNutrients.K.quantity  )
                            
                            presentationMode.wrappedValue.dismiss()
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    func fetchData() {
        // Construct the API URL with the entered ingredient
        let formattedIngredient = (quantity + " " + selectedUnit + " " + ingredientName).replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://api.edamam.com/api/nutrition-data?app_id=d9f83bb4&app_key=%2057405defeb496c727903e70d80c5b681&nutrition-type=cooking&ingr=\(formattedIngredient)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create a URL session
        let session = URLSession.shared
        
        // Create a data task
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            if let data = data {
                // Decode the JSON data into FoodDetails model
                do {
                    let decoder = JSONDecoder()
                    let foodDetails = try decoder.decode(FoodDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.foodDetails = foodDetails
                        self.isLoading = false // Set isLoading to false when data is fetched
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
        
        isLoading = true
        task.resume()
    }
    
    
}



#Preview {
    editIngredientsList(ingredientName: "Banana", quantity: "100 g")
        .environmentObject(Ingredients())
}
