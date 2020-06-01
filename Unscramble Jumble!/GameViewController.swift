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
        var yShift: CGFloat = 0.0
        for letter in game!.unscrambledWord.indices {
            if game!.unscrambledWord[letter] != " " {
                blankSpaces.append(UIImageView(image: UIImage(named: "Blank Space")!))
            }
        }
        
        // start of formatting blank spaces for words/word phrases where all words are <= 6 characters long
        var wordsLessThanLengthSix = 0
        for word in game!.unscrambledWord.split(separator: " "){
            print("Word Length: \(word.count), Word: \(word)")
            if word.count <= 6 {
                wordsLessThanLengthSix += 1
            }
        }
        print("words less than length six: \(wordsLessThanLengthSix)")
        print("Words: \(game!.unscrambledWord.split(separator: " ").count)")
        if wordsLessThanLengthSix == game!.unscrambledWord.split(separator: " ").count {
            let centerXOfFrame = self.view.frame.width/2 - self.view.frame.width/8/2
            let widthOfLetterPlusSpacing = self.view.frame.width/8 + self.view.frame.width/32
            var unevenLetterOffset: CGFloat = 0.0
            var xShift: CGFloat = 0.0
            var firstLetterInRowIndex = 0
            // ex: 6->7 to format 1 blank space; 12->14 to format 2 letters
            for word in game!.unscrambledWord.split(separator: " ") {
                // unevenLetterOffset and xShift are redefined here to account for words with spaces
                // (it would recalculate spacing based on the current word)
                unevenLetterOffset = widthOfLetterPlusSpacing * CGFloat(word.count%6 - 1)/2
                // reset xShift value
                xShift = centerXOfFrame - unevenLetterOffset
                if word.count == 6 {
                    xShift = centerXOfFrame - (widthOfLetterPlusSpacing) * 2.5
                }
                for blankSpaceIndex in firstLetterInRowIndex..<firstLetterInRowIndex+word.count {
                    print("6 ROW BLANK SPACES ENTER: \(blankSpaceIndex)")
                    blankSpaces[blankSpaceIndex].frame = CGRect(x: xShift, y: self.view.frame.height/16*7 + yShift, width: self.view.frame.width/8, height: self.view.frame.width/8)
                    self.view.addSubview(blankSpaces[blankSpaceIndex])
                    xShift += widthOfLetterPlusSpacing
                }
                yShift += widthOfLetterPlusSpacing
                firstLetterInRowIndex += word.count
            }
        // end of formatting blank spaces for words/word phrases where all words are <= 6 characters long
        } else {
            var longestSubWordLength = 0
            for subWord in game!.unscrambledWord.split(separator: " ") {
                if longestSubWordLength < subWord.count {
                    longestSubWordLength = subWord.count
                }
            }
            let constantSpacing = self.view.frame.width/32
            let widthShrinkingFactor: CGFloat = CGFloat((32*longestSubWordLength)/(30-longestSubWordLength))
            let width = self.view.frame.width/(widthShrinkingFactor)
            let centerXOfFrame = self.view.frame.width/2 - self.view.frame.width/8/2
            var xShift = centerXOfFrame - (self.view.frame.width/8 + self.view.frame.width/32) * 2.5
            var firstLetterInRowIndex = 0
            for word in game!.unscrambledWord.split(separator: " ") {
                for blankSpaceIndex in firstLetterInRowIndex..<firstLetterInRowIndex+word.count {
                    blankSpaces[blankSpaceIndex].frame = CGRect(x: xShift, y: self.view.frame.height/16*7 + yShift, width: width, height: width)
                    self.view.addSubview(blankSpaces[blankSpaceIndex])
                    xShift += width + constantSpacing
                }
                xShift = centerXOfFrame - (self.view.frame.width/8 + self.view.frame.width/32) * 2.5
                yShift += width + constantSpacing
                firstLetterInRowIndex += word.count
            }
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
        // the intial xShift value is the x position of the leftmost letter in a row of six letters
        var xShift: CGFloat = centerXOfFrame - (widthOfLetterPlusSpacing) * 2.5
        var yShift: CGFloat = 0.0
        var firstLetterInRowIndex = 0
        // for loop to define how many rows of letters there are
        for row in stride(from: 0.0, to: ceil(Double(letters.count)/6.0), by: 1.0) {
            // check if this iteration is the last row and last row doesn't have 6 letters
            if(row ==  ceil(Double(letters.count)/6.0) - 1 && letters.count%6 != 0) {
                let unevenLetterOffset = widthOfLetterPlusSpacing * CGFloat(letters.count%6 - 1)/2
                print("UNEVEN LETTER OFFEST: \(unevenLetterOffset)")
                xShift = centerXOfFrame - unevenLetterOffset
                print("X SHIFT VALUE: \(xShift)")
                // ex: 6->7 to format 1 letter; 12->14 to format 2 letters
                for letterIndex in (letters.count-letters.count%6)..<letters.count {
                    print("FRACTURED ROW ENTER: \(letterIndex)")
                    letters[letterIndex].frame = CGRect(x: xShift, y: self.view.frame.height/32*21 + yShift, width: self.view.frame.width/8, height: self.view.frame.width/8)
                    self.view.addSubview(letters[letterIndex])
                    xShift += widthOfLetterPlusSpacing
                }
            } else {
                // this for loop is for all rows that aren't the last row unless the last row also has 6 letters
                for letterIndex in firstLetterInRowIndex..<firstLetterInRowIndex+6 {
                    print("6 ROW ENTER: \(letterIndex)")
                    letters[letterIndex].frame = CGRect(x: xShift, y: self.view.frame.height/32*21 + yShift, width: self.view.frame.width/8, height: self.view.frame.width/8)
                    self.view.addSubview(letters[letterIndex])
                    xShift += widthOfLetterPlusSpacing
                }
                // reset xShift value
                xShift = centerXOfFrame - (widthOfLetterPlusSpacing) * 2.5
                // go to next row
                firstLetterInRowIndex += 6
            }
            
            print("weeee!")
            yShift += widthOfLetterPlusSpacing
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
