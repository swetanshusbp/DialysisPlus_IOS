//
//  Bar.swift
//  DialysisPlus
//
//  Created by user1 on 10/01/24.

import Foundation
import SwiftUI

struct Bar: View {
    let color : Color
    let height: CGFloat
    let threshold: CGFloat
    @State private var scale: CGFloat = 0
    
    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(height > threshold ? Color.red : Color(color))
                .frame(width: 12, height: min(height / threshold * 50 , 70))
            
            
        }
        .frame(maxHeight: 100)
    }
}
