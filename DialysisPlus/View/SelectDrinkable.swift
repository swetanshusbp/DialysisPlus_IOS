//
//  SelectDrinkable.swift
//  DialysisPlus
//
//  Created by Abilasha  on 29/02/24.
//

import SwiftUI

struct SelectDrinkView: View {
    @Binding var selectedDrinkIndex: Int?
    @Binding var isPresented: Bool

    private func dismiss() {
        // Set the binding variable to false to close the pop-up
        isPresented = false
    }

    var body: some View {
        VStack {
                Text("Select Drinkable")
                    .font(.title)
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                ForEach(0..<drinkable.count, id: \.self) { index in
                    Button(action: {
                        selectedDrinkIndex = index
                    }) {
                        VStack {
                            Circle()
                                .fill(selectedDrinkIndex == index ? Color(hex: "A2D6F9") : Color.clear)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(drinkable[index].image)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                )
                                .onTapGesture {
                                    selectedDrinkIndex = index
                                    isPresented = false
                                }

                            Text(drinkable[index].name)
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        }
        .padding()
    }
}
