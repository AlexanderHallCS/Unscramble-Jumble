//
//  GameViewController.swift
//  Unscramble It!
//
//  Created by Alexander Hall on 5/16/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit
import NotificationCenter

class GameViewController: UIViewController {
    
    @IBOutlet var backgroundImage: UIImageView!
    
    var game: Game?
    
    var themeFileName: String = ""
    var imageName: String = ""
    
    var blankSpaces = [UIImageView]()
    var letters = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: imageName)
        //backgroundImage.layer.zPosition = -1
        //maybe change the event of willResignActiveNotification to something more forgiving
        NotificationCenter.default.addObserver(self, selector: #selector(pauseGame), name: UIApplication.willResignActiveNotification, object: nil)
        
        game = Game(themeFile: themeFileName)
        
        addBlankSpaces()
        addLetters()
    }
    
    deinit {
        print("did deinit3!")
    }

    // MARK: Present a pause child view controller when app goes in background and pause everything(timers, etc.)
    @objc func pauseGame() {
        print("pause game!")
    }
    
    @IBAction func goToPauseVC(_ sender: UIButton) {
        let pauseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PausePopUpID") as! PauseViewController
        self.addChild(pauseVC)
        pauseVC.view.frame = self.view.frame
        self.view.addSubview(pauseVC.view)
        pauseVC.didMove(toParent: self)
        
        pauseGame()
    }
    
    private func gameOver() {
        
    }
    
    private func addBlankSpaces() {
        for _ in 0..<game!.unscrambledWord.count {
            blankSpaces.append(UIImageView(image: UIImage(named: "Blank Space")!))
        }
        
    }
    
    private func addLetters() {
        for letter in game!.scrambledWord.indices {
            if game!.scrambledWord[letter] != " " {
                letters.append(UIImageView(image: UIImage(named: String(game!.scrambledWord[letter].uppercased()))!))
            }
        }
        
        let centerXOfFrame = self.view.frame.width/2 - self.view.frame.width/8/2
        let widthOfLetterPlusSpacing = self.view.frame.width/8 + self.view.frame.width/32
        var xShift: CGFloat = centerXOfFrame - (widthOfLetterPlusSpacing) * 3
        var yShift: CGFloat = 0.0
        var firstLetterInRowIndex = 0
        // for loop to define how many rows of letters there are
        for row in stride(from: 0.0, to: ceil(Double(letters.count)/6.0), by: 1.0) {
            // check if on last row and last row doesn't have 6 letters
            if(row ==  ceil(Double(letters.count)/6.0) - 1 && letters.count%6 != 0) {
                let unevenLetterOffset = widthOfLetterPlusSpacing*CGFloat(6-letters.count%6)
                xShift = (centerXOfFrame - widthOfLetterPlusSpacing * 3) + unevenLetterOffset
                // ex: 6->7 to format 1 letter; 12->14 to format 2 letters
                for letterIndex in (letters.count-letters.count%6)..<letters.count {
                    print("FRACTURED ROW ENTER: \(letterIndex)")
                    letters[letterIndex].frame = CGRect(x: xShift, y: self.view.frame.height/6*5 + yShift, width: self.view.frame.width/8, height: self.view.frame.width/8)
                    self.view.addSubview(letters[letterIndex])
                    xShift += widthOfLetterPlusSpacing
                }
            } else {
                // for all rows that aren't the last row unless the last row also has 6 letters
                for letterIndex in firstLetterInRowIndex..<firstLetterInRowIndex+6 {
                    print("6 ROW ENTER: \(letterIndex)")
                    letters[letterIndex].frame = CGRect(x: xShift, y: self.view.frame.height/6*5 + yShift, width: self.view.frame.width/8, height: self.view.frame.width/8)
                    self.view.addSubview(letters[letterIndex])
                    xShift += widthOfLetterPlusSpacing
                }
                xShift = centerXOfFrame - (widthOfLetterPlusSpacing) * 3
                firstLetterInRowIndex += 6
            }
            
            print("weeee!")
            yShift += self.view.frame.width/8 + self.view.frame.width/32
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
