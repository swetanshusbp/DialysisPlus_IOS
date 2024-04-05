import SwiftUI

struct TodaysDietAnalysis: View {
    let color: Color
    @EnvironmentObject var DailyIntakeManager : dailyIntakeManager
    
    var body: some View {
        VStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth:400, maxHeight:0)
            ZStack {
                Circle()
                    .fill(Color(hexString: "A2D6F9"))
                    .frame(width: 45, height: 45.32)
                    .overlay(
                        Image("Watch")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    )
            }
            .offset(x:140 , y: -25)
            
            HStack(spacing : 40){
                            Button {
                            } label: {
                                ZStack {
                                Capsule()
                                .rotation(.degrees(180))
                                .fill(Color(hexString: "#1E96FC"))
                                .frame(width:90.54 , height: 39 )
                                Text("TODAY")
                                        .foregroundColor(.white)
                                }
                            }
                            Button {
                            } label: {
                                ZStack {
                                    Capsule()
                                        .rotation(.degrees(180))
                                        .fill(Color(hexString: "#D9D9D9"))
                                        .frame(width:90.54 , height: 39 )
                                    Text("WEEK")
                                        .foregroundColor(.black)
                                        .bold()
                                }
                            }
                        }
            .offset(y:50)
            
            ScrollView{
                
                WeeklyReportModule(color: Color(hexString: "FFDD00"), Potassium_intake:
                    String(DailyIntakeManager.dailyIntake.breakfast.totalPotassium)
                , 
            Sodium_intake: String(DailyIntakeManager.dailyIntake.breakfast.totalSodium)
                    , Fluid_intake: "2L", image: "breakfast", meal: "Breakfast")
                    .offset(y: 70)
                
                WeeklyReportModule(color: Color(hexString: "FFDD00"), Potassium_intake:                    String(DailyIntakeManager.dailyIntake.lunch.totalPotassium), Sodium_intake: String(DailyIntakeManager.dailyIntake.lunch.totalSodium), Fluid_intake: "2L", image: "lunch", meal: "Lunch")
                    .offset(y: 70)
                
                WeeklyReportModule(color: Color(hexString: "FFDD00"), Potassium_intake:                     String(DailyIntakeManager.dailyIntake.snacks.totalPotassium), Sodium_intake:String(DailyIntakeManager.dailyIntake.snacks.totalSodium), Fluid_intake: "2L", image: "snacks", meal: "Snacks")
                    .offset(y: 70)
                
                WeeklyReportModule(color: Color(hexString: "FFDD00"), Potassium_intake:                     String(DailyIntakeManager.dailyIntake.dinner.totalPotassium), Sodium_intake: String(DailyIntakeManager.dailyIntake.dinner.totalSodium), Fluid_intake: "2L", image: "dinner", meal: "Dinner")
                    .offset(y: 70)
                
                CombinedComponent(Potassium_Value: calculatePercentage(consumed: DailyIntakeManager.dailyIntake.totalPotassium, total: 2000), Sodium_Value: calculatePercentage(consumed: DailyIntakeManager.dailyIntake.totalSodium, total: 2000),  Fluid_Value: 30)
                    .offset(y: 90)

            }
            
            Spacer()
        }
    }
}

struct TodaysDietAnalysis_Previews: PreviewProvider {
    static var previews: some View {
        TodaysDietAnalysis(color: Color(hexString: "FFDD00"))
            .environmentObject(dailyIntakeManager())
    }
}

