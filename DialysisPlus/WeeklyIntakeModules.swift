//
//  WeeklyIntakeModules.swift
//  DialysisPlus
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct WeeklyIntakeModules: View {
    let nutrient : String
    let color : Color
    let values: [Double]
    let threshold: Double
    
    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        
        ZStack(alignment: .top){
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hexString : "#FEFEFE"))
                .frame(width: 342 , height: 200)
                .shadow(radius: 3 ,  x : 5 ,y :5)
            
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
                    
                    VStack{
                        HStack {
                            Text("0")
                                .font(.system(size: 64))
                            Text("mg")
                                .font( .title3)
                                .baselineOffset(-20)
                        }
                        Text("Today")
                            .font(.subheadline)
                            .offset(y:-10)
                    }
                    .padding()
                    .offset(/*@START_MENU_TOKEN@*/CGSize(width: 10.0, height: 10.0)/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                    BarChart(values: values, threshold: threshold, daysOfWeek: daysOfWeek, color: color)
                        .offset(x : -25, y: -10)
                        
                
                }
                .offset(y : -40)
                
    
                
            }
           
        }
        .frame(maxWidth: 322)
            
    }
}

#Preview {
    WeeklyIntakeModules(nutrient: "Sodium", color: Color(hexString: "FFDD00") , values: [30, 160, 60, 80, 101, 120, 200] , threshold:  200)
}
