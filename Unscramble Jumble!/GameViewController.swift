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
    
    var letterXAndYPositions = [[CGFloat]]()
    var letterAndIndex: [UIImageView:Int] = [:]
    var hintLetterIndices = [Int]()
    
    var chosenLetterStack = [Letter]()
    
    var nextUnvisitedBlankSpace = 0
    var hintsLeft = 3
    var hintsUsed = 0
    
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
    
    // adds all the blank spaces to the top of the screen and positions/shrinks them accordingly
    private func addBlankSpaces() {
        var yShift: CGFloat = 0.0
        let yRowShift: CGFloat = self.view.frame.width/10 * CGFloat(game!.unscrambledWord.split(separator: " ").count)
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
            //var unevenLetterOffset: CGFloat = 0.0
            var xShift: CGFloat = 0.0
            var firstLetterInRowIndex = 0
            //getting the longest sub word's length so that the width of the blank spaces is based on it
            var longestSubWordLength = 0
            for subWord in game!.unscrambledWord.split(separator: " ") {
                if longestSubWordLength < subWord.count {
                    longestSubWordLength = subWord.count
                }
            }
            let unevenLetterOffset = widthOfLetterPlusSpacing * CGFloat(longestSubWordLength%6 - 1)/2
            // ex: 6->7 to format 1 blank space; 12->14 to format 2 letters
            for word in game!.unscrambledWord.split(separator: " ") {
                // xShift is redefined here to account for words with spaces
                xShift = centerXOfFrame - unevenLetterOffset
                if longestSubWordLength == 6 {
                    xShift = centerXOfFrame - (widthOfLetterPlusSpacing) * 2.5
                }
                for blankSpaceIndex in firstLetterInRowIndex..<firstLetterInRowIndex+word.count {
                    print("6 ROW BLANK SPACES ENTER: \(blankSpaceIndex)")
                    blankSpaces[blankSpaceIndex].frame = CGRect(x: xShift, y: self.view.frame.height/16*7 - yRowShift + yShift, width: self.view.frame.width/8, height: self.view.frame.width/8)
                    //blankSpaceXPositions.append(blankSpaces[blankSpaceIndex].frame.origin.x)
                    //blankSpaceYPositions.append(blankSpaces[blankSpaceIndex].frame.origin.y)
                    //print("xShift: \(xShift), arrayx: \(blankSpaceXPositions[blankSpaceIndex])")
                    //print("yShift: \(self.view.frame.height/16*7 - yRowShift + yShift), arrayy: \(blankSpaceYPositions[blankSpaceIndex])")
                    self.view.addSubview(blankSpaces[blankSpaceIndex])
                    xShift += widthOfLetterPlusSpacing
                }
                yShift += widthOfLetterPlusSpacing
                firstLetterInRowIndex += word.count
            }
        // end of formatting blank spaces for words/word phrases where all words are <= 6 characters long
        } else {
            //getting the longest sub word's length so that the width of the blank spaces is based on it
            var longestSubWordLength = 0
            for subWord in game!.unscrambledWord.split(separator: " ") {
                if longestSubWordLength < subWord.count {
                    longestSubWordLength = subWord.count
                }
            }
            let longWordYPushback = self.view.frame.width/10
            let constantSpacing = self.view.frame.width/32
            let widthShrinkingFactor = CGFloat((32*longestSubWordLength))/CGFloat((30-longestSubWordLength))
            let width = self.view.frame.width/widthShrinkingFactor
            let centerXOfFrame = self.view.frame.width/2 - self.view.frame.width/8/2
            var xShift = centerXOfFrame - (self.view.frame.width/8 + self.view.frame.width/32) * 2.5
            var firstLetterInRowIndex = 0
            for word in game!.unscrambledWord.split(separator: " ") {
                for blankSpaceIndex in firstLetterInRowIndex..<firstLetterInRowIndex+word.count {
                    blankSpaces[blankSpaceIndex].frame = CGRect(x: xShift, y: self.view.frame.height/16*7 - yRowShift  - longWordYPushback + yShift, width: width, height: width)
                    //blankSpaceXPositions.append(blankSpaces[blankSpaceIndex].frame.origin.x)
                    //blankSpaceYPositions.append(blankSpaces[blankSpaceIndex].frame.origin.y)
                    self.view.addSubview(blankSpaces[blankSpaceIndex])
                    xShift += width + constantSpacing
                }
                xShift = centerXOfFrame - (self.view.frame.width/8 + self.view.frame.width/32) * 2.5
                yShift += width + constantSpacing
                firstLetterInRowIndex += word.count
            }
        }
        
    }
    
    // adds all the letters to the bottom of the screen and positions them accordingly
    private func addLetters() {
        for letter in game!.scrambledWord.indices {
            letters.append(UIImageView(image: UIImage(named: String(game!.scrambledWord[letter].uppercased()))!))
        }
        
        // allowing touch events to be registered on the letters
        for letter in letters {
            letter.isUserInteractionEnabled = true
        }
        
        let centerXOfFrame = self.view.frame.width/2 - self.view.frame.width/8/2
        let widthOfLetterPlusSpacing = self.view.frame.width/8 + self.view.frame.width/32
        // the intial xShift value is the x position of the leftmost letter in a row of six letters
        var xShift: CGFloat = centerXOfFrame - (widthOfLetterPlusSpacing) * 2.5
        var yShift: CGFloat = 0.0
        let yRowShift: CGFloat = self.view.frame.width/12 * CGFloat(ceil(Double(game!.scrambledWord.count)/6))
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
                    letters[letterIndex].frame = CGRect(x: xShift, y: self.view.frame.height/32*27 - yRowShift + yShift, width: self.view.frame.width/8, height: self.view.frame.width/8)
                    letterXAndYPositions.append([letters[letterIndex].frame.origin.x,letters[letterIndex].frame.origin.y])
                    letterAndIndex[letters[letterIndex]] = letterIndex
                    self.view.addSubview(letters[letterIndex])
                    xShift += widthOfLetterPlusSpacing
                }
            } else {
                // this for loop is for all rows that aren't the last row unless the last row also has 6 letters
                for letterIndex in firstLetterInRowIndex..<firstLetterInRowIndex+6 {
                    print("6 ROW ENTER: \(letterIndex)")
                    letters[letterIndex].frame = CGRect(x: xShift, y: self.view.frame.height/32*27 - yRowShift + yShift, width: self.view.frame.width/8, height: self.view.frame.width/8)
                    letterXAndYPositions.append([letters[letterIndex].frame.origin.x,letters[letterIndex].frame.origin.y])
                    letterAndIndex[letters[letterIndex]] = letterIndex
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
        if let firstTouch = touches.first {
            
            for letterViewIndex in 0..<letters.count-hintsUsed {
                if firstTouch.view == letters[letterViewIndex] {
                    animateTowardsBlankSpace(letter: letters[letterViewIndex])
                    //print("\(letters[letterViewIndex]) was tapped!")
                }
            }
        }
    }
    
    // moves(and shrinks if necessary) the letter towards the next available blank space
    private func animateTowardsBlankSpace(letter: UIImageView) {
        chosenLetterStack.append(Letter(letterImageView: letter))
        UIView.animate(withDuration: 1.5, animations: {
            print("animated!")
            letter.frame = CGRect(x: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.origin.x, y: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.origin.y, width: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.width, height: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.height)
            letter.rotate()
        },completion: { _ in
            /*------>>>>check if the word is equal to the right word here(call a model function)<<<<--------*/
        })
        // stops the user from being able to tap on the letter while it is animating and once it finishes animating
        letters[letters.firstIndex(of: letter)!].isUserInteractionEnabled = false
        nextUnvisitedBlankSpace += 1
    }
    
    @IBAction func popLastLetterOff(_ sender: UIButton) {
        removeLetter()
    }
    
    @IBAction func removeAllLetters(_ sender: UIButton) {
        for _ in chosenLetterStack {
            removeLetter()
        }
    }
    
    // pops off and removes the animations of the most recent letter added
    private func removeLetter() {
        guard let lastLetterInStack = chosenLetterStack.last?.letterImageView else {
            return
        }
        lastLetterInStack.frame = CGRect(x: letterXAndYPositions[letterAndIndex[lastLetterInStack]!][0], y: letterXAndYPositions[letterAndIndex[lastLetterInStack]!][1], width: self.view.frame.width/8, height: self.view.frame.width/8)
        chosenLetterStack.last!.letterImageView.layer.removeAllAnimations()
        chosenLetterStack.removeLast()
        nextUnvisitedBlankSpace -= 1
        letters[letters.firstIndex(of: lastLetterInStack)!].isUserInteractionEnabled = true
    }
    
    @IBAction func generateHint(_ sender: UIButton) {
        hintsUsed += 1
        hintsLeft -= 1
        if hintsLeft == 0 {
            //hintsButton.isEnabled = false (make an outlet for the hints button)
        }
        
        // removes all the letters on the blank spaces in preparation for putting a hint in
        for _ in chosenLetterStack {
            removeLetter()
        }
        
        var randomLetterIndex = Int.random(in: 0..<letters.count)
        // check if the random letter index has already been chosen before if it has, keep generating random indices until it hasn't, else add it to hintLetterIndices
        if hintLetterIndices.contains(randomLetterIndex) {
            while hintLetterIndices.contains(randomLetterIndex) {
                randomLetterIndex = Int.random(in: 0..<letters.count)
                if !hintLetterIndices.contains(randomLetterIndex) {
                    hintLetterIndices.append(randomLetterIndex)
                    break
                }
            }
        } else {
            hintLetterIndices.append(randomLetterIndex)
        }
        
        UIView.animate(withDuration: 1.5, animations: {
            print("animated hint!")
            self.letters[randomLetterIndex].frame = CGRect(x: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.origin.x, y: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.origin.y, width: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.width, height: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.height)
            self.letters[randomLetterIndex].rotate()
        })
        
    }
    
    //TODO: reset all variables(lists, booleans, etc.) and refresh UI by creating new instance of game and calling addLetters() and addBlankSpaces() --> See what is done in the viewDidLoad() function(compartmentalize by calling this function in viewDidLoad() and moving the code from there to here)
    private func createNewWord() {
        
    }
}

extension UIImageView {
    func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.3
        rotation.isCumulative = true
        // animation duration divided by rotation.duration
        rotation.repeatCount = 5
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
