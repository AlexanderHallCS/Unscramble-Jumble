//
//  ViewController.swift
//  Unscramble It!
//
//  Created by Alexander Hall on 3/19/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit
import GoogleMobileAds
import NotificationCenter

class StartViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet var bannerView: GADBannerView!
    
    //animating letters
    @IBOutlet var ALabel: UILabel!
    
    var didBeginRotating: Bool = false
    
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
        
        // observers used to allow spinning animation to resume when app goes in background
        NotificationCenter.default.addObserver(self, selector: #selector(resigningActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        //MARK: maybe make this a gradient or more custom later <-----
        view.backgroundColor = .systemOrange
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("did deinit!")
    }
    
    //MARK: Try to get the rotating animation to start from the last angle it left off at <-----------
    /*See listing 5-4 in developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/AdvancedAnimationTricks/AdvancedAnimationTricks.html for more information. */
    @objc func resigningActive() {
        didBeginRotating = true
        /*let pausedTime: CFTimeInterval = ALabel.layer.convertTime(CACurrentMediaTime(), to: nil)
        ALabel.layer.speed = 0.0
        ALabel.layer.timeOffset = pausedTime */
    }
    
    @objc func becomeActive() {
        if didBeginRotating {
           /* let pausedTime: CFTimeInterval = ALabel.layer.timeOffset
            print(pausedTime)
            ALabel.layer.speed = 1.0
            ALabel.layer.timeOffset = 0.0
            ALabel.layer.beginTime = 0.0
            let timeSincePause: CFTimeInterval = ALabel.layer.convertTime(CACurrentMediaTime(), to: nil) - pausedTime
            ALabel.layer.beginTime = timeSincePause */
            animateLetters()
        }
    }
    
    // MARK: Add more labels to rotate(maybe some Z, Y, C, F, etc.) <-----
    func animateLetters() {
        //create for loop through an array of all the letters and do "letter.rotate"
        ALabel.rotate()
        //Make more letters rotate here with for loop
    }
    
    // causes the category VC to pop up
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
