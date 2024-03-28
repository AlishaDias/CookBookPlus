import UIKit

struct SpoonacularRecipe: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
}

struct RecipeResponse: Codable {
    let results: [SpoonacularRecipe]
}

class HomepageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var recipes = [SpoonacularRecipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self // Set table view data source
        searchBar.delegate = self
        fetchRecipes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRecipe = recipes[indexPath.row]
                let detailVC = segue.destination as! DetailViewController
                detailVC.recipeId = selectedRecipe.id
            }
        } 
        else if segue.identifier == "ShowLikedRecipesSegue" {
                let likedRecipeVC = segue.destination as! LikedRecipeViewController
                likedRecipeVC.likedRecipes = LikedRecipeManager.shared.likedRecipes
            }
    }

    func fetchRecipes(withQuery query: String? = nil) {
            var urlString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=d84ddf3c6d3a4ceeb371c71792307cfa&cuisine=Indian&number=20"
            
            if let query = query, !query.isEmpty {
                urlString += "&query=\(query)"
            }

            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }

            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching recipes: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(RecipeResponse.self, from: data)
                    self.recipes = response.results
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding recipes: \(error.localizedDescription)")
                }

            }.resume()
        }
    }

extension HomepageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecipeTableViewCell else {
            fatalError("Unable to dequeue RecipeTableViewCell")
        }

        let recipe = recipes[indexPath.row]

        cell.titleLabel.text = recipe.title
        cell.recipe = recipe

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

extension HomepageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

extension HomepageViewController {
    func likeRecipe(at index: Int) {
        let likedRecipe = recipes[index]
        LikedRecipeManager.shared.likeRecipe(likedRecipe)
    }
}

extension HomepageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        fetchRecipes(withQuery: query)
    }
}
