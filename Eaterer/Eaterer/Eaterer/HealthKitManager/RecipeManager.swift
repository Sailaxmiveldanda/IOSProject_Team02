//
//  RecipeManager.swift
//  Eaterer
//
//  Created by Macbook-Pro on 10/11/23.
//

import Foundation

struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    let missedIngredients: [Ingredient]
    let usedIngredients: [Ingredient]
    let unusedIngredients: [Ingredient]
    let likes: Int
}

struct Ingredient: Codable {
    let id: Int
    let amount: Double
    let unit: String
    let unitLong: String
    let unitShort: String
    let aisle: String
    let name: String
    let original: String
    let originalName: String
    let meta: [String]
    let extendedName: String?
    let image: String
}
