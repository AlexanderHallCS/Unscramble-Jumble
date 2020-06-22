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
        wordsSolvedLabel.text = "Words Solved: \(worldsSolved) words"
        scoreLabel.text = "Score: \(score)"
        hintsUsedLabel.text = "Hints Used: \(totalHints)"
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destVC = segue.destination as? GameViewController {
            destVC.totalWordsSolvedThisGame = 0
            destVC.totalScoreThisGame = 0
            destVC.totalHintsUsedThisGame = 0
            destVC.createNewWord()
        }
        
    }


}
