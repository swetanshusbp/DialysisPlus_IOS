//
//  DietLevelView.swift
//  DialysisPlus
//
//  Created by user1 on 16/01/24.
//

import SwiftUI
import Firebase

struct DietLevelView: View {
    @State private var currentTime = Date()
    @EnvironmentObject var dailyIntakeManager: dailyIntakeManager
    @State private var refreshFlag = false
    var food1 = FoodItem(name: "Bread", potassium: 45.3, sodium: 23.1)
    @State var dietInfo : [[String : Any]] = [[:]]
    @State var sodium : Double = 0.0
    @State var potassium : Double = 0.0
    
    var body: some View {
       
        HStack {
            VStack {
                CircularGraph(
                    percent: calculatePercentage(
                        consumed:  potassium,
                        total: dailyIntakeManager.dailyIntake.totalK
                    ),
                    color: getColorForPercentage(
                        calculatePercentage(
                            consumed: potassium ,
                            total: dailyIntakeManager.dailyIntake.totalK

                        )
                    ),
                    isPotassium: true
                )
                
                
                Text("\(Int(potassium)) mg / \(Int(dailyIntakeManager.dailyIntake.totalK)) mg")
            }
            
            VStack {
                CircularGraph(
                    percent: calculatePercentage(
                        consumed: sodium ,
                        total: dailyIntakeManager.dailyIntake.totalNa
                    ),
                    color: getColorForPercentage(
                        calculatePercentage(
                            consumed: sodium,
                            total: dailyIntakeManager.dailyIntake.totalNa
                        )
                    ),
                    isPotassium: false
                )
                
                Text("\(Int(sodium)) mg / \(Int(dailyIntakeManager.dailyIntake.totalNa)) mg")
            }
        }
        .onChange(of: dailyIntakeManager.dailyIntake.dataAdded, {
            
            self.potassium  += dailyIntakeManager.dailyIntake.uK
            self.sodium  += dailyIntakeManager.dailyIntake.uNa
//            FirestoreHelper().getDietInfo { items in
//                if let items = items {
//                    //print([items])
//                    self.dietInfo = [items]
//                    
//                }
//                
//                for mealInfo in dietInfo {
//                    for (mealType, mealData) in mealInfo {
//                        guard let mealDataDict = mealData as? [String: Any] else {
//                            continue // Skip if it's not a valid dictionary
//                        }
//                        
//                        // Access specific values like potassiumContent and sodiumContent
//                        if let potassiumContent = mealDataDict["potassiumContent"] as? Double {
//                            self.potassium += potassiumContent
//                        }
//                        
//                        if let sodiumContent = mealDataDict["sodiumContent"] as? Double {
//                            self.sodium += sodiumContent
//                        }
//                    }
//                }
//            }
        }
        )
      

        .onAppear {
            
            self.potassium = 0
            self.sodium = 0
            FirestoreHelper().getDietInfo { items in
                if let items = items {
                    //print([items])
                    self.dietInfo = [items]
                    
                }
                
                for mealInfo in dietInfo {
                    for (mealType, mealData) in mealInfo {
                        guard let mealDataDict = mealData as? [String: Any] else {
                            continue // Skip if it's not a valid dictionary
                        }
                        
                        // Access specific values like potassiumContent and sodiumContent
                        if let potassiumContent = mealDataDict["potassiumContent"] as? Double {
                            self.potassium += potassiumContent
                        }
                        
                        if let sodiumContent = mealDataDict["sodiumContent"] as? Double {
                            self.sodium += sodiumContent
                        }
                    }
                }
            }
            
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                currentTime = Date()
                            }
                            // Make sure to invalidate the timer when the view disappears
                            RunLoop.current.add(timer, forMode: .common)
        }
        
        .padding()
    }
}

#Preview {
    DietLevelView()
        .environmentObject(dailyIntakeManager())
}
