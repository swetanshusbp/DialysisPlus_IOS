//
//  StatusView.swift
//  DialysisPlus
//
//  Created by Abilasha  on 02/04/24.
//

import SwiftUI

struct StatusView: View {
    var potassiumValue : Double
    var sodiumValue : Double
    var fluidValue : Double
    @EnvironmentObject var dailyIntakeManager : dailyIntakeManager
    var body: some View {
        
        HStack(spacing: 30) {
         
            PieChartDiet(PotassiumValue: potassiumValue, SodiumValue: sodiumValue, FluidValue: fluidValue)
            StatsTable(PotassiumValue: potassiumValue, SodiumValue: sodiumValue, FluidValue: fluidValue)

        }
    }
       
}

struct StatsTable: View {
    var PotassiumValue:Double
    var SodiumValue:Double
    var FluidValue:Double
    var body: some View {
        
        
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    Color("customGray")
//                    LinearGradient(
//                        gradient: Gradient(colors: [Color(hexString: "#E7E7E7"), Color(hexString: "#F5F5F5")]),
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
                   // )
                )
            .frame(width: 170, height: 202)
       
            VStack{
                Text("Todays Status")
                    .padding()
                    .bold()
                    
               
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("customWhite"))
                        .frame(width: 160, height: 35)
  
                    
                    HStack(spacing:10) {
            
                        Circle()
                            .fill(Color(hexString:  "#FFDD00"))
                            .frame(width: 17, height: 17)

                        Text("K")
                            .bold()
                        
                        
                        Spacer()
                        Text(String(format: "%.1f%%", PotassiumValue))
                    }.padding(.horizontal , 10)
                }
                .frame(maxWidth: 160)
                
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("customWhite"))
                        .frame(width: 160, height: 35)
  
                    
                    HStack(spacing:10) {
            
                        Circle()
                            .fill(Color(hexString:  "#AACC00"))
                            .frame(width: 17, height: 17)

                        Text("Na")
                            .bold()
                        
                        
                        Spacer()
                        Text(String(format: "%.1f%%", SodiumValue))
                    }.padding(.horizontal , 10)
                }
                .frame(maxWidth: 160)
                
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("customWhite"))
                        .frame(width: 160, height: 35)

                    
                    HStack(spacing:10) {
                        Circle()
                            .fill(Color(hexString: "000AFF"))
                            .frame(width: 17, height: 17)
                       
                        Text("Fluids")
                            .bold()
                     
                        Text(String(format: "%.1f%%", FluidValue))
                    }.padding(.horizontal , 3)
                }
                .frame(maxWidth: 160)
                Spacer()
                
                
            }
            .frame(maxHeight: 202)
        }
    }
}


#Preview {
    StatusView(potassiumValue: 56.3, sodiumValue: 23.4, fluidValue: 100)
        .environmentObject(dailyIntakeManager())
}
