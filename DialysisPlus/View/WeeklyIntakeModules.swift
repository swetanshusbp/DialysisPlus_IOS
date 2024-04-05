//
//  WeeklyIntakeModules.swift
//  DialysisPlus
//
//  Created by user1 on 10/01/24.
//

import SwiftUI
import Charts

struct WeeklyIntakeModules: View {
    let nutrient : String
    let color : Color
    let values: [Double]
    let threshold: Double
    let content : Double
    let unit : String
    
    @State var daysOfWeek : [String] = []
    
    var body: some View {
        
        ZStack(alignment: .top){
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("customWhite"))
                .frame(width: 342 , height: 250)
                .shadow(radius: 3 ,  x : 1.5 ,y :3)
            
            VStack {
                HStack(spacing:0 ){
                    
                    Circle()
                        .fill(color)
                        .frame(width: 17 , height:  17)
                    
                    Text(nutrient)
                        .fontWeight(.bold)
                        .padding()
                        .bold()
                        .font(.title3)
                    
                    Spacer()
                    
                    HStack{
                        Text("Today")
                            .font(.subheadline)
                        
                        HStack {
                            Text(String(format: "%.1f", content))
                                .font(.title3)
                            Text(unit)
                                .font( .title3)
                            
                        }
                    }
                }.padding(.horizontal , 20)
                
                Rectangle()
                    .frame( width : 289 , height :1).offset(y:-15)
                
                HStack{
                    Text("Last 7 Days")
                        .foregroundColor(Color(hexString: "#A5A5A5"))
                        .font(/*@START_MENU_TOKEN@*/.subheadline/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal , 25)
                        .offset(y:-15)
                    Spacer()
                }
                
                HStack {
                    BarChart(values: values, threshold: threshold, daysOfWeek: daysOfWeek, color: color)
                  Spacer()
                    
                }
                .offset(y: -10)
            }
           
        }
        .onAppear{
            self.daysOfWeek = getLastSevenDates()
        }
        .frame(maxWidth: 322)
            
    }
}

#Preview {
    WeeklyIntakeModules(nutrient: "Sodium", color: Color(hexString: "FFDD00") , values: [30, 160, 60, 80, 101, 120, 200] , threshold:  200, content: 60, unit: "mg")
}
