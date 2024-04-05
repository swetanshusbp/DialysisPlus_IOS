//
//  WeeklyReportsView.swift
//  DialysisPlus
//
//  Created by user1 on 10/01/24.
//
import SwiftUI
import Firebase

struct WeeklyReportView: View {
    @State private var fluidPercentages: [Double] = Array(repeating: 0, count: 7) // Initialize with 0s
    @State var kVal : [Double] = []
    @State var naVal : [Double] = []
    @State var potassium : Double = 0
    @State var sodium : Double = 0
    @State var dietInfo : [[String : Any]] = [[:]]
    @EnvironmentObject var dailyIntakeManager: dailyIntakeManager

    var body: some View {
        NavigationStack{
            VStack{
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            WeeklyIntakeModules(nutrient: "Potassium", color: Color(hexString: "FFDD00"), values: kVal, threshold: dailyIntakeManager.dailyIntake.totalK, content: potassium, unit: "mg")
                            
                            WeeklyIntakeModules(nutrient: "Sodium", color: Color(hexString: "AACC00"), values: naVal, threshold: dailyIntakeManager.dailyIntake.totalNa, content: sodium, unit: "mg")
                            
                            WeeklyIntakeModules(nutrient: "Fluid" , color: Color(hexString: "000AFF"), values:fluidPercentages, threshold: 1, content: 4, unit: "ml")
                            
                        }
                        .frame(width: geometry.size.width)
                        .padding(.vertical , 30)
                    }
                }
                Spacer()
            }
            .onChange(of: dailyIntakeManager.dailyIntake.dataAdded,{
                data()
            })

            
            .navigationTitle("Weekly Reports")
            .onAppear {
                data()
                fetchFluidPercentages()
                
                var sodiumVal : [Double] = []
                var potassVal : [Double] = []
                FirestoreHelper().fetchLastSevenDocuments { potassiumData, sodiumData in
                    // Convert dictionaries to arrays of tuples and sort them based on date
                    let sortedPotassium = potassiumData.sorted(by: { $0.key < $1.key })
                    let sortedSodium = sodiumData.sorted(by: { $0.key < $1.key })

                    
                    print("Potassium Data:")
                    for (date, potassium) in sortedPotassium {
                        potassVal.append(potassium)
                    }

                    print("\nSodium Data:")
                    for (date, sodium) in sortedSodium {
                        sodiumVal.append(sodium)
                    }
                    
                    self.kVal = potassVal
                    self.naVal = sodiumVal
                   
                    
                    
                }
                
            
            }
        }
      
       
    }
    
    func fetchFluidPercentages() {
        FirestoreHelper().getFluidPercentages { percentages in
            self.fluidPercentages = percentages
        }
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

#Preview {
    WeeklyReportView()
        .environmentObject(dailyIntakeManager())
}
