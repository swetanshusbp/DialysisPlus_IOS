//
//  CombinedComponent.swift
//  Dialysisplus
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct CombinedComponent: View {
    var Potassium_Value:Double
    var Sodium_Value:Double
    var Fluid_Value:Double
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hexString: "#E7E7E7"), Color(hexString: "#F5F5F5")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 170, height: 202)
            VStack{
                Text("Todays Status")
                    .offset(y:-185)
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hexString: "#FFFFFF"))
                        .frame(width: 160, height: 35)
                        .shadow(radius: 2, x: 2, y: 2)
                        .offset(x: 50, y: 60)
                    
                    HStack(spacing:2) {
                        Circle()
                            .fill(Color(hexString: "#FFDD00"))
                            .frame(width: 17, height: 17)
                        
                        Text("Potassium")
                        Text(String(format: "%.1f%%", Potassium_Value))
                    }
                    .offset(x: 50, y: 67)
                }
                .offset(x:-50 , y:-240)
                
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hexString: "#FFFFFF"))
                        .frame(width: 160, height: 35)
                        .shadow(radius: 2, x: 2, y: 2)
                        .offset(x: 50, y: 60)
                    
                    HStack {
                        Circle()
                            .fill(Color(hexString: "#AACC00"))
                            .frame(width: 17, height: 17)
                            .offset(x:-4)
                        Text("Sodium")
                            .offset(x:-9)
                        Text(String(format: "%.1f%%", Sodium_Value))
                            .offset(x:4)
                    }
                    .offset(x: 50, y: 67)
                }
                .offset(x:-50 , y:-240)
                
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hexString: "#FFFFFF"))
                        .frame(width: 160, height: 35)
                        .shadow(radius: 2, x: 2, y: 2)
                        .offset(x: 50, y: 60)
                    
                    HStack {
                        Circle()
                            .fill(Color(hexString: "000AFF"))
                            .frame(width: 17, height: 17)
                            .offset(x:-14)
                        
                        Text("Fluid")
                            .offset(x:-19)
                        Text(String(format: "%.1f%%", Fluid_Value))
                            .offset(x:14)
                    }
                    .offset(x: 50, y: 67)
                }
                .offset(x:-50 , y:-240)
            }
        }
    }
    }

#Preview {
    CombinedComponent(Potassium_Value: 50, Sodium_Value: 100, Fluid_Value: 100)
}
