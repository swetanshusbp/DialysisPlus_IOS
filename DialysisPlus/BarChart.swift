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
    
    var body: some View {
        VStack {
            HStack(spacing: 12){
                ForEach(values, id: \.self) { value in
                    Bar(color : color ,height: CGFloat(value), threshold: CGFloat(threshold))
                }
            }
            
            HStack(spacing: 15) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 13))
                        .bold()
                    
                }
            }
        }
    }
}
