//
//  ContentView.swift
//  DialysisPlus
//
//  Created by Abilasha  on 02/04/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var fluidData = Fluid(fluidDrank: 0, totalFluid: 2)
    
    @StateObject var DailyIntakeManager: dailyIntakeManager = dailyIntakeManager()
    
    @StateObject var IngredientsManager : Ingredients = Ingredients()
    @State var selectedTab: Int = 0
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group{
            if viewModel.userSession != nil{
                  TabView(selection: $selectedTab) {
                 Home(tabSelected: $selectedTab, fluidData: fluidData)
                 .tabItem {
                 Image(systemName: "house.circle.fill")
                 Text("Home")
                 }
                 .tag(0)
                 
                 DietTrackingView()
                 .tabItem {
                 Image(systemName: "chart.bar.fill")
                 Text("Diet")
                 }
                 .tag(1)
                 
                 FluidView(fluidData: fluidData)
                 .tabItem {
                 Image(systemName: "drop.circle.fill")
                 Text("Fluid")
                 }
                 .tag(2)
                 
//                 SleepDataView()
//                 .tabItem {
//                 Image(systemName: "moon.zzz.fill")
//                 Text("Sleep")
//                 }
                 SleepTrackingView()
                          .tabItem {
                              Image(systemName:"bed.double.fill")
                              Text("Sleep")
                            }
                 .tag(3)
                 //
                 WeeklyReportView()
                 //AddMeal2(isPresented: .constant(true), title: "BreakFast")
                 .tabItem {
                 Image(systemName: "calendar.circle.fill")
                 Text("Weekly Reports")
                 }
                 .tag(4)
                 
                 
                 }.environmentObject(DailyIntakeManager)
                    .environmentObject(IngredientsManager)
                    .environment(\.managedObjectContext, MealDataProvider.shared.viewContext)

            } 
            
            else{
                
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}


