//
//  PieChartDiet.swift
//  DialysisPlus
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct PieChartDiet: View {
    var PotassiumValue: Double
    var SodiumValue: Double
    var FluidValue: Double
    
    @State private var animationProgress: Double = 0.0 // Animation state
    
    var body: some View {
        ZStack {
            // Fluid Circle
            Circle()
                .trim(from: 0.0, to: FluidValue / 100)
                .stroke(Color(hexString: "000AFF"), lineWidth: 20)
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 1.0)) // Animation
            
            // Empty Fluid Circle
            Circle()
                .trim(from: FluidValue / 100, to: 1.0)
                .stroke(Color(hexString: "000AFF").opacity(0.2), lineWidth: 20) // Gray with less opacity for empty part
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 1.0)) // Animation
            
            // Sodium Circle
            Circle()
                .trim(from: 0.0, to: SodiumValue / 100)
                .stroke(Color(hexString: "AACC00"), lineWidth: 20)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 1.0)) // Animation
            
            // Empty Sodium Circle
            Circle()
                .trim(from: SodiumValue / 100, to: 1.0)
                .stroke(Color(hexString: "AACC00").opacity(0.2), lineWidth: 20) // Gray with less opacity for empty part
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 1.0)) // Animation
            
            // Potassium Circle
            Circle()
                .trim(from: 0.0, to: PotassiumValue / 100)
                .stroke(Color(hexString: "FFDD00"), lineWidth: 20)
                .frame(width: 150, height: 150)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 1.0)) // Animation
            
            // Empty Potassium Circle
            Circle()
                .trim(from: PotassiumValue / 100, to: 1.0)
                .stroke(Color(hexString: "FFDD00").opacity(0.2), lineWidth: 20) // Gray with less opacity for empty part
                .frame(width: 150, height: 150)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 1.0)) // Animation
        }
    }
}

#Preview {
    PieChartDiet(PotassiumValue: 43.2, SodiumValue: 54.2, FluidValue: 3.2)
}
