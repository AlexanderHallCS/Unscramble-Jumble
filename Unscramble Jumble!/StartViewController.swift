//
//  StartViewController.swift
//  Unscramble Jumble!
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
        bannerView.adUnitID = Keys.adUnitID
        bannerView.rootViewController = self
        bannerView.delegate = self
        loadBannerAd()
    }
    
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
    
    @IBAction func goToSettingsVC(_ sender: UIButton) {
        let settingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsPopUpID") as! SettingsViewController
        self.addChild(settingsVC)
        settingsVC.view.frame = self.view.frame
        self.view.addSubview(settingsVC.view)
        settingsVC.didMove(toParent: self)
    }
    
    
    // causes the category VC to pop up
    @IBAction func goToCategoryVC(_ sender: UIButton) {
        let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryPopUpID") as! CategoryViewController
        self.addChild(categoryVC)
        categoryVC.view.frame = self.view.frame
        self.view.addSubview(categoryVC.view)
        categoryVC.didMove(toParent: self)
    }
    
    // causes the statistics VC to pop up
    @IBAction func goToStatisticsVC(_ sender: UIButton) {
        let statisticsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StatisticsPopUpID") as! StatisticsViewController
        self.addChild(statisticsVC)
        statisticsVC.view.frame = self.view.frame
        self.view.addSubview(statisticsVC.view)
        statisticsVC.didMove(toParent: self)
    }
    
    // causes the shop VC to pop up
    @IBAction func goToShopVC(_ sender: UIButton) {
        let shopVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShopPopUpID") as! ShopViewController
        self.addChild(shopVC)
        shopVC.view.frame = self.view.frame
        self.view.addSubview(shopVC.view)
        shopVC.didMove(toParent: self)
    }
    
    @IBAction func unwindToStartFromPauseOrGameOverVC(segue: UIStoryboardSegue) {
        
    }
    
}
