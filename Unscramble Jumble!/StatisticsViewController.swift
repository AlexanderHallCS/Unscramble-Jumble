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

    private func setLabelTexts() {
        // set text for "Totals" labels
        addUnderlineAndTextToLabel(totalString: "Total Games Played:  \(coreDataManager.fetchTotalStatsData().totalGamesPlayed)", underLinedString: "Total Games Played:", label: totalGamesPlayedLabel)
        addUnderlineAndTextToLabel(totalString: "Total Score:  \(coreDataManager.fetchTotalStatsData().totalScore)", underLinedString: "Total Score:", label: totalScoreLabel)
        addUnderlineAndTextToLabel(totalString: "Total Words Solved:  \(coreDataManager.fetchTotalStatsData().totalWordsSolved)", underLinedString: "Total Words Solved:", label: totalWordsSolvedLabel)
        
        //set text for "Best Game" labels
        addUnderlineAndTextToLabel(totalString: "Category:  \(coreDataManager.fetchBestGameData().bestCategory)", underLinedString: "Category:", label: bestCategoryLabel)
        addUnderlineAndTextToLabel(totalString: "Words Solved:  \(coreDataManager.fetchBestGameData().bestWordsSolved)", underLinedString: "Words Solved:", label: bestWordsSolvedLabel)
        addUnderlineAndTextToLabel(totalString: "Score:  \(coreDataManager.fetchBestGameData().bestScore)", underLinedString: "Score:", label: bestScoreLabel)
        addUnderlineAndTextToLabel(totalString: "Hints Used:  \(coreDataManager.fetchBestGameData().bestHintsUsed)", underLinedString: "Hints Used:", label: bestHintsUsedLabel)
    }
    
    // adds text to the label passed and underlines a part of it up to the end of "underLinedString"
    private func addUnderlineAndTextToLabel(totalString: String, underLinedString: String, label: UILabel) {
        let attributedText = NSMutableAttributedString.init(string: totalString)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 0, length: underLinedString.count))
        label.attributedText = attributedText
    }

}
