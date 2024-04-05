//
//  createButton.swift
//  DialysisPlus
//
//  Created by user1 on 16/01/24.
//

import Foundation
import SwiftUI
import Firebase

private func formatDouble(_ value: Double) -> String {
    return String(format: "%.1f", value)
}

func createButton(
        imageName: String,
        dailyIntakeManager : dailyIntakeManager,
        title: String,
        na: Double,
        k: Double,
        action: @escaping (String) -> Void) -> some View {
    
        Button(action: {
            action(title)
        }) {
        HStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            Text(title)
                .font(.title3)
                .bold()
         
            
            Spacer()
            
            HStack {
                
                Text("K:"+String(format: "%.1f", calculatePercentage(consumed: k, total: dailyIntakeManager.dailyIntake.totalK)) + "%")
                Text("Na:"+String(format: "%.1f", calculatePercentage(consumed: na, total: dailyIntakeManager.dailyIntake.totalNa)) + "%")
            }
            .padding(.top, 25)
        }
        .padding(10)
        .foregroundColor(Color("customBlack"))
    }
    .background(Color("customLightGray")) // Replace with your desired background color
    .cornerRadius(20)
    .frame(width: 350, height: 35)
}

