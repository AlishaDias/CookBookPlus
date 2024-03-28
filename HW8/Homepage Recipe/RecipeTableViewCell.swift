//
//  RecipeTableViewCell.swift
//  HW8
//
//  Created by CDMStudent on 3/12/24.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var recipe: SpoonacularRecipe?
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        guard let recipe = recipe else { return }
        
        if LikedRecipeManager.shared.likedRecipes.contains(where: { $0.id == recipe.id }) {
            LikedRecipeManager.shared.unlikeRecipe(recipe)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            LikedRecipeManager.shared.likeRecipe(recipe)
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
}
