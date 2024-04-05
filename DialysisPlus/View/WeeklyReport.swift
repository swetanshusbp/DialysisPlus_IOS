import SwiftUI

struct WeeklyReport: View {
    let color: Color
    let Potassium_intake: String
    let Sodium_intake: String
    let Fluid_intake: String
    let image: String
    let meal: String
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hexString: "#FEFEFE"))
                .frame(width: 342, height: 200)
                .shadow(radius: 3 , x: 5, y: 5)
            
            VStack(alignment: .leading) {
                HStack {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(meal)
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 248, height: 1)
                        Text("Today")
                            .foregroundColor(.gray)
                    }
                }
            }
            .offset(x:-10 , y: 20)
            VStack (alignment: .leading){
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hexString: "#FFFFFF"))
                                .frame(width: 195, height: 35)
                                .shadow(radius: 2, x: 2, y: 2)
                                .offset(x: 50, y: 60)

                            HStack() {
                                Circle()
                                    .fill(Color(hexString: "#FFDD00"))
                                    .frame(width: 17, height: 17)
                                Text("Potassium")
                                Text(Potassium_intake)
                            }
                            .offset(x: 50, y: 67)
                        }

                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hexString: "#FFFFFF"))
                                .frame(width: 195, height: 35)
                                .shadow(radius: 2, x: 2, y: 2)
                                .offset(x: 50, y: 60)

                            HStack {
                                Circle()
                                    .fill(Color(hexString: "#AACC00"))
                                    .frame(width: 17, height: 17)
                                    .offset(x:-10)
                                Text("Sodium")
                                    .offset(x:-10)
                                Text(Sodium_intake)
                                    .offset(x:10)
                            }
                            .offset(x: 50, y: 67)
                        }

                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hexString: "#FFFFFF"))
                                .frame(width: 195, height: 35)
                                .shadow(radius: 2, x: 2, y: 2)
                                .offset(x: 50, y: 60)

                            HStack {
                                Circle()
                                    .fill(Color(hexString: "#000AFF"))
                                    .frame(width: 17, height: 17)
                                    .offset(x:-37)
                                Text("Fluid")
                                    .offset(x:-37)
                                Text(Fluid_intake)
                                    .offset(x:5)
                            }
                            .offset(x: 50, y: 67)
                        }
                    }
                }
        }
    }

struct WeeklyReport_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyReport(color: Color(hexString: "FFDD00"), Potassium_intake: "200gm", Sodium_intake: "200gm", Fluid_intake: "2L", image: "BreakFast", meal: "Breakfast")
    }
}
