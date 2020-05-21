//
//  CategoryViewController.swift
//  Unscramble It!
//
//  Created by Alexander Hall on 3/26/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    enum Segues: String {
        case adjectivesToGame
        case commonWordsToGame
        case countriesToGame
        case natureToGame
        case spaceToGame
    }
    
    enum BackgroundImageNames: String {
        // TODO: Add more later
        case AdjectivesBG
        case CommonWordsBG
        case CountriesBG
        case NatureBG
        case SpaceBG
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.animateIn()
    }

    // segue to GameViewController and remove CategoryViewController right after
    @IBAction func adjectivesToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.adjectivesToGame.rawValue)
    }
    @IBAction func commonWordsToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.commonWordsToGame.rawValue)
    }
    @IBAction func countriesToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.countriesToGame.rawValue)
    }
    @IBAction func natureToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.natureToGame.rawValue)
    }
    @IBAction func spaceToGame(_ sender: UIButton) {
        segueAndRemoveSelf(segueName: Segues.spaceToGame.rawValue)
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                case Segues.adjectivesToGame.rawValue:
                    if let destVC = segue.destination as? GameViewController {
                        destVC.imageName = BackgroundImageNames.AdjectivesBG.rawValue
                        destVC.gameTheme = "Adjectives"
                    }
                case Segues.commonWordsToGame.rawValue:
                    if let destVC = segue.destination as? GameViewController {
                        destVC.imageName = BackgroundImageNames.CommonWordsBG.rawValue
                        destVC.gameTheme = "Common Words"
                    }
                case Segues.countriesToGame.rawValue:
                    if let destVC = segue.destination as? GameViewController {
                        destVC.imageName = BackgroundImageNames.CountriesBG.rawValue
                        destVC.gameTheme = "Countries"
                    }
                case Segues.natureToGame.rawValue:
                    if let destVC = segue.destination as? GameViewController {
                        destVC.imageName = BackgroundImageNames.NatureBG.rawValue
                        destVC.gameTheme = "Nature"
                    }
                case Segues.spaceToGame.rawValue:
                    if let destVC = segue.destination as? GameViewController {
                        destVC.imageName = BackgroundImageNames.SpaceBG.rawValue
                        destVC.gameTheme = "Space"
                    }
                default: break
            }
        }
    }
    
}

extension CategoryViewController {
    func segueAndRemoveSelf(segueName: String) {
        self.performSegue(withIdentifier: segueName, sender: self)
        self.view.removeFromSuperview()
        self.removeFromParent()
        self.willMove(toParent: nil)
    }
}
