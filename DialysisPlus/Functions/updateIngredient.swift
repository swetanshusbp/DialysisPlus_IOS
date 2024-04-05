//
//  updateIngredient.swift
//  DialysisPlus
//
//  Created by Meghs on 21/03/24.
//

import Foundation

func updateIngredient(name: String, quantity: String?, sodium: Double?, potassium: Double?) {
    if let updatedIndex = ingredientsManager.ingredients.firstIndex(where: { $0.name == name }) {
        ingredientsManager.ingredients[updatedIndex].quantity = quantity
        ingredientsManager.ingredients[updatedIndex].sodium = sodium
        ingredientsManager.ingredients[updatedIndex].potassium = potassium
    }
}
