//
//  LikedRecipeViewController.swift
//  HW8
//
//  Created by CDMStudent on 3/15/24.
//

import UIKit

class LikedRecipeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var MyRecipeLabel: UILabel!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    var likedRecipes: [SpoonacularRecipe] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        MyRecipeLabel.font = UIFont.boldSystemFont(ofSize: 27)
        tableView.dataSource = self
        updateEmptyStateVisibility()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likedRecipes = LikedRecipeManager.shared.likedRecipes
        tableView.reloadData()
        updateEmptyStateVisibility()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
        }
    private func updateEmptyStateVisibility() {
            if likedRecipes.isEmpty {
                emptyStateLabel.isHidden = false
                tableView.isHidden = true
                emptyStateLabel.text = "No Recipes here!"
            } else {
                emptyStateLabel.isHidden = true
                tableView.isHidden = false
            }
        }
    
}

extension LikedRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedRecipeCell", for: indexPath) as! RecipeTableViewCell
        let recipe = likedRecipes[indexPath.row]
        cell.recipe = recipe // Set the recipe for the cell
        cell.titleLabel.text = recipe.title

        // Load image asynchronously
        if let imageUrl = URL(string: recipe.image) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        cell.recipeImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        return cell
    }

}

extension LikedRecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedRecipe = likedRecipes.remove(at: indexPath.row)
            LikedRecipeManager.shared.unlikeRecipe(deletedRecipe)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

