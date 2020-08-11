//
//  SettingsViewController.swift
//  Unscramble Jumble!
//
//  Created by Alexander Hall on 8/10/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit

var isSoundOn = true

class SettingsViewController: UIViewController {

    @IBOutlet var soundLabel: UILabel!
    @IBOutlet var soundButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        soundLabel.textColor = UIColor.black
        setSwitchToCorrectValue()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.animateIn()
    }
    
    // fixes how the switch automatically gets set to on when opening settings VC
    private func setSwitchToCorrectValue() {
        if isSoundOn == false {
            soundButton.setBackgroundImage(UIImage(named: "StopSoundButton"), for: .normal)
        }
    }
    
    @IBAction func toggleSound(_ sender: UISwitch) {
        if isSoundOn {
            isSoundOn = false
            soundButton.setBackgroundImage(UIImage(named: "StopSoundButton"), for: .normal)
        } else {
            isSoundOn = true
            soundButton.setBackgroundImage(UIImage(named: "BaseSoundButton"), for: .normal)
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
        })
    }
    
    @IBAction func restorePurchase(_ sender: UIButton) {
        
    }

}
