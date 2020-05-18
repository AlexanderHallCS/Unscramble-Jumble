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
        
       // categoryLabel.backgroundColor = UIColor(patternImage: UIImage(named: "Categories")!)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.animateIn()
        
       // self.navigationController?.setNavigationBarHidden(true, animated: false)
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                case Segues.adjectivesToGame:
                    if let destVC = segue.destination as? GameViewController {
                        // pass data that makes it an adjectives VC
                    }
                case Segues.commonWordsToGame:
                    if let destVC = segue.destination as? GameViewController {
                        // pass data that makes it a common words VC
                    }
                case Segues.countriesToGame:
                    if let destVC = segue.destination as? GameViewController {
                        // pass data that makes it a countries VC
                    }
                case Segues.natureToGame:
                    if let destVC = segue.destination as? GameViewController {
                        // pass data that makes it a nature VC
                    }
                case Segues.spaceToGame:
                    if let destVC = segue.destination as? GameViewController {
                        // pass data that makes it a space VC
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
