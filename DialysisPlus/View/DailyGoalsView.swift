//
//  Dailygoalsview.swift
//  DialysisPlus
//
//  Created by admin on 28/12/23.
//
import SwiftUI

struct DailyGoalsView: View {
    @EnvironmentObject var dailyIntakeManager: dailyIntakeManager
    @ObservedObject var fluidData: Fluid
    
    @State private var sodiumValue: Double = 0.0
    @State private var potassiumValue: Double = 0.0
    
    let circleSpacing: CGFloat = 20
    let circleSize: CGFloat = 150
    
    let customViolet = Color(red: 88/255, green: 86/255, blue: 214/255)
    let customBlue = Color(red: 100/255, green: 210/255, blue: 255/255)
    let customGreen = Color(red: 0/255, green: 210/255, blue: 255/255)
    let animationDuration = 1.5
    
    var body: some View {
        HStack{
            VStack(spacing: 20) {
                ZStack {
                    // Sodium circle
                    Circle()
                        .trim(from: 0.0, to: sodiumValue)
                        .stroke(customGreen, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .frame(width: circleSize, height: circleSize)
                        .rotationEffect(Angle(degrees: -90))
                        .onAppear {
                            withAnimation(.easeInOut(duration: animationDuration)) {
                                sodiumValue = dailyIntakeManager.dailyIntake.totalSodium / 2000
                            }
                        }
                    
                    // Potassium circle
                    Circle()
                        .trim(from: 0.0, to: potassiumValue)
                        .stroke(customBlue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .frame(width: circleSize - circleSpacing * 2, height: circleSize - circleSpacing * 2)
                        .rotationEffect(Angle(degrees: -90))
                        .onAppear {
                            withAnimation(.easeInOut(duration: animationDuration)) {
                                potassiumValue = dailyIntakeManager.dailyIntake.totalPotassium / 2000
                            }
                        }
                    
                    // Fluid circle
                    Circle()
                        .trim(from: 0, to: CGFloat(fluidData.fluidPercentage))
                        .stroke(customViolet, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .frame(width: circleSize - circleSpacing * 4, height: circleSize - circleSpacing * 4)
                        .rotationEffect(Angle(degrees: -90))
                    
                    Circle()
                                .stroke(customGreen.opacity(0.3), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                                .frame(width: circleSize, height: circleSize)
                            
                            Circle()
                                .stroke(customBlue.opacity(0.3), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                                .frame(width: circleSize - circleSpacing * 2, height: circleSize - circleSpacing * 2)
                            
                            Circle()
                                .stroke(customViolet.opacity(0.3), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                                .frame(width: circleSize - circleSpacing * 4, height: circleSize - circleSpacing * 4)
                }
            }.padding()
            
            
            
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                      Color(hexString: "#E4F4FE")
                        )
                    
                    .frame(width: 170, height: 202)
           
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(hexString: "#FFFFFF"))
                            .frame(width: 160, height: 35)
                            .shadow(radius: 2, x: 2, y: 2)
                        
                        HStack(spacing:3) {
                            Circle()
                                .fill(Color(customGreen))
                                .frame(width: 17, height: 17)
                            
                            Text("Sodium")
                                .bold()
                            
                            Spacer()
                            Text(String(format: "%.1f%%", sodiumValue * 100))
                        }.padding(.horizontal , 2)
                    }
                    .frame(maxWidth: 160)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(hexString: "#FFFFFF"))
                            .frame(width: 160, height: 35)
                            .shadow(radius: 2, x: 2, y: 2)
                        
                        HStack(spacing:3) {
                            Circle()
                                .fill(Color(customBlue))
                                .frame(width: 17, height: 17)
                            
                            Text("Potassium")
                                .bold()
                           
                            Text(String(format: "%.1f%%", potassiumValue * 100))
                        }.padding(.horizontal , 2)
                    }
                    .frame(maxWidth: 160)
                    
                   
                    
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(hexString: "#FFFFFF"))
                            .frame(width: 160, height: 35)
                            .shadow(radius: 2, x: 2, y: 2)
                        
                        HStack(spacing:3) {
                            Circle()
                                .fill(Color(customViolet))
                                .frame(width: 17, height: 17)
                            
                            Text("Fluids")
                                .bold()
                            Spacer()
                            Text(String(format: "%.1f%%", fluidData.fluidPercentage * 100))
                        }.padding(.horizontal , 2)
                    }
                    .frame(maxWidth: 160)
                    
                   
                }.frame(maxHeight: 202)
            }
        }
    }
}
