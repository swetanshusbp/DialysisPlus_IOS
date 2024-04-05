//
//  Previousview.swift
//  DialysisPlus
//
//  Created by admin on 27/12/23.
//

import SwiftUI

struct PreviousAppoinmentView: View {
    var body: some View {
        VStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth: 400, maxHeight: 0)
                   HStack {
                       Button(action: {
                           // Action for the toilet button
                       }) {
                           Text("Upcoming          ")
                               .fontWeight(.bold)
                               .multilineTextAlignment(.center)
                               .padding()
                               .foregroundColor(.black)
                               .background(Color(hex:"A2D6F9"))
                               .cornerRadius(25)
                       }

                       Button(action: {
                           // Action for the very color button
                       }) {
                           Text("Previous              ")
                               .fontWeight(.bold)
                               .multilineTextAlignment(.center)
                               .padding()
                               .foregroundColor(.white)
                               .background(Color(hex:"072AC8"))
                               .cornerRadius(25)
                       }
                   }
                   .padding(.top,70) // Add some top padding to the HStack

                    // Pushes the content to the top

                  
                .padding(.vertical, 20)
            PastAppView()
            Spacer()
               }
    }
}


#Preview {
    PreviousAppoinmentView()
}

