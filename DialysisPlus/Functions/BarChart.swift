//
//  BarChart.swift
//  DialysisPlus
//
//  Created by user1 on 10/01/24.
//

import Foundation
import SwiftUI

struct BarChart: View {
    let values: [Double]
    let threshold: Double
    let daysOfWeek: [String]
    let color : Color
    @State private var yOffset: CGFloat = 1000
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Spacer()
               
                ForEach(values, id: \.self) { value in
                    
                    Bar(color : color ,height: CGFloat(value), threshold: CGFloat(threshold))
                    Spacer()
                }
              
            }
           
                     
            HStack {
                Spacer()
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .bold()
                    
                }
            }
        }
        
    }
}


func getLastSevenDates() -> [String] {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM"

    var dates: [String] = []
    let calendar = Calendar.current
    var currentDate = Date()

    // Iterate in reverse to get the dates in reverse order
    for _ in (0..<7) {
        let dateString = formatter.string(from: currentDate)
        dates.append(dateString)

        // Calculate the previous day
        if let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate) {
            currentDate = previousDate
        } else {
            break // Break loop if unable to calculate previous day
        }
    }

    return dates.reversed()
}
