//
//  SettingsViewController.swift
//  Unscramble Jumble!
//
//  Created by Alexander Hall on 8/10/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit
import StoreKit

var isSoundOn = true

class SettingsViewController: UIViewController, SKPaymentTransactionObserver {

    @IBOutlet var soundLabel: UILabel!
    @IBOutlet var soundButton: UIButton!
    
    var coreDataManager = CoreDataManager()
    
    var myProduct: SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        soundLabel.textColor = UIColor.black
        setSwitchToCorrectValue()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.animateIn()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
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
        SKPaymentQueue.default().add(self)
        if coreDataManager.fetchIAPData().hasPurchased == false {
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            showOopsAlert()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .restored:
                coreDataManager.addAndSaveIAPData(currentLetterSkin: 0, hasPurchased: true)
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                let alert = UIAlertController(title: "Success", message: "Purchase has been restored!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) {(action: UIAlertAction) -> Void in
                    alert.removeFromParent()
                })
                self.present(alert, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            myProduct = product
        }
    }

    // shows the user an alert if they haven't made an in-app purchase yet, but they try to restore purchases
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if queue.transactions.count == 0 {
            showOopsAlert()
        }
    }
    
    private func showOopsAlert() {
        let alert = UIAlertController(title: "Oops", message: "There are no purchases to restore.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) {(action: UIAlertAction) -> Void in
            alert.removeFromParent()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
}
