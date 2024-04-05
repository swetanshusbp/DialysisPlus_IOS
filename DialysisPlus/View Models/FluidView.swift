import SwiftUI
import UserNotifications
import FirebaseFirestore

struct FluidView: View {
    @State private var selectedAmountIndex = 0
    let amountOptions = ["100ml", "200ml","250ml", "300ml" , "350ml" , "500ml"]
    @ObservedObject var fluidData: Fluid
    @State private var isShowingPopUp = false
    @State private var selectedDrinkIndex: Int? = 0
    @State var reminderEnabled : Bool = false
    @State var openSheet : Bool = false
    @EnvironmentObject var dailyIntakeManager : dailyIntakeManager
    
    var body: some View {
        NavigationStack {
            ScrollView{
                Divider()
                
                VStack {
                    Text("Remember to keep track of your fluid!")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    FluidTrackerView(fluidData: fluidData)
                    DrinkSelectionView(selectedDrinkIndex: $selectedDrinkIndex, isShowingPopUp: $isShowingPopUp, selectedAmountIndex: $selectedAmountIndex, amountOptions: amountOptions)
                    
                    Button(action: {
                        self.drinkButtonAction()
                    }) {
                        Text("Drink")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color(hex: "072AC8"))
                            .cornerRadius(25)
                    }
                    
                        DrinkLogView(fluidData: fluidData)
                            .padding(.vertical, 10)
                
                    
                }
                .offset(y:30)
                .padding(.bottom,50)
            }
            .sheet(isPresented: $openSheet) {
                RemainderViewUpdated(remainderEnabled: $dailyIntakeManager.dailyIntake.notifications, closeSheet: $openSheet)
            }
            .navigationTitle("Fluid Manager")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        openSheet = true
                    } label: {
                        Image(systemName: "timer")
                    }
                }
            }
        }
    }
    
    private func drinkButtonAction() {
        if let selectedAmount = Double(amountOptions[selectedAmountIndex].dropLast(2)) {
            fluidData.fluidDrank += (selectedAmount / 1000)
            let currentTime = getCurrentTime()
            self.AddInfo(ml:  Int(selectedAmount), time: currentTime, drink: selectedDrinkIndex!)
            self.addFluid(ml: Int(selectedAmount),percentage: fluidData.fluidPercentage)
        }
    }
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
    
    private func AddInfo(ml: Int, time: String, drink: Int) {
        FirestoreHelper().AddInfo(ml: ml, time: time, drink: drink)
    }
    
    private func addFluid(ml: Int , percentage: Double) {
        FirestoreHelper().addFluid(ml: ml, percentage: percentage)
    }
}

struct FluidView_Previews: PreviewProvider {
    static var previews: some View {
        FluidView(fluidData: Fluid(fluidDrank: 0.0, totalFluid: 2.0))
            .environmentObject(dailyIntakeManager())
    }
}

extension FluidView {
    struct DrinkSelectionView: View {
        @Binding var selectedDrinkIndex: Int?
        @Binding var isShowingPopUp: Bool
        @Binding var selectedAmountIndex: Int
        let amountOptions: [String]
        
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(width: 240, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            .frame(width: 240, height: 60)
                            .padding(2)
                            .background(Color.white)
                            .cornerRadius(20)
                            .opacity(0.7)
                    )
                    .overlay(
                        HStack {
                            Button(action: {
                                isShowingPopUp.toggle()
                            }) {
                                VStack(alignment: .center) {
                                    Image(selectedDrinkIndex != nil ? "drink\(selectedDrinkIndex! + 1)" : drinkable[0].image)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                    Text(selectedDrinkIndex != nil ? drinkable[selectedDrinkIndex!].name : drinkable[0].name)
                                        .foregroundColor(.black)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: 120)
                            }
                            .sheet(isPresented: $isShowingPopUp, onDismiss: {
                                
                            }) {
                                SelectDrinkView(selectedDrinkIndex: $selectedDrinkIndex, isPresented: $isShowingPopUp)
                            }
                            
                            Picker(selection: $selectedAmountIndex, label: Text("")) {
                                ForEach(0..<amountOptions.count, id: \.self) { index in
                                    Text(amountOptions[index])
                                        .font(.system(size: 14))
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    )
            }
            .padding()
        }
    }
}



