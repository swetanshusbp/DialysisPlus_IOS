//
//  compare.swift
//  DialysisPlus
//
//  Created by user1 on 17/01/24.
//

import Foundation

func compare(val1 : Double , total : Double ) -> Bool{
    if val1/total > 0.75 {
        return true
    }
    return false
}
