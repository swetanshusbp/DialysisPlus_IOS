//
//  FoodInputView.swift
//  DialysisPlus
//
//  Created by user1 on 16/01/24.
//

import SwiftUI

struct FoodInputView: View {

    @EnvironmentObject var dailyIntakeManager: dailyIntakeManager
    
    @ObservedObject var slideUpState = SlideUpState()
    
    @State private var selectedMealTitle = ""

    var body: some View {
        VStack(spacing: 10) {
            
            createButton(
                imageName: "breakfast", dailyIntakeManager: dailyIntakeManager,
                title: "Breakfast",
                na: dailyIntakeManager.dailyIntake.breakfast.totalSodium,
                k: dailyIntakeManager.dailyIntake.breakfast.totalPotassium
            ) { _ in
                selectedMealTitle = "Breakfast"
                slideUpState.isPresented.toggle()
            }
            .padding(20)

            createButton(
                imageName: "lunch", dailyIntakeManager: dailyIntakeManager,
                title: "Lunch",
                na: dailyIntakeManager.dailyIntake.lunch.totalSodium,
                k: dailyIntakeManager.dailyIntake.lunch.totalPotassium
            ) { _ in

                selectedMealTitle = "Lunch"
                slideUpState.isPresented.toggle()
            }
            .padding(20)

            createButton(
                imageName: "dinner", dailyIntakeManager: dailyIntakeManager,
                title: "Dinner",
                na: dailyIntakeManager.dailyIntake.dinner.totalSodium,
                k: dailyIntakeManager.dailyIntake.dinner.totalPotassium
            ) { _ in
                
                selectedMealTitle = "Dinner"
                slideUpState.isPresented.toggle()
            }
            .padding(20)

            createButton(
                imageName: "snacks", dailyIntakeManager: dailyIntakeManager,
                title: "Snacks",
                na: dailyIntakeManager.dailyIntake.snacks.totalSodium,
                k: dailyIntakeManager.dailyIntake.snacks.totalPotassium
            ) { title in
                selectedMealTitle = title
                slideUpState.isPresented.toggle()
            }
            .padding(20)
        }
        .sheet(isPresented: $slideUpState.isPresented) {
            SlideUpView(
                slideUpState: slideUpState,
                title: selectedMealTitle
            )
            .environmentObject(dailyIntakeManager)
        }
    }
}

#Preview {
    FoodInputView()
        .environmentObject(dailyIntakeManager())
}

