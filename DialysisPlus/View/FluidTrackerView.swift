import SwiftUI
import UserNotifications

struct FluidTrackerView: View {
    @ObservedObject var fluidData: Fluid

    private let redThreshold: Double = 0.75

    var body: some View {
       FirestoreHelper().fetchFluidDrankForCurrentDate { fluidDrank in
                    if let fluidDrank = fluidDrank {
                        // Use the fetched fluidDrank value
                        fluidData.fluidDrank = (fluidDrank/1000)
                    }
                }
        let isOverLimit = fluidData.fluidPercentage > redThreshold

        let graphColor: Color = {
            if isOverLimit {
                notifyUserIfNeeded()
                return Color.red
            } else {
                return Color(hex: "FFC600")
            }
        }()

        return ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(fluidData.fluidPercentage))
                .stroke(graphColor, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .frame(width: 180, height: 180)
                .rotationEffect(.degrees(-90))

            Circle()
                .fill(Color(hex: "A2D6F9")) // Light blue filled circle
                .frame(width: 170, height: 170)

            WaveAnimation(percent: (fluidData.fluidPercentage) * 100)
                .frame(width: 170, height: 170)
                .clipShape(Circle())
            VStack {
                Text(String(format: "%.2fl", fluidData.fluidDrank))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("Out of \(String(format: "%.2fl", fluidData.totalFluid))")
                    .foregroundColor(.black)
            }
            .padding(5)
        }
    }
    private func notifyUserIfNeeded() {
        let content = UNMutableNotificationContent()
        content.title = "Fluid Limit Exceeded"
        content.body = "You are almost at your fluid limit. Limit your fluid intake now."
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // Trigger notification immediately

        let request = UNNotificationRequest(identifier: "FluidLimitExceeded", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}

struct WaveAnimation: View {
    @State private var waveOffset = Angle(degrees: 0)
    var percent: Double

    init(percent: Double) {
        self.percent = percent
    }

    var body: some View {
        ZStack {
            Wave(offSet: Angle(degrees: waveOffset.degrees), percent: percent)
                .fill(Color.blue)
                .clipShape(Circle())
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                self.waveOffset = Angle(degrees: 360)
            }
        }
        .onReceive([self.percent].publisher) { _ in
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                self.waveOffset = Angle(degrees: 360)
            }
        }
    }
}
struct Wave: Shape {
    var offSet: Angle
    var percent: Double

    var animatableData: Double {
        get { offSet.degrees }
        set { offSet = Angle(degrees: newValue) }
    }

    func path(in rect: CGRect) -> Path {
        var p = Path()

        let lowestWave = 0.02
        let highestWave = 1.00

        let newPercent = lowestWave + (highestWave - lowestWave) * (percent / 100)
        let waveHeight = 0.015 * rect.height
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)

        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))

        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }

        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()

        return p
    }
}

struct InvisibleSlider: View {
    @Binding var percent: Double

    var body: some View {
        GeometryReader { geo in
            let dragGesture = DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let percent = 1.0 - Double(value.location.y / geo.size.height)
                    self.percent = max(0, min(100, percent * 100))
                }

            Rectangle()
                .opacity(0.001)
                .frame(width: geo.size.width, height: geo.size.height)
                .gesture(dragGesture)
        }
    }
}

struct FluidTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        FluidTrackerView(fluidData: Fluid(fluidDrank: 1.0, totalFluid: 2.00)) // Adjust initial values as needed
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

