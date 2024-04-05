import SwiftUI

struct ConfirmMealView: View {
    @State private var searchText = ""
    @State private var mealDetected = "Sandwich"
    
    var body: some View {
        VStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth: 400, maxHeight: 0)
            
            VStack {
                // Sample Image
                Image("sample") // Replace "sampleImage" with your image name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .overlay(
                        Circle()
                            .stroke(Color(hex: "FFC600"), lineWidth: 5)
                    )
                    .clipShape(Circle())
                    .padding(.top, 90)
                
                Text(mealDetected)
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                // Confirm Button
                Button(action: {
                    // Action for the "Confirm" button
                }) {
                    Text("Confirm")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color(hex: "072AC8"))
                        .cornerRadius(25)
                }
                .padding(.top, 20)
                
                Text("Or Search for your meal")
                    .foregroundColor(.gray)
                    .padding()
                
                // Search Bar
                TextField("Search for your meal", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            .cornerRadius(20)
            .padding(.top, -30)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            
            Spacer()
        }
    }
}

#if DEBUG
struct ConfirmMealView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmMealView()
    }
}
#endif


