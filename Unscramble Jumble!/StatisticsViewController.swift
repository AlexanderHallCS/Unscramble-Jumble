//
//  StatisticsViewController.swift
//  Unscramble Jumble!
//
//  Created by Alexander Hall on 6/28/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet var totalGamesPlayedLabel: UILabel!
    @IBOutlet var totalScoreLabel: UILabel!
    @IBOutlet var totalWordsSolvedLabel: UILabel!
    
    @IBOutlet var bestCategoryLabel: UILabel!
    @IBOutlet var bestWordsSolvedLabel: UILabel!
    @IBOutlet var bestScoreLabel: UILabel!
    @IBOutlet var bestHintsUsedLabel: UILabel!
    
    let coreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLabelTexts()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.animateIn()
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

    func setLabelTexts() {
        totalGamesPlayedLabel.text = "Total Games Played: \(coreDataManager.fetchTotalStatsData().totalGamesPlayed)"
        totalScoreLabel.text = "Total Score: \(coreDataManager.fetchTotalStatsData().totalScore)"
        totalWordsSolvedLabel.text = "Total Words Solved: \(coreDataManager.fetchTotalStatsData().totalWordsSolved)"
        
        bestCategoryLabel.text = "Category: \(coreDataManager.fetchBestGameData().bestCategory)"
        bestWordsSolvedLabel.text = "Words Solved: \(coreDataManager.fetchBestGameData().bestWordsSolved)"
        bestScoreLabel.text = "Score: \(coreDataManager.fetchBestGameData().bestScore)"
        bestHintsUsedLabel.text = "Hints Used: \(coreDataManager.fetchBestGameData().bestHintsUsed)"
    }

}
