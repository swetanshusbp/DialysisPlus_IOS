//
//  calculatePercentage.swift
//  DialysisPlus
//
//  Created by user1 on 16/01/24.
//

import Foundation

func calculatePercentage(consumed: Double, total: Double) -> Double {
    return min((consumed / total) * 100, 100)
}
