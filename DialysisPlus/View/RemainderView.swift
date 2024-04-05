import SwiftUI
import UserNotifications

struct ReminderView: View {
    @Binding var remainderEnabled :Bool
    @State private var selectedTimeInterval = 0
    @State private var selectedAmountIndex = 0
    
    let timeIntervalOptions = [60 ,1800, 5400, 7200 ,9000] 
    let amountOptions = ["100", "200","250", "300" , "350" , "500"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "EFEFEF"))
                .frame(width: 170, height: 200)
                .overlay(
                    VStack(spacing: 20) {
                        Text("Reminder")
                            .font(.headline)
                            .padding(.top, 10)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .overlay(
                                HStack {
                                    Text("Remainder")
                                        .foregroundColor(.black)
                                        .font(.caption)
                                    Spacer()
                                    Toggle("", isOn: $remainderEnabled)
                                        .labelsHidden()
                                        
                                        .scaleEffect(0.9)
                                }
                                .padding(5)
                            )
                            .frame(height: 35)
                            .padding(.horizontal, 5)
                            
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .overlay(
                                HStack {
                                    Text("Time")
                                        .font(.caption)
                                        .padding(.horizontal , 10)
                                    Spacer()
                                    
                                    Picker(selection: $selectedTimeInterval, label: Text("")) {
                                        ForEach(0..<timeIntervalOptions.count, id: \.self) { index in
                                            Text("\(timeIntervalOptions[index] / 60) min")
                                                .font(.subheadline)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    
                                    .scaleEffect(0.8)
                                    .offset(x:15)
                                }
                              
                            )
                            .frame(height: 35)
                            .padding(.horizontal,5)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .overlay(
                                HStack {
                                    Text("Amount")
                                        .font(.caption)
                                        .offset(x:5)
                                    
                                    Spacer()
                                    Picker(selection: $selectedAmountIndex, label: Text("")) {
                                        ForEach(0..<amountOptions.count, id: \.self) { index in
                                            Text("\(amountOptions[index]) ml")
                                                .font(.subheadline)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                 
                                    .scaleEffect(0.8)
                                   
                                }
                                .padding(.horizontal, 5)
                            )
                            .frame(height: 35)
                            .padding(.horizontal, 5)
                    }
                    .padding(.bottom, 10)
                )
        }
        .onAppear {
            scheduleNotification()
        }
        .onChange(of: remainderEnabled) { value in
            if value {
                scheduleNotification()
            } else {
                cancelNotification()
            }
        }
    }
    
    private func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        
        cancelNotification()
        
        if remainderEnabled {
            let content = UNMutableNotificationContent()
            content.title = "It's been a while since you last drank water!"
            content.body = "Stay hyderated by drinking  \(amountOptions[selectedAmountIndex]) ml of water"
            content.sound = .defaultRingtone
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeIntervalOptions[selectedTimeInterval]), repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }
    
    private func cancelNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}


struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView(remainderEnabled: .constant(false))
    }
}


