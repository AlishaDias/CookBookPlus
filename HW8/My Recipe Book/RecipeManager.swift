//
//  MyRecipe.swift
//  HW8
//
//  Created by CDMStudent on 3/11/24.
//

import Foundation

class RecipeManager {
    static let shared = RecipeManager()
    
    private var recipes: [MyRecipe] = []
    
    private init() {}
    
    func addRecipe(_ recipe: MyRecipe) {
        recipes.append(recipe)
    }
    
    func getAllRecipes() -> [MyRecipe] {
        return recipes
    }
}

