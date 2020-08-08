//
//  ShopViewController.swift
//  Unscramble Jumble!
//
//  Created by Alexander Hall on 8/4/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {

    
    @IBOutlet var defaultLetter: UIImageView!
    @IBOutlet var woodenLetter: UIImageView!
    @IBOutlet var metalLetter: UIImageView!
    
    @IBOutlet var purchaseAllLabel: UILabel!
    
    var coreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //coreDataManager.addAndSaveIAPData(currentLetterSkin: coreDataManager.fetchIAPData().currentLetterSkin,hasPurchased: true)
        colorAndPrepareLetters()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.animateIn()
    }
    
    // makes it so that the grayed out wooden and metal image views are not gray if the user purchased the bundle, enables user interaction, and adds yellow border to chosen letter
    private func colorAndPrepareLetters() {
        //print("VALUE: \(coreDataManager.fetchIAPData().hasPurchased)")
        if coreDataManager.fetchIAPData().hasPurchased == true {
            //print("ANY TRUERS?")
            woodenLetter.image = UIImage(named: "A Wooden")
            metalLetter.image = UIImage(named: "A Metal")
            defaultLetter.isUserInteractionEnabled = true
            woodenLetter.isUserInteractionEnabled = true
            metalLetter.isUserInteractionEnabled = true
        }
        switch getLetterImageViewFromCurrentSkin() {
            case defaultLetter:
                defaultLetter.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                defaultLetter.layer.borderWidth = defaultLetter.frame.height/17
            case woodenLetter:
                woodenLetter.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                woodenLetter.layer.borderWidth = woodenLetter.frame.height/17
            case metalLetter:
                metalLetter.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                metalLetter.layer.borderWidth = metalLetter.frame.height/17
            default:
                break
        }
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
    
    private func animateIn() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }

    private func getLetterImageViewFromCurrentSkin() -> UIImageView {
        
        var letterImageView = UIImageView()
        
        switch coreDataManager.fetchIAPData().currentLetterSkin {
        case 0:
            letterImageView = defaultLetter
        case 1:
            letterImageView = woodenLetter
        case 2:
            letterImageView = metalLetter
        default:
            break
        }
        
        return letterImageView
    }
    
    @IBAction func promptPurchase(_ sender: UIButton) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            //print("Touch Check Value: \(coreDataManager.fetchIAPData().hasPurchased)")
            if coreDataManager.fetchIAPData().hasPurchased == true {
                switch firstTouch.view {
                case defaultLetter:
                    defaultLetter.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                    defaultLetter.layer.borderWidth = defaultLetter.frame.width/17
                    getLetterImageViewFromCurrentSkin().layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    coreDataManager.addAndSaveIAPData(currentLetterSkin: 0, hasPurchased: true)
                    //print("Touch Check Value Default Letter: \(coreDataManager.fetchIAPData().hasPurchased)")
                case woodenLetter:
                    woodenLetter.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                    woodenLetter.layer.borderWidth = woodenLetter.frame.width/17
                    getLetterImageViewFromCurrentSkin().layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    coreDataManager.addAndSaveIAPData(currentLetterSkin: 1, hasPurchased: true)
                    //print("Touch Check Value Wooden: \(coreDataManager.fetchIAPData().hasPurchased)")
                case metalLetter:
                    metalLetter.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                    metalLetter.layer.borderWidth = metalLetter.frame.width/17
                    getLetterImageViewFromCurrentSkin().layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    coreDataManager.addAndSaveIAPData(currentLetterSkin: 2, hasPurchased: true)
                    //print("Touch Check Value Metal: \(coreDataManager.fetchIAPData().hasPurchased)")
                default:
                    break
                }
            }
        }
    }
    
}
