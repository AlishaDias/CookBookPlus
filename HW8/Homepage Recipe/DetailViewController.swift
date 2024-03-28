//
//  DetailViewController.swift
//  HW8
//
//  Created by CDMStudent on 3/13/24.
//

import UIKit

struct RecipeDetail: Codable {
    let id: Int
    let title: String
    let image: String
    let servings: Int
    let readyInMinutes: Int
    let dishTypes: [String]
    let analyzedInstructions: [AnalyzedInstruction]
}

struct AnalyzedInstruction: Codable {
    let steps: [Step]
}

struct Step: Codable {
    let number: Int
    let step: String
}

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var readyInMinutesLabel: UILabel!
    @IBOutlet weak var recipeStepsTextView: UITextView!
    
    var recipeId: Int!
    var recipeDetail: RecipeDetail?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 4.0
            
            fetchRecipeDetail()
            navigationItem.rightBarButtonItem?.isEnabled = false
            
            scrollView.delegate = self
                
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapToZoom))
            doubleTapGesture.numberOfTapsRequired = 2
            recipeImageView.addGestureRecognizer(doubleTapGesture)
            
            recipeImageView.isUserInteractionEnabled = true
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return recipeImageView
        }
        
        @objc func doubleTapToZoom(sender: UITapGestureRecognizer) {
            if scrollView.zoomScale == scrollView.minimumZoomScale {
                // Zoom in
                let location = sender.location(in: recipeImageView)
                let rect = CGRect(x: location.x, y: location.y, width: 1, height: 1)
                scrollView.zoom(to: rect, animated: true)
            } else {
                // Zoom out
                scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            }
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let touchLocation = touch.location(in: self.view)
            
            if recipeImageView.frame.contains(touchLocation) {
                print("Touch began on the image")
            }
        }
    
        func fetchRecipeDetail() {
            guard let recipeId = recipeId else {
                print("Recipe ID is nil")
                return
            }
            
            guard let url = URL(string: "https://api.spoonacular.com/recipes/\(recipeId)/information?apiKey=d84ddf3c6d3a4ceeb371c71792307cfa") else {
                print("Invalid URL")
                return
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching recipe details: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let recipeDetail = try decoder.decode(RecipeDetail.self, from: data)
                    
                    // Assign the fetched recipe detail to the property
                    self.recipeDetail = recipeDetail
                    
                    DispatchQueue.main.async {
                        self.updateUI(with: recipeDetail)
                    }
                } catch {
                    print("Error decoding recipe details: \(error.localizedDescription)")
                }
            }.resume()
        }

    
    func updateUI(with recipeDetail: RecipeDetail) {
        titleLabel.text = recipeDetail.title
        servingsLabel.text = "Servings: \(recipeDetail.servings)"
        readyInMinutesLabel.text = "Ready in \(recipeDetail.readyInMinutes) minutes"
        recipeStepsTextView.text = prepareRecipeStepsText(from: recipeDetail.analyzedInstructions)
        
        if let imageUrl = URL(string: recipeDetail.image) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self.recipeImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
    }
    
    func prepareRecipeStepsText(from instructions: [AnalyzedInstruction]) -> String {
        var stepsText = ""
        for instruction in instructions {
            for step in instruction.steps {
                stepsText += "\(step.number). \(step.step)\n"
            }
        }
        return stepsText
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
            guard let recipeDetail = recipeDetail else {
                print("Recipe detail is nil")
                return
            }
            
            let recipeDetails = """
            Name: \(recipeDetail.title)
            Servings: \(recipeDetail.servings)
            Ready in \(recipeDetail.readyInMinutes) minutes
            
            Instructions:
            \(recipeDetail.analyzedInstructions)
            """
            
            let activityItems: [Any] = [recipeDetails]
         
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [
                .airDrop,
                .assignToContact,
                .addToReadingList
            ]
            
            present(activityViewController, animated: true, completion: nil)
        }
}
