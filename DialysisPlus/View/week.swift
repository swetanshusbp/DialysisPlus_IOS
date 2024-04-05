//
//  week.swift
//  DialysisPlus
//
//  Created by Abilasha  on 29/02/24.
//

import SwiftUI

struct week: View {
    let currentDate = Date()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/MM"
        return formatter
    }()
    
    var formattedStartDate: String {
        let startDate = currentDate.startOfWeek
        return dateFormatter.string(from: startDate)
    }
    
    var formattedEndDate: String {
        let endDate = currentDate.endOfWeek
        return dateFormatter.string(from: endDate)
    }
    
    // Sample weekly achievement data
    let weeklyAchievement = WeeklyAchievement(numberOfDaysAchieved: 4, sun: true, mon: true, tue: false, wed: true, thu: false, fri: false, sat: true)
    
    @State var today : String = ""
    @State var lastWeek : String = ""
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "A2D6F9"))
                .frame(width: 350, height: 170)
                .overlay(
                    VStack(alignment:.leading ) {
                        HStack{
                            Text("Your Weekly Report")
                                .font(.title2)
                                .foregroundColor(.black)
                                .bold()
                            Image(systemName: "chevron.right")
                        }
                        
                        Text("\(lastWeek) - \(today)")
                            .foregroundColor(.blue)
                            .font(.headline)
                        HStack {
                            VStack {
                                Image(systemName: "calendar.circle")
                                    .resizable()
                                    .frame(width: 50 , height: 50)
                                    
//                                Text("\(weeklyAchievement.numberOfDaysAchieved)/7")
//                                    .font(.title)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.black)
                                Text("achieved")
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            HStack {
                                // Sun circle
                                ZStack {
                                    Circle()
                                        .fill(weeklyAchievement.sun ? Color(hex: "DFFF42") : Color.blue)
                                        .frame(width: 25, height: 25)
                                    Text("S")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                
                                // Mon circle
                                ZStack {
                                    Circle()
                                        .fill(weeklyAchievement.mon ? Color(hex: "DFFF42") : Color.blue)
                                        .frame(width: 25, height: 25)
                                    Text("M")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                
                                // Tue circle
                                ZStack {
                                    Circle()
                                        .fill(weeklyAchievement.tue ? Color(hex: "DFFF42") : Color.blue)
                                        .frame(width: 25, height: 25)
                                    Text("T")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                
                                // Wed circle
                                ZStack {
                                    Circle()
                                        .fill(weeklyAchievement.wed ? Color(hex: "DFFF42") : Color.blue)
                                        .frame(width: 25, height: 25)
                                    Text("W")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                
                                // Thu circle
                                ZStack {
                                    Circle()
                                        .fill(weeklyAchievement.thu ? Color(hex: "DFFF42") : Color.blue)
                                        .frame(width: 25, height: 25)
                                    Text("T")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                
                                // Fri circle
                                ZStack {
                                    Circle()
                                        .fill(weeklyAchievement.fri ? Color(hex: "DFFF42") : Color.blue)
                                        .frame(width: 25, height: 25)
                                    Text("F")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                
                                // Sat circle
                                ZStack {
                                    Circle()
                                        .fill(weeklyAchievement.sat ? Color(hex: "DFFF42") : Color.blue)
                                        .frame(width: 25, height: 25)
                                    Text("S")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                
                                Spacer()
                            }
                            .padding(10)
                        }
                       
                    }
                    .padding()
                    
                )
        }
        .onAppear{
            (self.today , self.lastWeek) = getDatesAsString()
        }
        .padding()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        week()
    }
}

extension Date {
    var startOfWeek: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    var endOfWeek: Date {
        Calendar.current.date(byAdding: .day, value: 6, to: self.startOfWeek)!
    }
}


struct WeeklyAchievement {
    var numberOfDaysAchieved: Int
    var sun: Bool
    var mon: Bool
    var tue: Bool
    var wed: Bool
    var thu: Bool
    var fri: Bool
    var sat: Bool
    
    init(numberOfDaysAchieved: Int, sun: Bool, mon: Bool, tue: Bool, wed: Bool, thu: Bool, fri: Bool, sat: Bool) {
        self.numberOfDaysAchieved = numberOfDaysAchieved
        self.sun = sun
        self.mon = mon
        self.tue = tue
        self.wed = wed
        self.thu = thu
        self.fri = fri
        self.sat = sat
    }
}


func getDatesAsString() -> (String, String) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM" // Define your desired date format
    
    let calendar = Calendar.current
    let now = Date()
    
    // Get today's date
    let today = dateFormatter.string(from: now)
    
    // Get the date 7 days ago
    if let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: now) {
        let sevenDaysAgoString = dateFormatter.string(from: sevenDaysAgo)
        return (today, sevenDaysAgoString)
    } else {
        // Handle error, if any
        fatalError("Failed to calculate date 7 days ago")
    }
}
