//
//  str2double.swift
//  DialysisPlus
//
//  Created by user1 on 17/01/24.
//

import Foundation


func str2double( number : String) -> Double{
    let formatter = NumberFormatter()
    var val : Double
    if let number = formatter.number(from: number) {
    val = number.doubleValue
        } else {
        val  = 0
    }
    
    return val
}

func getCurrentTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: Date())
}
