//
//  CategoryViewController.swift
//  Unscramble Jumble!
//
//  Created by Alexander Hall on 3/26/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    // premium category buttons
    @IBOutlet var artButton: UIButton!
    @IBOutlet var scienceButton: UIButton!
    @IBOutlet var sportsButton: UIButton!
    @IBOutlet var technologyButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    var coreDataManager = CoreDataManager()
    
    enum Segues {
        static let adjectivesToGame = "adjectivesToGame"
        static let animalsToGame = "animalsToGame"
        static let commonWordsToGame = "commonWordsToGame"
        static let countriesToGame = "countriesToGame"
        static let natureToGame = "natureToGame"
        static let spaceToGame = "spaceToGame"
        //premium category segues
        static let artToGame = "artToGame"
        static let scienceToGame = "scienceToGame"
        static let sportsToGame = "sportsToGame"
        static let technologyToGame = "technologyToGame"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preparePremiumCategoryButtons()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.animateIn()
    }

    // segue to GameViewController and remove CategoryViewController right after
    @IBAction func adjectivesToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.adjectivesToGame)
    }
    @IBAction func animalsToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.animalsToGame)
    }
    @IBAction func commonWordsToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.commonWordsToGame)
    }
    @IBAction func countriesToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.countriesToGame)
    }
    @IBAction func natureToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.natureToGame)
    }
    @IBAction func spaceToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.spaceToGame)
    }
    // premium category button segue actions
    @IBAction func artToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.artToGame)
    }
    @IBAction func scienceToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.scienceToGame)
    }
    @IBAction func sportsToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.sportsToGame)
    }
    @IBAction func technologyToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.technologyToGame)
    }
    
    
    private func animateIn() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { _ in
            self.scrollView.flashScrollIndicators()
        });
    }
    
    @IBAction func backOut(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{ (doneAnimating : Bool) in
            if (doneAnimating)
            {
                self.removeFromParent()
            }
        });
    }
    
    private func preparePremiumCategoryButtons() {
        if coreDataManager.fetchIAPData().hasPurchased {
            changeCategoryButtonToPurchasedMode(for: artButton, named: "Art")
            changeCategoryButtonToPurchasedMode(for: scienceButton, named: "Science")
            changeCategoryButtonToPurchasedMode(for: sportsButton, named: "Sports")
            changeCategoryButtonToPurchasedMode(for: technologyButton, named: "Technology")
        } else {
            artButton.isUserInteractionEnabled = false
            scienceButton.isUserInteractionEnabled = false
            sportsButton.isUserInteractionEnabled = false
            technologyButton.isUserInteractionEnabled = false
        }
    }
    
    private func changeCategoryButtonToPurchasedMode(for button: UIButton, named name: String) {
        button.isUserInteractionEnabled = true
        button.setBackgroundImage(UIImage(named: name), for: .normal)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let destVC = segue.destination as? GameViewController {
                switch identifier {
                    case Segues.adjectivesToGame:
                        destVC.imageName = FileNames.BGImageFileNames.adjectives
                        destVC.themeFileName = FileNames.WordFileNames.adjectives
                    case Segues.animalsToGame:
                        destVC.imageName = FileNames.BGImageFileNames.animals
                        destVC.themeFileName = FileNames.WordFileNames.animals
                        destVC.hintsAndScoreLabelColor = UIColor.white
                    case Segues.commonWordsToGame:
                        destVC.imageName = FileNames.BGImageFileNames.commonWords
                        destVC.themeFileName = FileNames.WordFileNames.commonWords
                    case Segues.countriesToGame:
                        destVC.imageName = FileNames.BGImageFileNames.countries
                        destVC.themeFileName = FileNames.WordFileNames.countries
                    case Segues.natureToGame:
                        destVC.imageName = FileNames.BGImageFileNames.nature
                        destVC.themeFileName = FileNames.WordFileNames.nature
                    case Segues.spaceToGame:
                        destVC.imageName = FileNames.BGImageFileNames.space
                        destVC.themeFileName = FileNames.WordFileNames.space
                        destVC.hintsAndScoreLabelColor = UIColor.white
                    // premium categories segue setup
                    case Segues.artToGame:
                        destVC.imageName = FileNames.BGImageFileNames.art
                        destVC.themeFileName = FileNames.WordFileNames.art
                        destVC.hintsAndScoreLabelColor = UIColor.white
                    case Segues.scienceToGame:
                        destVC.imageName = FileNames.BGImageFileNames.science
                        destVC.themeFileName = FileNames.WordFileNames.science
                        destVC.hintsAndScoreLabelColor = UIColor.white
                    case Segues.sportsToGame:
                        destVC.imageName = FileNames.BGImageFileNames.sports
                        destVC.themeFileName = FileNames.WordFileNames.sports
                        destVC.hintsAndScoreLabelColor = UIColor.white
                    case Segues.technologyToGame:
                        destVC.imageName = FileNames.BGImageFileNames.technology
                        destVC.themeFileName = FileNames.WordFileNames.technology
                        destVC.hintsAndScoreLabelColor = UIColor.white
                    default: break
                }
            }
        }
    }
    
    private func segueAndRemoveSelf(segueName: String) {
        self.performSegue(withIdentifier: segueName, sender: self)
        self.view.removeFromSuperview()
        self.removeFromParent()
        self.willMove(toParent: nil)
    }
}
