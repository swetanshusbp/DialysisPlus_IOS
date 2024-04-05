//
//  EditView.swift
//  DialysisPlus
//
//  Created by Abilasha  on 03/03/24.
//

import SwiftUI

struct EditView: View {
    @Binding var close : Bool
    @ObservedObject var fluidData: Fluid
    @StateObject private var edit = Edit(fluid: 2000, sodium: 2000, potassium: 2000)
    @EnvironmentObject var dailyIntakeManager: dailyIntakeManager // Inject dailyIntakeManager
    
    @Binding var closeEditSheet : Bool
    var body: some View {
        NavigationStack{
            Form{
                Section("Diet Limit") {
                    HStack {
                        Text("Potassium Limit")
                        Spacer()
                        TextField("Potassium", value: $edit.potassium, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        Text("g")
                    }
                    HStack {
                        Text("Sodium Limit")
                        Spacer()
                        TextField("Potassium", value: $edit.sodium, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        Text("g")
                    }
                    
                }
                
                Section("Fluid Limit") {
                    HStack {
                        Text("Fluid Limit")
                        Spacer()
                        TextField("Fluid", value: $edit.fluid, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        Text("ml")
                    }
                }
                
                Button(action: {
                    // Update profile information
                    fluidData.totalFluid = edit.fluid / 1000
                    dailyIntakeManager.dailyIntake.totalK = edit.potassium
                    dailyIntakeManager.dailyIntake.totalNa = edit.sodium
                    
                    closeEditSheet.toggle()
                }) {
                    Text("Save Changes")
                }
                
            }.navigationTitle("")
                .onAppear {
                    edit.potassium = dailyIntakeManager.dailyIntake.totalK
                    edit.sodium = dailyIntakeManager.dailyIntake.totalNa
                    edit.fluid = fluidData.totalFluid * 1000
                }
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            closeEditSheet.toggle()
                        }, label: {
                            Text("Cancel")
                        })
                    }
                }
        }
    }
}


struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(close: .constant(true), fluidData: Fluid(fluidDrank: 56, totalFluid: 76), closeEditSheet: .constant(false))
            .environmentObject(dailyIntakeManager())
    }
}
