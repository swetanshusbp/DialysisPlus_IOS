//
//  userdata.swift
//  DialysisPlus
//
//  Created by Abilasha  on 21/02/24.
//

import Foundation




import UIKit
class Profile: ObservableObject {
    @Published var name: String
    @Published var email: String
    @Published var gender: String
    @Published var weight: Double
    @Published var height: Double
    @Published var age: Int
    @Published var sleepTime: Date
    @Published var wakeUpTime: Date
    @Published var image: UIImage?
    @Published var birthday: Date
    
    init(name: String, email: String, gender: String, weight: Double, height: Double, age: Int, sleepTime: Date, wakeUpTime: Date,  image: UIImage?, birthday: Date) {
        self.name = name
        self.email = email
        self.gender = gender
        self.weight = weight
        self.height = height
        self.age = age
        self.sleepTime = sleepTime
        self.wakeUpTime = wakeUpTime
        self.image = image
        self.birthday = birthday
    }
}


class Edit: ObservableObject {
    @Published var fluid: Double
    @Published var sodium: Double
    @Published var potassium: Double
    init(fluid: Double, sodium: Double,potassium: Double) {
        self.fluid = fluid
        self.sodium = sodium
        self.potassium = potassium
    }
   
}
