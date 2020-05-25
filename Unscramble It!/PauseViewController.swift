//
//  PauseViewController.swift
//  Unscramble It!
//
//  Created by Alexander Hall on 5/24/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.animateIn()
    }
    
    deinit {
        print("did deinit4!")
    }
    
    @IBAction func backOutToGameVC(_ sender: UIButton) {
        animateOut()
    }
    
    func animateIn() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    
    @IBAction func backOutToStartVC(_ sender: UIButton) {
        animateOut()
    }
    
    private func animateOut() {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
