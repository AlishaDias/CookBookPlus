//
//  MyRecipeViewController.swift
//  HW8
//
//  Created by CDMStudent on 3/11/24.
//

import UIKit

class MyRecipeViewController: UIViewController {
    
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var servingSizeLabel: UILabel!
        @IBOutlet weak var cookingTimeLabel: UILabel!
        @IBOutlet weak var categoryLabel: UILabel!
        @IBOutlet weak var ingredientsLabel: UILabel!
        @IBOutlet weak var cookingStepsLabel: UILabel!
        @IBOutlet weak var MyRecipeLabel: UILabel!
        @IBOutlet weak var emptyStateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
        var recipes: [MyRecipe] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            MyRecipeLabel.font = UIFont.boldSystemFont(ofSize: 27)
            recipes = RecipeManager.shared.getAllRecipes()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
            updateEmptyStateVisibility()
        }
    
    private func updateEmptyStateVisibility() {
            if recipes.isEmpty {
                emptyStateLabel.isHidden = false
                tableView.isHidden = true
                emptyStateLabel.text = "No Recipes Here!"
            } else {
                emptyStateLabel.isHidden = true
                tableView.isHidden = false
            }
        }
    
}
extension MyRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        let recipe = recipes[indexPath.row]
        cell.textLabel?.text = recipe.name
        var detailText = "\nCategory: \(recipe.category)\nServings: \(recipe.servingSize)\nCooking Time: \(recipe.cookingTime) min\n\nIngredients:\n"
        detailText += recipe.ingredients.joined(separator: ", ")
        detailText += "\n\nCooking Steps:\n"
        detailText += recipe.cookingSteps.joined(separator: "\n")
           
        cell.detailTextLabel?.text = detailText
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            recipes.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
