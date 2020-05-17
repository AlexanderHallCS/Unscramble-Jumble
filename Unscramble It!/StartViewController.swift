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
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up banner ad
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.delegate = self
        loadBannerAd()
        /*let adjectivesFilePath = Bundle.main.path(forResource: "Adjectives", ofType: "txt")
        let adjectivesContents = try! String(contentsOfFile: adjectivesFilePath!, encoding: String.Encoding.utf8)
        print(adjectivesContents) */
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    deinit {
        print("did deinit!")
    }
    
    /*override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bannerView.removeFromSuperview()
        print("called!")
    } */
    
    // programmatic implementation of banner view so that its width scales with the size of the ad
    func loadBannerAd() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
           [NSLayoutConstraint(item: bannerView!,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: view.safeAreaLayoutGuide,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: bannerView!,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0)
           ])
        let frame = { () -> CGRect in return view.frame}()
        let viewWidth = frame.size.width
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.load(GADRequest())
    }
    
    // causes the category VC to pop up
    @IBAction func goToCategoryVC(_ sender: UIButton) {
        let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryPopUpID") as! CategoryViewController
        self.addChild(categoryVC)
        categoryVC.view.frame = self.view.frame
        self.view.addSubview(categoryVC.view)
        categoryVC.didMove(toParent: self)
    }
    
    @IBAction func unwindToStart(segue: UIStoryboardSegue) {
        //self.dismiss(animated: true, completion: nil)
        print("unwinded!")
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Ad was received!")
    }
    
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
    
}
