import SwiftUI

struct FoodInputView: View {
    @State private var isSlideUpViewPresented = false
    @State private var selectedMealTitle = ""
    
    @State private var breakfastNA: Int = 30
    @State private var breakfastK: Int = 50
    @State private var lunchNA: Int = 30
    @State private var lunchK: Int = 50
    @State private var dinnerNA: Int = 30
    @State private var dinnerK: Int = 50
    @State private var snacksNA: Int = 30
    @State private var snacksK: Int = 50
    
    var body: some View {
        VStack(spacing: 10) {
            createButton(imageName: "breakfast", title: "Breakfast", na: breakfastNA, k: breakfastK) { title in
                selectedMealTitle = title
                isSlideUpViewPresented.toggle()
            }
            .padding(20)
            
            createButton(imageName: "lunch", title: "Lunch", na: 20, k: 40) { title in
                selectedMealTitle = title
                isSlideUpViewPresented.toggle()
            }
            .padding(20)
            
            createButton(imageName: "dinner", title: "Dinner", na: 25, k: 45) { title in
                selectedMealTitle = title
                isSlideUpViewPresented.toggle()
            }
            .padding(20)
            
            createButton(imageName: "snacks", title: "Snacks", na: 15, k: 35) { title in
                selectedMealTitle = title
                isSlideUpViewPresented.toggle()
            }
            .padding(20)
        }
        .sheet(isPresented: $isSlideUpViewPresented) {
            SlideUpView(isPresented: $isSlideUpViewPresented, title: selectedMealTitle)
        }
    }
    
    func createButton(imageName: String, title: String, na: Int, k: Int, action: @escaping (String) -> Void) -> some View {
        Button(action: {
            action(title)
        }) {
            HStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                Text(title)
                    .font(.title3)
                    .bold()
             
                
                Spacer()
                
                HStack {
                    Text("Na: \(na)mg")
                    Text("K: \(k)mg")
                }
                .padding(.top, 25)
            }
            .padding(10)
            .foregroundColor(.black)
        }
        .background(Color(hex: "EFEFEF")) // Replace with your desired background color
        .cornerRadius(20)
        .frame(width: 350, height: 35)
    }
}

struct SlideUpView: View {
    @Binding var isPresented: Bool
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .bold()
                .padding()
            RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .frame(width: 300, height: 100)
                            .overlay(
                                HStack {
                                    Text("Scrambled Egg")
                                        
                                    Spacer()
                                    Text("09.30am")
                                        
                                }
                                .padding()
                            )
                            .padding(.bottom, 20)
            // Other content specific to the selected meal title can be added here
            Spacer()
            
            Button(action: {
                // Action for Drink button
                withAnimation {
                    isPresented.toggle()
                }
            }) {
                Text("Add Meal")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color(hex: "072AC8"))
                    .cornerRadius(25)
            }
            Button("Close") {
                withAnimation {
                    isPresented.toggle()
                }
            }
            .padding()
           
        }
        .frame(maxWidth: .infinity)
        .background(Color(hex: "F2F2F2"))
        .cornerRadius(25)
    
        .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
        .animation(.easeInOut)
        .edgesIgnoringSafeArea(.all)
    }
}

struct FoodInputView_Previews: PreviewProvider {
    static var previews: some View {
        FoodInputView()
    }
}

