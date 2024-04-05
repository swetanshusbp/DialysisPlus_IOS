//
//  DietTrackingView.swift
//  DialysisPlus
//
//  Created by user1 on 16/01/24.
//

import SwiftUI

struct DietTrackingView: View {
    @State private var potassiumPercentage: Double = 0.0
    @EnvironmentObject var DailyIntakeManager : dailyIntakeManager
    
    var body: some View {
        
        NavigationStack{
            ScrollView{
                Divider()
                Spacer()
                VStack {
                    DietLevelView()
                        .padding(.bottom,10)
                    FoodInputView()
                }
                .navigationTitle("Diet Manager")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
        DietTrackingView()
            .environmentObject(dailyIntakeManager())
}

