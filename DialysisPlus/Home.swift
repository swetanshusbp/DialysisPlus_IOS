//
//  Home.swift
//  DialysisPlus
//
//  Created by Meghs on 03/03/24.
//



import SwiftUI

struct Home: View {
    @EnvironmentObject var dailyIntakeManager: dailyIntakeManager
    @EnvironmentObject private var IngredientsManager : Ingredients
    @Binding var tabSelected: Int
    @State private var isWeeklyReportPresented = false
    @State private var isUserProfilePresented = false
    @ObservedObject var fluidData: Fluid
    @State private var isEditViewPresented = false // New state variable to manage EditView presentation
    @State var potassium : Double = 0
    @State var sodium : Double = 0
    @State var dietInfo : [[String : Any]] = [[:]]
    var body: some View {
        FirestoreHelper().fetchFluidDrankForCurrentDate { fluidDrank in
                     if let fluidDrank = fluidDrank {
                         // Use the fetched fluidDrank value
                         fluidData.fluidDrank = (fluidDrank/1000)
                         
                     }
                 }
        
        return NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        StatusView(potassiumValue:
                                        calculatePercentage(consumed: potassium, total: dailyIntakeManager.dailyIntake.totalK),
                                    sodiumValue: calculatePercentage(consumed: sodium, total: dailyIntakeManager.dailyIntake.totalNa),
                                    fluidValue: (fluidData.fluidPercentage * 100))
                        Spacer()
                    }
                    
                    Button(action: {
                        tabSelected = 1
                    }) {
                        HStack {
                            Spacer()
                            Text("Keep calm and track your diet")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .frame(width: 350)
                        .background(Color(hex: "1E96FC"))
                        .cornerRadius(15)
                    }
                    
                    Button(action: {
                        tabSelected = 4
                        isWeeklyReportPresented = true
                    }) {
                        week()
                    }
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("Trending News")
                                .font(.title)
                                .bold()
                                .padding(.horizontal)
                            Spacer()
                        }
                        //newsAPITest()
                        final()
                    }
                }
                .onChange(of: dailyIntakeManager.dailyIntake.dataAdded,{
                    self.potassium  += dailyIntakeManager.dailyIntake.uK
                    self.sodium  += dailyIntakeManager.dailyIntake.uNa
                })

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
                    
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isUserProfilePresented = true
                    }) {
                        Image(systemName: "person")
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $isUserProfilePresented) {
                        UserProfile(closeUserSheet: $isUserProfilePresented, fluidData: fluidData)
                    }
                }
                
            }
        }
        .preferredColorScheme( dailyIntakeManager.dailyIntake.darkMode ? .dark : .light)
    }
    
    func data() {
        fetchDietData(){ result in
            self.sodium = result.sodium
            self.potassium = result.potassium
        }
    }
    func fetchDietData(completion: @escaping ((potassium: Double, sodium: Double)) -> Void) {
        var potassium: Double = 0
        var sodium: Double = 0
        
        FirestoreHelper().getDietInfo { items in
            if let items = items {
                self.dietInfo = [items]
            }
            for mealInfo in dietInfo {
                for (_, mealData) in mealInfo {
                    guard let mealDataDict = mealData as? [String: Any] else {
                        continue // Skip if it's not a valid dictionary
                    }
                    
                    // Access specific values like potassiumContent and sodiumContent
                    if let potassiumContent = mealDataDict["potassiumContent"] as? Double {
                        potassium += potassiumContent
                    }
                    
                    if let sodiumContent = mealDataDict["sodiumContent"] as? Double {
                        sodium += sodiumContent
                    }
                }
            }
            
            // Call completion handler with both potassium and sodium values
            completion((potassium, sodium))
        }
    }

}

// Preview for testing
//ToolbarItem(placement: .navigationBarLeading) {
//
//}
//
//ToolbarItem(placement: .navigationBarTrailing) {
//    Button(action: {
//        
//        isEditViewPresented = true
//    }) {
//        Image(systemName: "line.horizontal.3")
//            .foregroundColor(.blue)
//    }
//    .sheet(isPresented: $isEditViewPresented) {
//        
//        EditView(fluidData: fluidData)
//    }
//}
//
