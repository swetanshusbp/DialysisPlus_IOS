import SwiftUI

struct NutritionView: View {
    @State private var searchText = ""
    @State private var mealDetected = "Sandwich"
    @State private var servingSize = 1
    
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
                
                Text("Nutrition Facts")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                
                Divider()
                    .background(Color.black)
                    .padding()
                    .frame(height: 3) // Increase line thickness
                
                HStack {
                    Text("Serving Size:")
                        .font(.headline)
                        .bold()
                    Spacer()
                    Stepper(value: $servingSize, in: 1...10) {
                        Text("\(servingSize)")
                            .bold()
                            .padding()
                            .foregroundColor(.black)
                    }
                    
                }
                .padding(.horizontal)
                

                
                // Nutrition Image
                Image("nutrition") // Replace "nutrition" with your image name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 320)
            }
            .cornerRadius(20)
            .padding(.top, -30)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            
            Spacer()
        }
    }
}

#if DEBUG
struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
    }
}
#endif


