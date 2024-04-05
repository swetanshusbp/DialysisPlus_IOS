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

struct DietLevelView: View {
    let potassiumConsumed: Double = 100
    let totalPotassium: Double = 1650
    let sodiumConsumed: Double = 1500
    let totalSodium: Double = 2000
    
    var body: some View {
        HStack {
            VStack {
                CircularGraph(percent: calculatePercentage(consumed: potassiumConsumed, total: totalPotassium), color: getColorForPercentage(calculatePercentage(consumed: potassiumConsumed, total: totalPotassium)), isPotassium: true)
                
                Text("\(Int(potassiumConsumed)) mg / \(Int(totalPotassium)) mg")
            }
            
            VStack {
                CircularGraph(percent: calculatePercentage(consumed: sodiumConsumed, total: totalSodium), color: getColorForPercentage(calculatePercentage(consumed: sodiumConsumed, total: totalSodium)), isPotassium: false)
                
                Text("\(Int(sodiumConsumed)) mg / \(Int(totalSodium)) mg")
            }
        }
        .padding()
    }
    
    func calculatePercentage(consumed: Double, total: Double) -> Double {
        return min((consumed / total) * 100, 100)
    }
    
    func getColorForPercentage(_ percent: Double) -> Color {
        switch percent {
        case 0..<40:
            return Color(hex: "00FC19")
        case 40..<75:
            return Color(hex: "FFC600")
        case 75...100:
            return Color(hex: "FF0000")
        default:
            return .clear
        }
    }
}

// Add the Color extension for hex colors here...

struct DietLevelView_Previews: PreviewProvider {
    static var previews: some View {
        DietLevelView()
    }
}


