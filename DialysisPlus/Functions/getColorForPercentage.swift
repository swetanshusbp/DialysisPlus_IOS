//
//  getColorForPercentage.swift
//  DialysisPlus
//
//  Created by user1 on 16/01/24.
//

import Foundation
import SwiftUI

func getColorForPercentage(_ percent: Double) -> Color {
    switch percent {
    case 0..<40:
        return Color(hexString: "00FC19")
    case 40..<75:
        return Color(hexString: "FFC600")
    case 75...100:
        return Color(hexString: "FF0000")
    default:
        return .clear
    }
}
