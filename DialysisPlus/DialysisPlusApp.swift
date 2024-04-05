//
//  DialysisPlusApp.swift
//  DialysisPlus
//
//  Created by user1 on 09/01/24.
//

import SwiftUI
import UserNotifications
import FirebaseFirestore
import Firebase

@main
struct DialysisPlusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        requestNotificationAuthorization()
        
    }
    
    @StateObject var viewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .environmentObject(viewModel)
 
             }
        }
        
        
    }

