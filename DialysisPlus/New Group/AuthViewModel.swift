//
//  AuthViewModel.swift
//  DialysisPlus
//
//  Created by Abilasha  on 02/04/24.
//
import Foundation
import Firebase
import FirebaseAuth
protocol AuthenticationFormProtocol{
    var formIsValid: Bool{
get
    }
}


@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    
    init()
    {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    func signIn(withEmail email: String , password: String) async throws{
        do{  let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }
        catch{
            print("faild log in")
        }
        
    }
    
    func createUser(withEmail email: String ,password: String, fullName:String)async throws{
        do {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        self.userSession = result.user
        let user = User(id: result.user.uid, fullname: fullName, email: email)
        let encodedUser = try Firestore.Encoder().encode(user)
        try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
        await fetchUser()
        } catch
        {
        
        print("DEBUG: Failed to create user with error (error.localizedDescription)")
        
        }
        
        
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        }catch{
            print("failed to sign out")
        }
    }
    func deleteAccount() async {
        do {
            // Get the current user's UID
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            // Delete the user document from Firestore
            try await Firestore.firestore().collection("users").document(uid).delete()
            
            // Sign out the user
            try Auth.auth().signOut()
            
            // Reset userSession and currentUser
            self.userSession = nil
            self.currentUser = nil
            
        } catch {
            print("Failed to delete account with error: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard  let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument()
        else {return}
        self.currentUser = try?snapshot.data(as: User.self)
        
        print("DEBUG : current user is\(self.currentUser)")
    }
    
}
