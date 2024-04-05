//
//  ContentView.swift
//  DialysisPlus
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct ContentView: View {
    var potassiumValue : Double
    var sodiumValue : Double
    var fluidValue : Double
    var body: some View {
        
        HStack(spacing: 30) {
         
            PieChartDiet(PotassiumValue: potassiumValue, SodiumValue: sodiumValue, FluidValue: fluidValue)
            StatsTable(PotassiumValue: potassiumValue, SodiumValue: sodiumValue, FluidValue: fluidValue)

        }
    }
       
}


#Preview {
    ContentView(potassiumValue: 56.3, sodiumValue: 23.4, fluidValue: 76.3)
}
