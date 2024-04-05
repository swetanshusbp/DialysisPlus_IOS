//
//  WeeklyReportsView.swift
//  DialysisPlus
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct WeeklyReportsView: View {
    var body: some View {
        VStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth: 400, maxHeight: 0)
            
            
            HStack {
                Capsule()
                    .rotation(.degrees(90))
                    .frame()
                
            }
            Spacer()

        }
    }
}

#Preview {
    WeeklyReportsView()
}
