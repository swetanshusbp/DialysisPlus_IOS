import SwiftUI

struct AddMealView: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth:400, maxHeight: 0)
            
            VStack {
                Text("Search for your meal")
                    .font(.headline)
                    .padding(.top, 90)
                
                // Search Bar
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Text("Or Take a Picture")
                    .font(.headline)
                    .padding()
                
                // Or Take a Picture Button
                Button(action: {
                    // Action for the "Take a Picture" button
                }) {
                    HStack {
                        Image(systemName: "camera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .padding(5)
                        
                    }
                    .foregroundColor(.black)
                    .background(Color(hex: "A2D6F9"))
                    .cornerRadius(10)
                }
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
struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView()
    }
}
#endif


