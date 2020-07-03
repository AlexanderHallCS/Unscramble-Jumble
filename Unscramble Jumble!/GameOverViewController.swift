//
//  GameOverViewController.swift
//  Unscramble Jumble!
//
//  Created by Alexander Hall on 6/19/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet var wordsSolvedLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var hintsUsedLabel: UILabel!
    
    var worldsSolved = 0
    var score = 0
    var totalHints = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLabelTexts()
    }
    
    private func setLabelTexts() {
        addUnderlineAndTextToLabel(totalString: "Words Solved: \(worldsSolved)", underLinedString: "Words Solved:", label: wordsSolvedLabel)
        addUnderlineAndTextToLabel(totalString: "Score: \(score)", underLinedString: "Score:", label: scoreLabel)
        addUnderlineAndTextToLabel(totalString: "Hints Used: \(totalHints)", underLinedString: "Hints Used:", label: hintsUsedLabel)
    }
    
    // adds text to the label passed and underlines a part of it up to the end of "underLinedString"
    private func addUnderlineAndTextToLabel(totalString: String, underLinedString: String, label: UILabel) {
        let attributedText = NSMutableAttributedString.init(string: totalString)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 0, length: underLinedString.count))
        label.attributedText = attributedText
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? GameViewController {
            destVC.totalWordsSolvedThisGame = 0
            destVC.totalScoreThisGame = 0
            destVC.totalHintsUsedThisGame = 0
            destVC.seconds = 30.0
            destVC.createNewWord()
        }
        
    }


}
