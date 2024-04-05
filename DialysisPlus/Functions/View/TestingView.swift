//
//  TestingView.swift
//  DialysisPlus
//
//  Created by user1 on 17/01/24.
//

import SwiftUI



struct TestingView: View {
    
    @EnvironmentObject var DailyIntakeManager : dailyIntakeManager
    var food1 = FoodItem(name: "Bread", potassium: 45.3, sodium: 23.1)
    
    var body: some View {
        
        
        Button(action: {
            DailyIntakeManager.addFoodItem(mealType: .breakfast, foodItem: food1)
        }, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
        
        Text("\(DailyIntakeManager.dailyIntake.totalPotassium)")
        
        
    }
}

#Preview {
    TestingView()
        .environmentObject(dailyIntakeManager())
}
