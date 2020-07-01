//
//  CategoryViewController.swift
//  Unscramble It!
//
//  Created by Alexander Hall on 3/26/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    enum Segues {
        static let adjectivesToGame = "adjectivesToGame"
        static let commonWordsToGame = "commonWordsToGame"
        static let countriesToGame = "countriesToGame"
        static let natureToGame = "natureToGame"
        static let spaceToGame = "spaceToGame"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.animateIn()
    }

    // segue to GameViewController and remove CategoryViewController right after
    @IBAction func adjectivesToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.adjectivesToGame)
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
    
    
    deinit {
        print("did deinit2!")
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
    
    func animateIn() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let destVC = segue.destination as? GameViewController {
                switch identifier {
                    case Segues.adjectivesToGame:
                            destVC.imageName = FileNames.BGImageFileNames.adjectives
                            destVC.themeFileName = FileNames.WordFileNames.adjectives
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
