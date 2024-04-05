//
//  StatsTable.swift
//  DialysisPlus
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct StatsTable: View {
    var PotassiumValue:Double
    var SodiumValue:Double
    var FluidValue:Double
    var body: some View {
        
        
        
        ZStack {
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
                    .padding()
                    .bold()
                    
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hexString: "#FFFFFF"))
                        .frame(width: 160, height: 35)
                        .shadow(radius: 2, x: 2, y: 2)
                    
                    HStack(spacing:3) {
                        Circle()
                            .fill(Color(hexString: "#FFDD00"))
                            .frame(width: 17, height: 17)
                        
                        Text("Potassium")
                            .bold()
                        
                        Text(String(format: "%.1f%%", PotassiumValue))
                    }
                }
                
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hexString: "#FFFFFF"))
                        .frame(width: 160, height: 35)
                        .shadow(radius: 2, x: 2, y: 2)
                    
                    HStack(spacing:3) {
                        Circle()
                            .fill(Color(hexString:  "#AACC00"))
                            .frame(width: 17, height: 17)
                        
                        Text("Sodium")
                            .bold()
                        
                        
                        Spacer()
                        Text(String(format: "%.1f%%", SodiumValue))
                    }.padding(.horizontal , 2)
                }
                .frame(maxWidth: 160)
                
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hexString: "#FFFFFF"))
                        .frame(width: 160, height: 35)
                        .shadow(radius: 2, x: 2, y: 2)
                    
                    HStack(spacing:3) {
                        Circle()
                            .fill(Color(hexString: "000AFF"))
                            .frame(width: 17, height: 17)
                        
                        Text("Fluids")
                            .bold()
                        Spacer()
                        Text(String(format: "%.1f%%", FluidValue))
                    }.padding(.horizontal , 2)
                }
                .frame(maxWidth: 160)
                Spacer()
                
                
            }
            .frame(maxHeight: 202)
        }
        
        
        
        
        
        
        
      /*  ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hexString: "#E7E7E7"), Color(hexString: "#F5F5F5")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            .frame(width: 170, height: 202)
        }
        VStack{
            Text("Todays Status")
                .offset(y:-185)
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hexString: "#FFFFFF"))
                    .frame(width: 155, height: 35)
                    .shadow(radius: 2, x: 2, y: 2)
                    .offset(x: 50, y: 60)
                
                HStack(spacing:3) {
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
                    .frame(width: 155, height: 35)
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
                    .frame(width: 155, height: 35)
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
*/
        
    }
}

#Preview{
StatsTable(PotassiumValue: 34.2, SodiumValue: 34.3, FluidValue: 53.2)
}
