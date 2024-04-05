//
//  userProfile.swift
//  DialysisPlus
//
//  Created by Abilasha  on 21/02/24.
//
import SwiftUI
import Foundation

struct UserProfile: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var profile = Profile(name: "John Doe", email: "john.doe@example.com", gender: "Male", weight: 70.0, height: 170.0, age: 30, sleepTime: Date(), wakeUpTime: Date(), image: nil, birthday: Date())
    @Binding var closeUserSheet: Bool
    @State private var isEditingProfile = false
    // Formatter for displaying time
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    @ObservedObject var fluidData: Fluid
    @EnvironmentObject var dailyIntakeManager: dailyIntakeManager
    
    var body: some View {
        
        if let user = viewModel.currentUser{
            NavigationStack{
                
                HStack(spacing:10){
                    
                    Text(user.initials)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width:72,height: 72)
                        .background(Color(.systemGray3))
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                  /*  if let profileImage = profile.image {
                        Image(uiImage: profileImage)
                            .resizable()
                            .padding()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width:100 , height:100)
                            .foregroundStyle(Color.accentColor)
                            .padding(.horizontal)
                    }*/
                    
                    VStack(alignment: .leading){
                        Text(user.fullname)
                            .font(.title2)
                            .bold()
                        Text(user.email)
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .navigationTitle("User Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Edit") {
                            isEditingProfile = true
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            closeUserSheet.toggle()
                        }
                    }

                }
                .padding(.horizontal)
                
                List{
                    Section("General Details") {
                        HStack{
                            Text("Age")
                            Spacer()
                            Text("\(profile.age)")
                        }
                        
                        HStack{
                            Text("Gender")
                            Spacer()
                            Text(profile.gender)
                        }
                        
                        HStack{
                            Text("Height")
                            Spacer()
                            Text(String(format:"%.2f cm", profile.height))
                        }
                        
                        HStack{
                            Text("Weight")
                            Spacer()
                            Text(String(format:"%.2f kg", profile.weight))
                        }
                    }
                    
                    Section("Nutrition Limit") {
                        HStack{
                            Text("Potassium Limit")
                            Spacer()
                            Text(String(format: "%.2f g", dailyIntakeManager.dailyIntake.totalK))
                        }
                        
                        HStack{
                            Text("Sodium Limit")
                            Spacer()
                            Text(String(format: "%.2f g", dailyIntakeManager.dailyIntake.totalNa))
                        }
                        
                        HStack{
                            Text("Fluid Intake Limit")
                            Spacer()
                            Text(String(format: "%.2f ml", fluidData.totalFluid * 1000))
                        }
                    }
                    
                    Section("Settings") {
                        HStack{
                            Text("Fluid Reminders")
                            Spacer()
                            Toggle("", isOn: $dailyIntakeManager.dailyIntake.notifications)
                        }
                        
                        HStack{
                            Text("Dark Mode")
                            Spacer()
                            Toggle("", isOn: $dailyIntakeManager.dailyIntake.darkMode)
                        }
                    }
                    
                    Section("Account"){
                        Button(action: {
                            viewModel.signOut()
                            
                        }, label: {
                            Text("Sign Out")
                                .foregroundStyle(Color.red)
                        })
                        Button(action: {
                            Task {
                                           await viewModel.deleteAccount()
                                       }
                        }, label: {
                            Text("Delete Account")
                                .foregroundStyle(Color.red)
                        })
                    }
                }
            }
            .preferredColorScheme( dailyIntakeManager.dailyIntake.darkMode ? .dark : .light)
            .sheet(isPresented: $isEditingProfile) {
                EditView(close: $isEditingProfile, fluidData: fluidData, closeEditSheet: $isEditingProfile)
            }
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(closeUserSheet: .constant(true), fluidData: Fluid(fluidDrank: 0, totalFluid: 2))
            .environmentObject(dailyIntakeManager())
    }
}


/*
 Text("Diet Goal")
     .font(.title3)
 
 HStack {
     
     ZStack(alignment: .topLeading) {
         Text("Potassium")
             .font(.subheadline)
             .frame(maxWidth:80, maxHeight:5)
             .offset(y: -5)
             .foregroundColor(.gray)
             .background(.white)
         TextField("Potassium", value: $profile.potassium, formatter: NumberFormatter())
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .zIndex(-1)
     }
     
     
     
     ZStack(alignment: .topLeading) {
         Text("Sodium")
             .font(.subheadline)
             .frame(maxWidth:60, maxHeight:5)
             .offset(y: -5)
             .foregroundColor(.gray)
             .background(.white)
         TextField("Sodium", value: $profile.sodium, formatter: NumberFormatter())
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .zIndex(-1)
     }
     
 }.padding(.vertical)
 
 Text("Fluid Goal")
     .font(.title3)
 
 
 ZStack(alignment: .topLeading) {
     Text("Fluid")
         .font(.subheadline)
         .frame(maxWidth:40, maxHeight:5)
         .offset(y: -5)
         .foregroundColor(.gray)
         .background(.white)
     TextField("Fluid", value: $profile.water, formatter: NumberFormatter())
         .textFieldStyle(RoundedBorderTextFieldStyle()).zIndex(-1)
 }.padding(.vertical)
 
 
 */
