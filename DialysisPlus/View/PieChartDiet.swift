//
//  PieChartDiet.swift
//  DialysisPlus
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct PieChartDiet: View {
    var PotassiumValue:Double
    var SodiumValue:Double
    var FluidValue:Double
    
    
    var body: some View {
        
            ZStack {
                Circle()
                    .trim(from: 0.0, to: FluidValue/100)
                    .stroke(Color(hexString: "000AFF"), lineWidth: 25)
                    .frame(width: 50, height: 50)
                    .rotationEffect(Angle(degrees: -90))
                
                Circle()
                    .trim(from: 0.0, to: SodiumValue / 100 )
                    .stroke(Color(hexString: "AACC00"), lineWidth: 25)
                    .frame(width: 100, height: 100)
                    .rotationEffect(Angle(degrees: -90))
                
                
                Circle()
                    .trim(from: 0.0, to: PotassiumValue / 100)
                    .stroke(Color(hexString: "FFDD00"), lineWidth: 25)
                    .frame(width: 150 , height: 150)
                    .rotationEffect(Angle(degrees: -90))
                
            }
            
        }
    }

#Preview {
    PieChartDiet(PotassiumValue: 43.2, SodiumValue: 83.2, FluidValue: 53.2)
}
