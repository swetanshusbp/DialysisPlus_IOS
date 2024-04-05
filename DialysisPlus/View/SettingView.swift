//
//  SettingView.swift
//  DialysisPlus
//
//  Created by Abilasha  on 03/03/24.
//

import SwiftUI

struct SettingView: View {
    @State private var profile = Profile(
        name: "John Doe",
        email: "john.doe@example.com",
        gender: "",
        weight: 0.0,
        height: 0.0,
        age: 0,
        sleepTime: Date(),
        wakeUpTime: Date(),
        sodium: 0,
        potassium: 0,
        water: 0,
        image: nil, birthday: Date()
    )
    var body: some View {
        VStack{
            Text("Diet Goal")
                .font(.title3)
            
            HStack {
                
                ZStack(alignment: .topLeading) {
                    Text("Potassium")
                        .font(.subheadline)
                        .frame(maxWidth:80, maxHeight:5)
                        .offset(y: -5)
                        .foregroundColor(.gray)
                        .background(.white)
                    TextField("Potassium", value: $profile.potassium, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .zIndex(-1)
                }
                
                
                
                ZStack(alignment: .topLeading) {
                    Text("Sodium")
                        .font(.subheadline)
                        .frame(maxWidth:60, maxHeight:5)
                        .offset(y: -5)
                        .foregroundColor(.gray)
                        .background(.white)
                    TextField("Sodium", value: $profile.sodium, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .zIndex(-1)
                }
                
            }.padding(.vertical)
            
            Text("Fluid Goal")
                .font(.title3)
            
            
            ZStack(alignment: .topLeading) {
                Text("Fluid")
                    .font(.subheadline)
                    .frame(maxWidth:40, maxHeight:5)
                    .offset(y: -5)
                    .foregroundColor(.gray)
                    .background(.white)
                TextField("Fluid", value: $profile.water, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle()).zIndex(-1)
            }.padding(.vertical)
        }
    }
}

#Preview {
    SettingView()
}

