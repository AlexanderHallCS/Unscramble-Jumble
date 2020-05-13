//
//  CategoryViewController.swift
//  Unscramble It!
//
//  Created by Alexander Hall on 3/26/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // categoryLabel.backgroundColor = UIColor(patternImage: UIImage(named: "Categories")!)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.animateIn()
    }
    
    @IBAction func backOut(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(doneAnimating : Bool)  in
            if (doneAnimating)
            {
                self.view.removeFromSuperview()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}