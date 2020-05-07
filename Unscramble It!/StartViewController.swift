//
//  ViewController.swift
//  Unscramble It!
//
//  Created by Alexander Hall on 3/19/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit
import GoogleMobileAds

class StartViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet var bannerView: GADBannerView!
    
    //animating letters
    @IBOutlet var ALabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up banner ad
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        let adjectivesFilePath = Bundle.main.path(forResource: "Adjectives", ofType: "txt")
        let adjectivesContents = try! String(contentsOfFile: adjectivesFilePath!, encoding: String.Encoding.utf8)
        print(adjectivesContents)
        
        animateLetters()
        
        //maybe make this a gradient or more custom later
        view.backgroundColor = .systemOrange
    }
    
    
    // MARK: Add more labels to rotate(maybe some Z, Y, C, F, etc.)
    func animateLetters() {
        ALabel.rotate()
        //Make more letters rotate here
    }
    
    @IBAction func goToCategoryVC(_ sender: UIButton) {
        let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryPopUpID") as! CategoryViewController
        self.addChild(categoryVC)
        categoryVC.view.frame = self.view.frame
        self.view.addSubview(categoryVC.view)
        categoryVC.didMove(toParent: self)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Ad was received!")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }

}

extension UIView {
    func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi*2
        rotation.duration = 5
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
