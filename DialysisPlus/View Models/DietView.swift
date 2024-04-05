import SwiftUI

struct DietView: View {
    @State private var isFluidViewPresented = false
    @State private var isDietTrackingViewPresented = false
    @ObservedObject var fluidData: Fluid
    @State private var isWeeklyReportPresented = false // State variable to track if WeeklyReportView is presented
    var profile: Profile
    
    //binding variable for shifting from tab view
    @Binding var tabSelected : Int
    
    var body: some View {
        NavigationStack{
            VStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(minWidth: 400, maxHeight: 0)
                    .offset(y: -10)
                HStack{
                    if let profileImage = profile.image {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    Text("Welcome \(profile.name)")
                }

                VStack {
                    Text("Daily Goals")
                        .font(.title)
                        .padding(.top, 90)

                    DailyGoalsView(fluidData: fluidData)

                    Button(action: {
                        tabSelected = 1
                    }) {
                        HStack {
                            Text("Keep calm and track your diet")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(hex: "1E96FC"))
                        .cornerRadius(15)
                        .frame(minWidth: 350)

                    }
                    
                    .padding()

                    // Navigation link to WeeklyReportView
                    NavigationLink(destination: WeeklyReportView(), isActive: $isWeeklyReportPresented) {
                        EmptyView()
                    }
                    .hidden()

                    Button(action: {
                        isWeeklyReportPresented = true // Activate the navigation link
                    }) {
                        week()
                    }
                }
                .cornerRadius(20)
                .padding(.top, -30)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                .offset(y: -10)

                Spacer()
            }
            .navigationBarBackButtonHidden()
        }
      
    }
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

