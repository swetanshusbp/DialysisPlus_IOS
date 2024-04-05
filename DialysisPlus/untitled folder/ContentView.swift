//
//  ContentView.swift
//  DialysisPlusNew
//
//  Created by admin on 28/12/23.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab = 0
    var username: String = "John" // Replace with actual username
    
    var body: some View {
        
        
        VStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth: 400, maxHeight: 0)
            VStack(alignment:.leading,spacing: 20) {
                HStack {
                                   Image(systemName: "person.circle.fill") // Replace with actual profile image
                                       .resizable()
                                       .frame(width: 70, height: 70)
                                   Text("Welcome \(username)")
                                       .font(.title)
                                       .foregroundColor(.black)
                                       .bold()
                                       .padding(.top,30)
                                   
                                      
                               }
                                   .padding(.top,20)
                HStack{
               
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "EFEFEF"))
                        .frame(width: 170, height: 260)
                        .overlay(
                            VStack(spacing: 20) { // Adjust spacing as needed
                                Text("Daily Status")
                                    .foregroundColor(.black)
                                    .bold()
                                    .font(.title3)
                                
                                DailyGoalsView()
                                    .frame(width: 20)
                                Button(action: {
                                    // Action for adding a meal
                                }) {
                                    Text("Add Meal")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.blue)
                                        .cornerRadius(25)
                                       
                                }
                            }
                            .padding() // Optional: Add padding to the VStack content
                        )
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "EFEFEF"))
                        .frame(width: 170, height: 260)
                        .overlay(
                            VStack(spacing: 20) { // Adjust spacing as needed
                                Text("Appoinment")
                                    .foregroundColor(.black)
                                    .bold()
                                    .font(.title3)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: 150, height: 80)
                                    .overlay(
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Image("hospitalImage")
                                                    .resizable()
                                                    .frame(width: 31, height: 31)
                                                    .cornerRadius(25)
                                                    .padding(.horizontal,7)
                                                Text("Clear Medi Hospital")
                                                    .font(.caption)
                                                    .bold()
                                                    .lineLimit(nil)
                                                        .fixedSize(horizontal: false, vertical: true)
                                            }
                                            Divider() // Add a line
                                            HStack {
                                                Text("01/02/2023")
                                                    .font(.caption)
                                                    .padding(.horizontal,7)
                                                Spacer()
                                                Text("10.00am")
                                                    .font(.caption)
                                                    .padding(.horizontal,7)
                                            }
                                        }
                                    )
                                Spacer()
                                Button(action: {
                                    // Action for adding a meal
                                }) {
                                    Text("View All")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.blue)
                                        .cornerRadius(25)
                                       
                                }
                            }
                            .padding(7) // Optional: Add padding to the VStack content
                        )

                                        
                    }
                Text("Book Appoinment")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                HStack{
                    Button(action: {
                        // Action for adding a mea
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(hex:"A2D6F9"), lineWidth: 2)
                                .background(Color(hex:"A2D6F9"))
                                .cornerRadius(25)
                                .frame(width:170 ,height:50)

                            HStack {
                                Image("CenterIcon")
                                Text("Dialysis Center")
                                    .foregroundColor(.black)
                                  
                            }
                        }
                    }
                    Button(action: {
                        // Action for adding a meal
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(hex:"A2D6F9"), lineWidth: 2)
                                .background(Color(hex:"A2D6F9"))
                                .cornerRadius(25)
                                .frame(width:170 ,height:50)

                            HStack {
                                Image("HomeVisit")
                            
                              
                                Text("Home Visit")
                                    .foregroundColor(.black)
                                    .padding(.trailing,20)
                                  
                            }
                        }
                    }
                    
                }
                

                }
            
            Spacer()
            
            


        }
        
    }
    
    
}

#Preview {
    ContentView()
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
