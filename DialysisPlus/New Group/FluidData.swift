import Foundation
import FirebaseFirestore

class Fluid: ObservableObject {
    @Published var fluidDrank: Double
    @Published var totalFluid: Double
    @Published var drinkLog: [DrinkLogItem]

    var fluidPercentage: Double {
        return fluidDrank / totalFluid
    }

    init(fluidDrank: Double, totalFluid: Double) {
        self.fluidDrank = fluidDrank
        self.totalFluid = totalFluid
        self.drinkLog = []
    }

    func addDrinkLog(id: String, ml: Int, time: String,drink:Int) {
        let newLogItem = DrinkLogItem(id:id ,ml: ml, time: time,drink: drink)
        drinkLog.append(newLogItem)
    }
}

struct DrinkLogItem: Identifiable {
    let id: String
    let ml: Int
    let time: String
    let drink:Int
}

let drinkable : [DrinkSelectModel] = [
    DrinkSelectModel(name: "water ", image:"drink1"),
    DrinkSelectModel(name: "coffee ", image:"drink2"),
    DrinkSelectModel(name: "tea ", image:"drink3"),
    DrinkSelectModel(name: "milk ", image:"drink4"),
    DrinkSelectModel(name: "juice ", image:"drink5"),
    DrinkSelectModel(name: "hot drink ", image:"drink6"),
    DrinkSelectModel(name: "soft drink ", image:"drink7"),
    DrinkSelectModel(name: "energy drink", image:"drink8"),
    DrinkSelectModel(name: "other ", image:"drink9"),
    
]

struct DrinkSelectModel {
    var name: String
    var image: String
}
