//
//  CircularGraph.swift
//  DialysisPlus
//
//  Created by user1 on 16/01/24.
//

import SwiftUI

struct CircularGraph: View {
    let percent: Double
    let color: Color
    let isPotassium: Bool
    
    var body: some View {
        let strokeStyle = StrokeStyle(lineWidth: 10, lineCap: .round)
        
        ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(percent) * 0.01)
                .stroke(color, style: strokeStyle)
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0))
            
            VStack {
                Text(isPotassium ? "K" : "Na")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(isPotassium ? "Potassium" : "Sodium")
                    .font(.callout)
            }
            .padding()
        }.padding()
    }
}
#Preview {
    CircularGraph(
        percent: 43,
        color: getColorForPercentage(43),
        isPotassium: true)
}
