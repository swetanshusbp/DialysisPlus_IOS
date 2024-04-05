import SwiftUI

struct TodaysDietAnalysis: View {
    let color: Color
    
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
                
                WeeklyReport(color: Color(hexString: "FFDD00"), Potassium_intake: "200gm", Sodium_intake: "200gm", Fluid_intake: "2L", image: "BreakFast", meal: "Breakfast")
                    .offset(y: 70)
                
                WeeklyReport(color: Color(hexString: "FFDD00"), Potassium_intake: "200gm", Sodium_intake: "200gm", Fluid_intake: "2L", image: "Lunch", meal: "Lunch")
                    .offset(y: 70)
                
                WeeklyReport(color: Color(hexString: "FFDD00"), Potassium_intake: "200gm", Sodium_intake: "200gm", Fluid_intake: "2L", image: "Snacks", meal: "Snacks")
                    .offset(y: 70)
                
                WeeklyReport(color: Color(hexString: "FFDD00"), Potassium_intake: "200gm", Sodium_intake: "200gm", Fluid_intake: "2L", image: "Dinner", meal: "Dinner")
                    .offset(y: 70)
                
                CombinedComponent(Potassium_Value: 10, Sodium_Value: 50, Fluid_Value: 30)
                    .offset(y: 90)

            }
            
            Spacer()
        }
    }
}

struct TodaysDietAnalysis_Previews: PreviewProvider {
    static var previews: some View {
        TodaysDietAnalysis(color: Color(hexString: "FFDD00"))
    }
}

