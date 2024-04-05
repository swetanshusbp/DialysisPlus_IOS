//
//  FirebaseHelper.swift
//  DialysisPlus
//
//  Created by Meghs on 23/03/24.
//
import SwiftUI
import UserNotifications
import FirebaseFirestore
import Firebase
import FirebaseAuth
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        deleteOldLogs()
        return true
    }
    
    private func deleteOldLogs() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            return
        }
        
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd_MM_yyyy" // Format for the current date
        
        let currentDate = formatter.string(from: Date()) // Get the current date
        
        // Get the date 7 days ago from the current date
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        // Delete old logs from the "FluidLog" collection
        db.collection("users").document(currentUserID).collection("FluidLog").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching FluidLog documents: \(error)")
                return
            }
            
            guard let fluidLogDocuments = snapshot?.documents else {
                print("No FluidLog documents found")
                return
            }
            
            for document in fluidLogDocuments {
                let docID = document.documentID
                
                // Split the document ID to extract the date part
                let components = docID.components(separatedBy: "_")
                if components.count >= 4 {
                    let docDate = components[0] + "_" + components[1] + "_" + components[2] // Extract the date part
                    
                    // Compare the date part with the current date
                    if docDate != currentDate {
                        // Delete the document
                        db.collection("users").document(currentUserID).collection("FluidLog").document(docID).delete { error in
                            if let error = error {
                                print("Error deleting FluidLog document \(docID): \(error)")
                            } else {
                                print("FluidLog document \(docID) deleted successfully")
                            }
                        }
                    }
                }
            }
        }
        
        // Delete old logs from the "Fluid" collection
        db.collection("users").document(currentUserID).collection("Fluid").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching Fluid documents: \(error)")
                return
            }
            
            guard let fluidDocuments = snapshot?.documents else {
                print("No Fluid documents found")
                return
            }
            
            for document in fluidDocuments {
                let docID = document.documentID
                
                // Extract the date part from the document ID
                if let docDate = formatter.date(from: docID) {
                    // Compare the date part with the start date (7 days ago)
                    if docDate < startDate {
                        // Delete the document
                        db.collection("users").document(currentUserID).collection("Fluid").document(docID).delete { error in
                            if let error = error {
                                print("Error deleting Fluid document \(docID): \(error)")
                            } else {
                                print("Fluid document \(docID) deleted successfully")
                            }
                        }
                    }
                }
            }
        }
    }

}


struct FirestoreHelper {
    
    // fluid
    //add fluid log
    func AddInfo(ml: Int, time: String, drink: Int) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            return
        }
        
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd_MM_yyyy_HH_mm_ss"
        let docID = formatter.string(from: Date())
        
        let fluidLogData: [String: Any] = [
            "id": docID,
            "drink": drink,
            "ml": ml,
            "time": time
        ]
        
        db.collection("users").document(currentUserID).collection("FluidLog").document(docID).setData(fluidLogData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully to FluidLog of current user's collection")
            }
        }
    }
    
    

    
    
    //addfluid

    func addFluid(ml: Int, percentage: Double) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            return
        }
        
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd_MM_yyyy"
        let docID = formatter.string(from: Date())
        
        db.collection("users").document(currentUserID).collection("Fluid").document(docID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
            
            if let document = snapshot, document.exists {
                var existingFluidData = document.data() ?? [:]
                let existingFluidDrank = existingFluidData["fluidDrank"] as? Int ?? 0
                let updatedFluidDrank = existingFluidDrank + ml
                existingFluidData["fluidDrank"] = updatedFluidDrank
                existingFluidData["fluidPercentage"] = percentage
                
                db.collection("users").document(currentUserID).collection("Fluid").document(docID).setData(existingFluidData, merge: true) { error in
                    if let error = error {
                        print("Error updating fluid data: \(error)")
                    } else {
                        print("Fluid data updated successfully")
                    }
                }
            } else {
                let fluidData = [
                    "fluidDrank": ml,
                    "fluidPercentage": percentage
                ]
                
                db.collection("users").document(currentUserID).collection("Fluid").document(docID).setData(fluidData) { error in
                    if let error = error {
                        print("Error adding fluid data: \(error)")
                    } else {
                        print("Fluid data added successfully")
                    }
                }
            }
        }
    }
    
    
    //weekly percentage

    func getFluidPercentages(completion: @escaping ([Double]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            completion([])
            return
        }
        
        let db = Firestore.firestore()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd_MM_yyyy" // Format for the document ID
        
        // Get the current date
        let endDate = Date()
        
        // Calculate the start date as 7 days before the end date
        guard let startDate = Calendar.current.date(byAdding: .day, value: -6, to: endDate) else {
            print("Error: Failed to calculate start date.")
            completion([])
            return
        }
        
        var fluidPercentages: [Double] = []
        var fluidData: [Date: Double] = [:] // Dictionary to store date and corresponding fluid percentage
        
        var currentDate = startDate
        
        let dispatchGroup = DispatchGroup()
        
        // Fetch fluid documents for the last 7 days
        for _ in 0..<7 {
            dispatchGroup.enter()
            let docID = formatter.string(from: currentDate)
            
            // Fetch fluid document for the current date
            db.collection("users").document(currentUserID).collection("Fluid").document(docID).getDocument { snapshot, error in
                defer {
                    dispatchGroup.leave()
                }
                
                if let error = error {
                    print("Error fetching document for \(docID): \(error)")
                } else {
                    if let document = snapshot, document.exists {
                        // If document exists, retrieve fluid percentage and associate it with the date
                        let fluidPercentage = document.data()?["fluidPercentage"] as? Double ?? 0
                        fluidData[currentDate] = fluidPercentage
                    } else {
                        // If document doesn't exist for a date, set its percentage to 0
                        fluidData[currentDate] = 0
                    }
                }
            }
            
            // Move to the next date
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
        }
        
        // Notify when all documents have been fetched
        dispatchGroup.notify(queue: .main) {
            // Sort the dates
            let sortedDates = fluidData.keys.sorted()
            
            // Populate fluidPercentages array in the sorted order
            for date in sortedDates {
                fluidPercentages.append(fluidData[date]!)
            }
            
            completion(fluidPercentages)
        }
    }

    
    //fetch fluid
    
    
    func fetchFluidDrankForCurrentDate(completion: @escaping (Double?) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd_MM_yyyy" // Format for the document ID
        let docID = formatter.string(from: Date()) // Generate the document ID using current date
        
        db.collection("users").document(currentUserID).collection("Fluid").document(docID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching document: \(error)")
                completion(nil)
                return
            }
            
            if let document = snapshot, document.exists {
                let fluidDrank = document.data()?["fluidDrank"] as? Double
                completion(fluidDrank)
            } else {
                // Document doesn't exist for the current date
                completion(nil)
            }
        }
    }
    
    // diet
    
    func addDietBreakfast(mealType: String, foodName: String, sodiumContent: Double, potassiumContent: Double, time: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            return
        }
        
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd_MM_yyyy"
        let docID = formatter.string(from: Date())
        
        // Create a reference to the meal document within the current user's collection
        let mealRef = db.collection("users").document(currentUserID).collection("meals").document(docID)
        
        // Get the existing data for the specified meal type
        mealRef.getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            // Check if the document exists
            if let document = document, document.exists {
                // Document exists, update it with the new food item
                var mealData = document.data() ?? [:]
                
                // Check if meal type data exists, otherwise create a new array
                var mealItems = mealData[mealType] as? [[String: Any]] ?? []
                let newMealItem = [
                    "foodName": foodName,
                    "sodiumContent": sodiumContent,
                    "potassiumContent": potassiumContent,
                    "time": time
                ]
                mealItems.append(newMealItem)
                
                // Update only the meal type data in Firestore
                mealData[mealType] = mealItems
                mealRef.setData(mealData) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document updated successfully")
                        // Call addTodaysIntake after updating the diet
                        addTodaysIntake()
                    }
                }
            } else {
                // Document doesn't exist, create a new one with the new food item
                let newMealData: [String: Any] = [
                    mealType: [
                        [
                            "foodName": foodName,
                            "sodiumContent": sodiumContent,
                            "potassiumContent": potassiumContent,
                            "time": time
                        ]
                    ]
                ]
                
                // Set the new document in Firestore
                mealRef.setData(newMealData) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added successfully")
                        // Call addTodaysIntake after updating the diet
                        addTodaysIntake()
                    }
                }
            }
        }
    }

    func addTodaysIntake() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            return
        }
        
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd_MM_yyyy"
        let docID = formatter.string(from: Date())
        
        // Create a reference to the meal document within the current user's collection
        let mealRef = db.collection("users").document(currentUserID).collection("meals").document(docID)
        
        // Check if the document already exists
        mealRef.getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            var totalValues: [String: [String: Any]] = [
                "Breakfast": ["sodiumContent": 0, "potassiumContent": 0],
                "Lunch": ["sodiumContent": 0, "potassiumContent": 0],
                "Dinner": ["sodiumContent": 0, "potassiumContent": 0],
                "Snacks": ["sodiumContent": 0, "potassiumContent": 0]
            ]
            
            if let document = document, document.exists {
                // Document exists, update the existing data
                var mealData = document.data() ?? [:]
                
                // Update the specific meal type data with the new values
                // Iterate through each meal type and gather total sodium and potassium content
                for (mealType, values) in mealData {
                    // Skip iteration if mealType is "Total"
                    if mealType == "Total" {
                        continue
                    }
                    
                    if let foodItems = values as? [[String: Any]] {
                        // Initialize total sodium and potassium content for the meal type
                        var totalSodiumContent = 0.0
                        var totalPotassiumContent = 0.0
                        
                        // Iterate through each food item in the meal type
                        for foodItem in foodItems {
                            if let sodiumContent = foodItem["sodiumContent"] as? Double,
                               let potassiumContent = foodItem["potassiumContent"] as? Double {
                                // Accumulate sodium and potassium content
                                totalSodiumContent += sodiumContent
                                totalPotassiumContent += potassiumContent
                            }
                        }
                        
                        // Store the total sodium and potassium content for the meal type
                        totalValues[mealType] = [
                            "sodiumContent": totalSodiumContent,
                            "potassiumContent": totalPotassiumContent
                        ]
                    }
                }
                
                mealData["Total"] = totalValues
                
                // Update the document in Firestore
                mealRef.setData(mealData) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document updated successfully")
                    }
                }
            } else {
                // Document doesn't exist, create a new one with default values
                let newMealData: [String: Any] = [
                    "Total": [
                        "Breakfast": [
                            "sodiumContent": 0,
                            "potassiumContent": 0
                        ],
                        "Lunch": [
                            "sodiumContent": 0,
                            "potassiumContent": 0
                        ],
                        "Dinner": [
                            "sodiumContent": 0,
                            "potassiumContent": 0
                        ],
                        "Snacks": [
                            "sodiumContent": 0,
                            "potassiumContent": 0
                        ]
                    ]
                ]
                
                // Set the new document in Firestore
                mealRef.setData(newMealData) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added successfully")
                    }
                }
            }
        }
    }

    
    func getDietDetails(mealType: String, completion: @escaping ([[String: Any]]?) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd_MM_yyyy"
        let docID = formatter.string(from: Date())
        
        // Create a reference to the meal document within the current user's collection
        let mealRef = db.collection("users").document(currentUserID).collection("meals").document(docID)
        
        // Get the existing data for the specified meal type
        mealRef.getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
                completion(nil) // Invoke completion handler with nil to indicate error
                return
            }
            
            // Check if the document exists and contains data
            guard let document = document, document.exists,
                  let mealData = document.data(),
                  let meals = mealData[mealType] as? [[String: Any]] else {
                // If document doesn't exist, or meal type data is missing, return an empty array
                completion([])
                return
            }
            
            // Return the meal details for the specified meal type
            completion(meals)
        }
    }

    
    func getDietInfo(completion: @escaping ([String: [String: Any]]?) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd_MM_yyyy"
        let docID = formatter.string(from: Date())
        
        // Create a reference to the meal document within the current user's collection
        let mealRef = db.collection("users").document(currentUserID).collection("meals").document(docID)
        
        // Get the existing data for the meal document
        mealRef.getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
                completion(nil)
                return
            }
            
            if let document = document, document.exists {
                // Document exists, extract data from the "Total" section
                if let mealData = document.data(), let totalData = mealData["Total"] as? [String: [String: Any]] {
                    completion(totalData)
                } else {
                    // "Total" section doesn't exist or has invalid format
                    print("Total section not found or invalid format")
                    completion(nil)
                }
            } else {
                // Document doesn't exist
                print("Document does not exist")
                completion(nil)
            }
        }
    }

    func updateDietDetails(mealType: String, data: [[String: Any]]) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            return
        }
        
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd_MM_yyyy"
        let docID = formatter.string(from: Date())
        
        // Create a reference to the meal document within the current user's collection
        let mealRef = db.collection("users").document(currentUserID).collection("meals").document(docID)
        
        // Get the existing data for the specified meal type
        mealRef.getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            // Check if the document exists
            if let document = document, document.exists {
                // Document exists, update it with the new food item
                var mealData = document.data() ?? [:]
                
                // Update only the meal type data in Firestore
                mealData[mealType] = data
                mealRef.setData(mealData) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document updated successfully")
                        // Call addTodaysIntake after updating the diet
                        addTodaysIntake()
                    }
                }
            }
        }
    }

    
    func fetchLastSevenDocuments(completion: @escaping ([String: Double], [String: Double]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            completion([:], [:])
            return
        }
        
        let db = Firestore.firestore()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd_MM_yyyy"
        
        let dispatchGroup = DispatchGroup()
        
        var k: [String: Double] = [:]
        var na: [String: Double] = [:]
        
        for i in (0...6).reversed() {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
                let docID = formatter.string(from: date)
                dispatchGroup.enter()
                
                // Create a reference to the meal document within the current user's collection
                let mealRef = db.collection("users").document(currentUserID).collection("meals").document(docID)
                
                mealRef.getDocument { snapshot, error in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    if let error = error {
                        print("Error fetching document for \(docID): \(error)")
                    } else if let document = snapshot, document.exists {
                        if let data = document.data(), let totalData = data["Total"] as? [String: Any] {
                            if let breakfast = totalData["Breakfast"] as? [String: Any],
                               let lunch = totalData["Lunch"] as? [String: Any],
                               let dinner = totalData["Dinner"] as? [String: Any],
                               let snacks = totalData["Snacks"] as? [String: Any]  {
                                var potassium: Double = 0
                                var sodium: Double = 0
                                
                                if let breakfastPotassium = breakfast["potassiumContent"] as? Double {
                                    potassium += breakfastPotassium
                                }
                                if let breakfastSodium = breakfast["sodiumContent"] as? Double {
                                    sodium += breakfastSodium
                                }
                                
                                if let lunchPotassium = lunch["potassiumContent"] as? Double {
                                    potassium += lunchPotassium
                                }
                                if let lunchSodium = lunch["sodiumContent"] as? Double {
                                    sodium += lunchSodium
                                }
                                
                                if let dinnerPotassium = dinner["potassiumContent"] as? Double {
                                    potassium += dinnerPotassium
                                }
                                if let dinnerSodium = dinner["sodiumContent"] as? Double {
                                    sodium += dinnerSodium
                                }
                                
                                if let snacksPotassium = snacks["potassiumContent"] as? Double {
                                    potassium += snacksPotassium
                                }
                                if let snacksSodium = snacks["sodiumContent"] as? Double {
                                    sodium += snacksSodium
                                }
                                
                                k[docID] = potassium
                                na[docID] = sodium
                            }
                        }
                    } else {
                        k[docID] = 0
                        na[docID] = 0
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(k, na)
        }
    }

    
    
    
}
