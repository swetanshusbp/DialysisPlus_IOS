//
//  RemainderViewUpdated.swift
//  DialysisPlus
//
//  Created by user1.0 on 13/03/24.
//

import SwiftUI

struct RemainderViewUpdated: View {
    @Binding var remainderEnabled : Bool
    @Binding var closeSheet : Bool
    @State private var selectedTimeInterval = 0
    @State private var selectedAmountIndex = 0
    
    let timeIntervalOptions = [60 ,1800, 5400, 7200 ,9000]
    let amountOptions = ["100", "200","250", "300" , "350" , "500"]
    
    var body: some View {
        NavigationStack{
            Form(content: {
                Section("Reminder View") {
                    HStack{
                        Text("Enable Reminder")
                        
                        Toggle("", isOn: $remainderEnabled)
                    }
                    
                    
                    HStack{
                        Text("Time interval")
                        
                        Picker(selection: $selectedTimeInterval, label: Text("")) {
                            ForEach(0..<timeIntervalOptions.count, id: \.self) { index in
                                Text("\(timeIntervalOptions[index] / 60) min")
                            }
                        }
                        .pickerStyle(.menu)
                        
                    }
                    
                    HStack{
                        Text("Amount")
                        
                        Spacer()
                        Picker(selection: $selectedAmountIndex, label: Text("")) {
                            ForEach(0..<amountOptions.count, id: \.self) { index in
                                Text("\(amountOptions[index]) ml")
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            })
            
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
            .navigationTitle("Fluid Reminders")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { closeSheet = false}, label: {
                        Text("Cancel")
                    })
                }
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





#Preview {
    RemainderViewUpdated(remainderEnabled: .constant(true), closeSheet: .constant(true))
}
