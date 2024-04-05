//
//  SlideUpView.swift
//  DialysisPlus
//
//  Created by user1 on 16/01/24.
//

import SwiftUI

struct SlideUpView: View {
    @State var mealData: [[String: Any]] = [[:]]
    @EnvironmentObject var dailyIntakeManager: dailyIntakeManager
    
    @ObservedObject var slideUpState: SlideUpState
    @State private var isAddMealSheetPresented = false
    
    var title: String

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                getFoodDetails(title: title, mealData: mealData, dailyIntakeManager: dailyIntakeManager)
                    
                  
                Button {
                    isAddMealSheetPresented = true
                } label: {
                    Text("Add Meal")
                        .frame(width: 100)
                        .padding()
                        .background(Color(.blue))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            .onAppear{
                FirestoreHelper().getDietDetails(mealType: title) { items in
                    if let items = items {
                        self.mealData = items
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        withAnimation {
                            slideUpState.isPresented.toggle()
                        }
                    }
                }
            }
            .padding(.top)
            .padding(.top)
            .padding(.bottom)
            .padding(.bottom)
            .offset(y: slideUpState.isPresented ? 0 : UIScreen.main.bounds.height)
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $isAddMealSheetPresented) {
                AddMeal2(isPresented: $isAddMealSheetPresented, title: title)
            }
        }
    }
}



//#Preview {
//    SlideUpView()
//        .environmentObject(dailyIntakeManager())
//}
