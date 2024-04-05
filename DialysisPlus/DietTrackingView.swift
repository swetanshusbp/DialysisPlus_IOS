//
//  DietTrackingView.swift
//  DialysisPlusNew
//
//  Created by admin on 02/01/24.
//

import SwiftUI

struct DietTrackingView: View {
    var body: some View {
        VStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth:400, maxHeight: 0)
            VStack {
                Text("Diet Tracking")
                    .font(.title)
                    .padding(.top,90)
                
                DietLevelView()
                    .padding(.bottom,10)
              FoodInputView()
                    
                // Making DailyGoalsView transparent
                
               
            
                
            }
           
            .cornerRadius(20)
            .padding(.top, -30)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            
            Spacer()
        }
    }
    }


#Preview {
    DietTrackingView()
}

