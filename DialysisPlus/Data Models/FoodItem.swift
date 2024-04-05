//
//  FoodItem.swift
//  DialysisPlus
//
//  Created by user1 on 16/01/24.
//

import Foundation


struct FoodItem {
    var name: String
    var potassium: Double
    var sodium: Double
    var time: Date
    
    
    init(name: String, potassium: Double, sodium: Double) {
            self.name = name
            self.potassium = potassium
            self.sodium = sodium
            self.time = Date()
        }
}
