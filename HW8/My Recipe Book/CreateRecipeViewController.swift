//
//  CreateRecipeViewController.swift
//  HW8
//
//  Created by CDMStudent on 3/9/24.
//

import UIKit

struct MyRecipe {
    let name: String
    let servingSize: Int
    let cookingTime: Int
    let category: String
    let ingredients: [String]
    let cookingSteps: [String]
}

class CreateRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeTextField: UITextField!
    @IBOutlet weak var servingSizeTextField: UITextField!
    @IBOutlet weak var cookingTimeTextField: UITextField!
    @IBOutlet weak var categorySegmentController: UISegmentedControl!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var cookingStepsTextField: UITextField!

    let categories = ["Breakfast", "Lunch", "Dinner"]
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
        }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = recipeTextField.text,
              let servingSizeText = servingSizeTextField.text,
              let servingSize = Int(servingSizeText),
              let cookingTimeText = cookingTimeTextField.text,
              let cookingTime = Int(cookingTimeText),
              let category = categorySegmentController.titleForSegment(at: categorySegmentController.selectedSegmentIndex),
              let ingredientsText = ingredientsTextField.text,
              let cookingStepsText = cookingStepsTextField.text
        else {
            return
        }

        let ingredients = ingredientsText.components(separatedBy: ",")
        let cookingSteps = cookingStepsText.components(separatedBy: ",")

        let recipe = MyRecipe(name: name, servingSize: servingSize, cookingTime: cookingTime, category: category, ingredients: ingredients, cookingSteps: cookingSteps)

        RecipeManager.shared.addRecipe(recipe)

        dismiss(animated: true) { [self] in
            if let myRecipeViewController = presentingViewController as? MyRecipeViewController {
                myRecipeViewController.recipes = RecipeManager.shared.getAllRecipes()
                myRecipeViewController.tableView.reloadData()
            }
        }
    }
}
