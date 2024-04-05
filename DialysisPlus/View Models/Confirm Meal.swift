//
//  Confirm Meal.swift
//  DialysisPlus
//
//  Created by user1 on 16/01/24.
//

import SwiftUI

struct ConfirmMealView: View {
    @State private var searchText = ""
    @State private var mealDetected = "Sandwich"
    
    var body: some View {
        NavigationView {
            VStack {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 400, maxHeight: 0)
                    .offset(y: -10)

                                    
                VStack {
                    
                    Image("sample")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .overlay(
                            Circle()
                                .stroke(Color(hexString: "FFC600"), lineWidth: 5)
                        )
                        .clipShape(Circle())
                        .padding(.top, 90)
                    
                    Text(mealDetected)
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
  
                    
                    NavigationLink(destination: NutritionView()) {
                        Text("Confirm")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.accentColor)
                            .cornerRadius(25)
                    }
                    
                    Text("Or Search for your meal")
                        .foregroundColor(.gray)
                        .padding()
                    
                    // Search Bar
                    TextField("Search for your meal", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                .cornerRadius(20)
                .padding(.top, -30)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                
                Spacer()
            }
        }
        .navigationBarTitle(" ", displayMode: .inline) 
    }
}

#if DEBUG
struct ConfirmMealView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmMealView()
    }
}
#endif



