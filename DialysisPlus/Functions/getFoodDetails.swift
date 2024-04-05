//
//  getFoodDetails.swift
//  DialysisPlus
//
//  Created by user1 on 17/01/24.
//

import Foundation
import SwiftUI
import Firebase
private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
}

func getFoodDetails(title: String, mealData : [[String: Any]]  , dailyIntakeManager : dailyIntakeManager) -> some View {

    if mealData.count > 0 {
        var mealInfo = mealData
        return AnyView(
            List {
                ForEach(mealInfo.indices, id: \.self) { index in
                    let item = mealInfo[index]
                    VStack {
                        HStack {
                            Text(item["foodName"] as? String ?? "")
                                .font(.title3)
                            Spacer()
                            Text(item["time"] as? String ?? "")
                        }
                        HStack {
                            Text(String(format: "K: %.2f", item["potassiumContent"] as? Double ?? 0.0) + "g")
                            
                            Text(String(format: "Na: %.2f", item["sodiumContent"] as? Double ?? 0.0) + "g")
                            
                            Spacer()
                            
                            
                        }
                    }
                }
                .onDelete { indexSet in
                    
                    for index in indexSet{
                        if let potassiumContent = mealInfo[index]["potassiumContent"] as? Double {
                            dailyIntakeManager.dailyIntake.uK = -1 * potassiumContent
                        }
                        
                        if let sodiumContent = mealInfo[index]["sodiumContent"] as? Double {
                            dailyIntakeManager.dailyIntake.uNa = -1 * sodiumContent
                        }
                    }
                    mealInfo.remove(atOffsets: indexSet)
                    
                    FirestoreHelper().updateDietDetails(mealType: title, data: mealInfo)
                    
                    
                    
                    dailyIntakeManager.dailyIntake.dataAdded.toggle()
                    
                }
            }
                .listStyle(PlainListStyle())
                .padding(.vertical)
        )
    }
    else {
           return AnyView(EmptyView())
       }
}
