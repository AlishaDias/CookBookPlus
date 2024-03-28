//
//  LikedRecipeManager.swift
//  HW8
//
//  Created by CDMStudent on 3/15/24.
//

import Foundation

class LikedRecipeManager {
    static let shared = LikedRecipeManager()
    private init() {}

    var likedRecipes: [SpoonacularRecipe] = []

    func likeRecipe(_ recipe: SpoonacularRecipe) {
        likedRecipes.append(recipe)
    }

    func unlikeRecipe(_ recipe: SpoonacularRecipe) {
        if let index = likedRecipes.firstIndex(where: { $0.id == recipe.id }) {
            likedRecipes.remove(at: index)
        }
    }
}
