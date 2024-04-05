import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct SleepTrackerView: View {

    var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color(hex: "1E96FC"))
                .frame(width: 170, height: 300)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                .overlay(
                    VStack(spacing: 10) {
                        Text("Daily Sleep Tracker")
                            .font(.headline)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Text(currentDate)
                            .foregroundColor(.black)
                        
                        Spacer() // Add spacer to push content upwards
                        
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                        
                        Text("Time Asleep")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        HStack {
                            Text("8")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            Text("hr")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                            
                            Text("12")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            Text("min")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            // Action for the button
                        }) {
                            HStack {
                               
                                   
                                Text("Connect to Apple Watch")
                                    .foregroundColor(.black)
                                    .font(.system(size: 11, weight: .bold))
                                Image("Watch")
                            }
                            .padding(5)
                            .background(Color(hex: "EFEFEF"))
                            .clipShape(
                                RoundedCorner(radius: 25, corners: [.topRight, .bottomRight])
                            )
                        }
                        .padding(.vertical,10) // Add padding inside the RoundedRectangle
                    }.padding(.top,35)
                    .padding(.bottom,15)
                )
        }
    }
}

struct SleepTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        SleepTrackerView()
    }
}

