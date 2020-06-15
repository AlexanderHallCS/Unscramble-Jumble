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
    
    @IBOutlet var hintsButton: UIButton!
    
    @IBOutlet var hintsLeftLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    var game: Game?
    
    var themeFileName: String = ""
    var imageName: String = ""
    
    var blankSpaces = [UIImageView]()
    var letters = [UIImageView]()
    
    var letterXAndYPositions = [[CGFloat]]()
    var letterAndIndex: [UIImageView:Int] = [:]
    var hintLetterIndices = [Int]()
    var hintLetterPositions = [Int]()
    
    var chosenLetterStack = [UIImageView]()
    var chosenLetterStackIndices = [Int]()
    
    var nextUnvisitedBlankSpace = 0
    var hintsLeft = 0
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
        assignRightAmountOfHints()
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
            
            for letterViewIndex in 0..<letters.count {
                if firstTouch.view == letters[letterViewIndex] {
                    animateTowardsBlankSpace(letter: letters[letterViewIndex])
                    //print("\(letters[letterViewIndex]) was tapped!")
                }
            }
        }
    }
    
    // moves(and shrinks if necessary) the letter towards the next available blank space
    private func animateTowardsBlankSpace(letter: UIImageView) {
        print("chosen letter stack indices: \(chosenLetterStackIndices)")
        while hintLetterPositions.contains(nextUnvisitedBlankSpace) || chosenLetterStackIndices.contains(nextUnvisitedBlankSpace){
            print("adooon")
            nextUnvisitedBlankSpace += 1
        }
        chosenLetterStack.append(letter)
        chosenLetterStackIndices.append(nextUnvisitedBlankSpace)
        UIView.animate(withDuration: 1.5, animations: {
            print("tapped/animated!")
            print("next unvisited as it is animating: \(self.nextUnvisitedBlankSpace)")
            letter.frame = CGRect(x: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.origin.x, y: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.origin.y, width: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.width, height: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.height)
            letter.rotate()
            self.view.bringSubviewToFront(letter)
            //letter.layer.zPosition = 1
        },completion: { _ in
            //letter.layer.zPosition = 0
            /*------>>>>check if the word is equal to the right word here(call a model function)<<<<--------*/
        })
        // stops the user from being able to tap on the letter while it is animating and once it finishes animating
        letters[letters.firstIndex(of: letter)!].isUserInteractionEnabled = false
        //nextUnvisitedBlankSpace += 1
        if nextUnvisitedBlankSpace != letters.count-1 {
            nextUnvisitedBlankSpace += 1
        } else {
            print("FOR VALHALLAH FOR JOTUNNHEIM")
        }
        
        print("hint letter indices: \(hintLetterIndices)")
        print("hint letter positions: \(hintLetterPositions)")
        
        print("next unvisited blank when add is called: \(nextUnvisitedBlankSpace)")
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
        print("remove next unvisited blank space before \(nextUnvisitedBlankSpace)")
        print("chosen letter stack indices remove before: \(chosenLetterStackIndices)")
        guard let lastLetterInStack = chosenLetterStack.last else {
            return
        }
        lastLetterInStack.frame = CGRect(x: letterXAndYPositions[letterAndIndex[lastLetterInStack]!][0], y: letterXAndYPositions[letterAndIndex[lastLetterInStack]!][1], width: self.view.frame.width/8, height: self.view.frame.width/8)
        chosenLetterStack.last!.layer.removeAllAnimations()
        chosenLetterStack.removeLast()
        chosenLetterStackIndices.removeLast()
        guard let firstLetterInStackIndex = chosenLetterStackIndices.first else {
            letters[letters.firstIndex(of: lastLetterInStack)!].isUserInteractionEnabled = true
            return
        }
        if nextUnvisitedBlankSpace != firstLetterInStackIndex/* && !chosenLetterStackIndices.contains(nextUnvisitedBlankSpace-1) && !hintLetterPositions.contains(nextUnvisitedBlankSpace-1)*/ {
            nextUnvisitedBlankSpace -= 1
        }
        guard let lastLetterInStackIndex = chosenLetterStackIndices.last else {
            letters[letters.firstIndex(of: lastLetterInStack)!].isUserInteractionEnabled = true
            return
        }
        while nextUnvisitedBlankSpace != lastLetterInStackIndex {
            print("who took the milk from the cookie jar? \(nextUnvisitedBlankSpace)")
            nextUnvisitedBlankSpace -= 1
        }
        /*while hintLetterPositions.contains(nextUnvisitedBlankSpace) && nextUnvisitedBlankSpace != hintLetterPositions.min() ?? -1/* && chosenLetterStackIndices.contains(nextUnvisitedBlankSpace)*/ {
                print("remeaux")
                nextUnvisitedBlankSpace -= 1
            }
        if nextUnvisitedBlankSpace == hintLetterPositions.min() ?? -1 && hintLetterPositions.min() ?? -1 > chosenLetterStackIndices.min() ?? -1 && chosenLetterStackIndices.count != 0 {
            print("A CLOSE ENCOUNTER! CERTAINLY!")
            nextUnvisitedBlankSpace = chosenLetterStackIndices.min()!
        }  */
        print("remove next unvisited blank space: \(nextUnvisitedBlankSpace)")
        print("chosen letter stack indices remove after: \(chosenLetterStackIndices)")
        letters[letters.firstIndex(of: lastLetterInStack)!].isUserInteractionEnabled = true
    }
    
    @IBAction func generateHint(_ sender: UIButton) {
        // don't allow the hint button to be pressed once all hints are used up
        if hintsLeft == 0 {
            hintsButton.isEnabled = false
        } else if hintsLeft == 1 {
            hintsUsed += 1
            hintsLeft -= 1
            hintsLeftLabel.text? = "Hints Left: \(hintsLeft)"
            hintsButton.isEnabled = false
        } else {
            hintsUsed += 1
            hintsLeft -= 1
            hintsLeftLabel.text? = "Hints Left: \(hintsLeft)"
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
        hintLetterPositions.append(self.game!.scrambledIndices[randomLetterIndex])
        
        // removes all the letters on the blank spaces in preparation for putting a hint in
        for _ in chosenLetterStack {
            removeLetter()
        }
        
        UIView.animate(withDuration: 1.5, animations: {
            print("animated hint!")
            self.letters[randomLetterIndex].frame = CGRect(x: self.blankSpaces[self.game!.scrambledIndices[randomLetterIndex]].frame.origin.x, y: self.blankSpaces[self.game!.scrambledIndices[randomLetterIndex]].frame.origin.y, width: self.blankSpaces[self.game!.scrambledIndices[randomLetterIndex]].frame.width, height: self.blankSpaces[self.game!.scrambledIndices[randomLetterIndex]].frame.height)
            self.letters[randomLetterIndex].rotate()
            self.view.bringSubviewToFront(self.letters[randomLetterIndex])
        }/*, completion: { _ in
            //self.letters[randomLetterIndex].layer.zPosition = 0
        }*/)
        print("randomLetterIndex: \(randomLetterIndex)")
        letters[randomLetterIndex].isUserInteractionEnabled = false
        
        //vvvNot Calledvvv
        /*if chosenLetterStack.contains(letters[randomLetterIndex]) {
            print("WHAT ARE WE GONNA REMOVE?????: \(chosenLetterStackIndices.firstIndex(of: randomLetterIndex)) IN \(chosenLetterStackIndices)")
            chosenLetterStack.remove(at: chosenLetterStack.firstIndex(of: letters[randomLetterIndex])!)
            chosenLetterStackIndices.remove(at: chosenLetterStackIndices.firstIndex(of: randomLetterIndex)!)
        } */
        print("RANDOM LETTER INDEX: \(randomLetterIndex)")
        
        print("hint letter positions: \(hintLetterPositions)")
        
    }
    
    func assignRightAmountOfHints() {
        switch game!.scrambledWord.count {
        //MARK: Fine tune these values later(maybe have the same number of hints as there are letters but reward 0 points for using all hints) --> unless you implement the functionality at the end when time runs out, put all letters in the right spot
        case 3:
            hintsLeft = 0
        case 4...5:
            hintsLeft = 3
        case 6:
            hintsLeft = 4
        case 7...9:
            hintsLeft = 5
        default:
            hintsLeft = 6
        }
        hintsLeftLabel.text? = "Hints Left: \(hintsLeft)"
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
