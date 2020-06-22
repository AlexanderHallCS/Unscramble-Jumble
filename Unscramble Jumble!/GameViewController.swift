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
    @IBOutlet var countdownTimerLabel: UILabel!
    
    var game: Game?
    
    var themeFileName: String = ""
    var imageName: String = ""
    
    var blankSpaces = [UIImageView]()
    var letters = [UIImageView]()
    
    var letterXAndYPositions = [[CGFloat]]()
    var letterAndIndex: [UIImageView:Int] = [:]
    var finalLettersWithIndexAndStringRep: [UIImageView:(index: Int, stringRep: String)] = [:]
    var indexOfTappedLetter = [Int]()
    
    var hintLetterIndices = [Int]()
    var hintLetterPositions = [Int]()
    
    var chosenLetterStack = [UIImageView]()
    var chosenLetterStackIndices = [Int]()
    
    var nextUnvisitedBlankSpace = 0
    
    var hintsLeft = 0
    
    var countdownTimer = Timer()
    var seconds = 15.0
    
    var isPaused = false
    var completedLetterAnimations = 0
    
    var totalWordsSolvedThisGame = 0
    var totalScoreThisGame = 0
    var totalHintsUsedThisGame = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: imageName)
        
        //maybe change the event of willResignActiveNotification to something more forgiving
        NotificationCenter.default.addObserver(self, selector: #selector(suddenlyPauseGame), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restorePausedState), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeGame), name: NSNotification.Name(rawValue: "removedPauseVCNotification"), object: nil)
        startTimer()
        
        game = Game(themeFile: themeFileName)
        
        addBlankSpaces()
        addLetters()
        assignRightAmountOfHints()
    }
    
    deinit {
        print("did deinit3 and remove observers!")
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "removedPauseVCNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @IBAction func goToPauseVC(_ sender: UIButton) {
        isPaused = true
        print("GAME IS PAUSED")
        print("INT CEIL SELF.SECONDS PAUSE: \(Int(ceil(self.seconds)))")
        print("CEIL SELF.SECONDS PAUSE: \(ceil(self.seconds))")
        print("SELF.SECONDS PAUSE: \(self.seconds)")
        pauseGame()
        print("GAME IS PAUSED")
        print("INT CEIL SELF.SECONDS PAUSE AFTER: \(Int(ceil(self.seconds)))")
        print("CEIL SELF.SECONDS PAUSE AFTER: \(ceil(self.seconds))")
        print("SELF.SECONDS PAUSE AFTER: \(self.seconds)")
        let pauseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PausePopUpID") as! PauseViewController
        self.addChild(pauseVC)
        pauseVC.view.frame = self.view.frame
        self.view.addSubview(pauseVC.view)
        pauseVC.didMove(toParent: self)
    }
    
    // adds all the blank spaces to the top of the screen and positions/shrinks them accordingly
    private func addBlankSpaces() {
        var yShift: CGFloat = 0.0
        let yRowShift: CGFloat = self.view.frame.width/10 * CGFloat(game!.unscrambledWord.split(separator: " ").count-1)
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
                    blankSpaces[blankSpaceIndex].frame = CGRect(x: xShift, y: self.view.frame.height/16*7 - yRowShift + yShift, width: self.view.frame.width/8, height: self.view.frame.width/8)
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
                xShift = centerXOfFrame - unevenLetterOffset
                // ex: 6->7 to format 1 letter; 12->14 to format 2 letters
                for letterIndex in (letters.count-letters.count%6)..<letters.count {
                    letters[letterIndex].frame = CGRect(x: xShift, y: self.view.frame.height/32*27 - yRowShift + yShift, width: self.view.frame.width/8, height: self.view.frame.width/8)
                    letterXAndYPositions.append([letters[letterIndex].frame.origin.x,letters[letterIndex].frame.origin.y])
                    letterAndIndex[letters[letterIndex]] = letterIndex
                    self.view.addSubview(letters[letterIndex])
                    xShift += widthOfLetterPlusSpacing
                }
            } else {
                // this for loop is for all rows that aren't the last row unless the last row also has 6 letters
                for letterIndex in firstLetterInRowIndex..<firstLetterInRowIndex+6 {
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
            yShift += widthOfLetterPlusSpacing
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            for letterViewIndex in 0..<letters.count {
                if firstTouch.view == letters[letterViewIndex] {
                    indexOfTappedLetter.append(letterViewIndex)
                    animateTowardsBlankSpace(letter: letters[letterViewIndex])
                }
            }
        }
    }
    
    // moves(and shrinks if necessary) the letter towards the next available blank space
    private func animateTowardsBlankSpace(letter: UIImageView) {
        while hintLetterPositions.contains(nextUnvisitedBlankSpace) || chosenLetterStackIndices.contains(nextUnvisitedBlankSpace) {
            nextUnvisitedBlankSpace += 1
        }
        chosenLetterStack.append(letter)
        chosenLetterStackIndices.append(nextUnvisitedBlankSpace)
        finalLettersWithIndexAndStringRep[letter] = (nextUnvisitedBlankSpace, game!.getLetterStringRepresentation(from: indexOfTappedLetter.last!))
        UIView.animate(withDuration: 1.2, animations: {
            letter.frame = CGRect(x: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.origin.x, y: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.origin.y, width: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.width, height: self.blankSpaces[self.nextUnvisitedBlankSpace].frame.height)
            letter.rotate()
            self.view.bringSubviewToFront(letter)
        }, completion: { _ in
            self.completedLetterAnimations += 1
            print("COMPLETED LETTER ANIMATIONS: \(self.completedLetterAnimations)")
            // checking if all letters have been tapped
            if self.completedLetterAnimations == self.game!.unscrambledWordWithoutSpaces.count {
                var correctValues = 0
                let unscrambledWordWithoutSpacesArray = Array(self.game!.unscrambledWordWithoutSpaces)
                for value in self.finalLettersWithIndexAndStringRep.values {
                    if String(unscrambledWordWithoutSpacesArray[value.index]) == value.stringRep {
                        correctValues += 1
                    }
                }
                // checking when all letters are tapped if the final word is equal to the actual word
                if correctValues == unscrambledWordWithoutSpacesArray.count {
                    self.totalWordsSolvedThisGame += 1
                    self.createNewWord()
                    print("YOU WON!")
                } else {
                    print("INCORRECT >w< TRY AGAIN!")
                }
            }
        })
        // checking when all letters are tapped if the final word is equal to the actual word
        if self.finalLettersWithIndexAndStringRep.count != self.game!.unscrambledWordWithoutSpaces.count {
            // stops the user from being able to tap on the letter while it is animating and once it finishes animating
            letters[letters.firstIndex(of: letter)!].isUserInteractionEnabled = false
            if nextUnvisitedBlankSpace != letters.count-1 {
                nextUnvisitedBlankSpace += 1
            }
        }
        
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
        guard let lastLetterInStack = chosenLetterStack.last else {
            return
        }
        lastLetterInStack.frame = CGRect(x: letterXAndYPositions[letterAndIndex[lastLetterInStack]!][0], y: letterXAndYPositions[letterAndIndex[lastLetterInStack]!][1], width: self.view.frame.width/8, height: self.view.frame.width/8)
        guard let firstLetterInStackIndex = chosenLetterStackIndices.first else {
            letters[letters.firstIndex(of: lastLetterInStack)!].isUserInteractionEnabled = true
            return
        }
        finalLettersWithIndexAndStringRep.removeValue(forKey: chosenLetterStack.last!)
        chosenLetterStack.last!.layer.removeAllAnimations()
        chosenLetterStack.removeLast()
        chosenLetterStackIndices.removeLast()
        indexOfTappedLetter.removeLast()
        completedLetterAnimations -= 1
        if nextUnvisitedBlankSpace != firstLetterInStackIndex {
            nextUnvisitedBlankSpace -= 1
        }
        guard let lastLetterInStackIndex = chosenLetterStackIndices.last else {
            letters[letters.firstIndex(of: lastLetterInStack)!].isUserInteractionEnabled = true
            return
        }
        while nextUnvisitedBlankSpace != lastLetterInStackIndex {
            nextUnvisitedBlankSpace -= 1
        }
        letters[letters.firstIndex(of: lastLetterInStack)!].isUserInteractionEnabled = true
    }
    
    @IBAction func generateHint(_ sender: UIButton) {
        
        // don't allow the hint button to be pressed once all hints are used up
        if hintsLeft == 0 {
            hintsButton.isEnabled = false
        } else if hintsLeft == 1 {
            totalHintsUsedThisGame += 1
            hintsLeft -= 1
            hintsLeftLabel.text? = "Hints Left: \(hintsLeft)"
            hintsButton.isEnabled = false
        } else {
            totalHintsUsedThisGame += 1
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
        hintLetterPositions.append(game!.scrambledIndices[randomLetterIndex])
        finalLettersWithIndexAndStringRep[letters[randomLetterIndex]] = (game!.scrambledIndices[randomLetterIndex], game!.getLetterStringRepresentation(from: randomLetterIndex))
        
        // removes all the letters on the blank spaces in preparation for putting a hint in
        for _ in chosenLetterStack {
            removeLetter()
        }
        
        UIView.animate(withDuration: 1.2, animations: {
            self.letters[randomLetterIndex].frame = CGRect(x: self.blankSpaces[self.game!.scrambledIndices[randomLetterIndex]].frame.origin.x, y: self.blankSpaces[self.game!.scrambledIndices[randomLetterIndex]].frame.origin.y, width: self.blankSpaces[self.game!.scrambledIndices[randomLetterIndex]].frame.width, height: self.blankSpaces[self.game!.scrambledIndices[randomLetterIndex]].frame.height)
            self.letters[randomLetterIndex].rotate()
            self.view.bringSubviewToFront(self.letters[randomLetterIndex])
        }, completion: { _ in
            self.completedLetterAnimations += 1
        })
        letters[randomLetterIndex].isUserInteractionEnabled = false
    }
    
    func assignRightAmountOfHints() {
        switch game!.scrambledWord.count {
        //MARK: Fine tune these values later(maybe have the same number of hints as there are letters but reward 0 points for using all hints) --> unless you implement the functionality at the end when time runs out, put all letters in the right spot
        case 3:
            hintsLeft = 0
            hintsButton.isEnabled = false
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
    
    func startTimer() {
        let strokeTextAttributes: [NSAttributedString.Key:Any] = [.strokeColor:#colorLiteral(red: 0, green: 0, blue: 0.737254902, alpha: 1), .strokeWidth:-4.0]
        countdownTimerLabel.attributedText = NSAttributedString(string: "\(Int(ceil(self.seconds)))", attributes: strokeTextAttributes)
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
            //print("SELF.SECONDS IN TIMER: \(self.seconds)")
            if self.seconds > 0.0 {
                if Double(String(format: "%.0f", self.seconds.truncatingRemainder(dividingBy: 1.0))) == 0.0 {
                    self.countdownTimerLabel.attributedText = NSAttributedString(string: "\(Int(ceil(self.seconds)))", attributes: strokeTextAttributes)
                }
                //print("TRUNCATING REMAINDER: \(self.seconds.truncatingRemainder(dividingBy: 1.0))")
                self.seconds -= 0.1
            } else {
                self.countdownTimerLabel.attributedText = NSAttributedString(string: "0", attributes: strokeTextAttributes)
                self.countdownTimer.invalidate()
                // IMPLEMENT THIS FUNCTIONALITY(storing stuff in Core Data, adding a game over child VC, etc.)
                self.gameOver()
            }
        })
    }
    // called when someone closes the app or someone gets a call, etc.
    @objc private func suddenlyPauseGame() {
        if isPaused == false {
            isPaused = true
            //UserDefaults.standard.set("\(seconds)", forKey: "TimerState")
            let pauseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PausePopUpID") as! PauseViewController
            self.addChild(pauseVC)
            pauseVC.view.frame = self.view.frame
            self.view.addSubview(pauseVC.view)
            pauseVC.didMove(toParent: self)
            pauseGame()
        }
    }
    
    @objc private func restorePausedState() {
        print("RESTORED!")
        let strokeTextAttributes: [NSAttributedString.Key:Any] = [.strokeColor:#colorLiteral(red: 0, green: 0, blue: 0.737254902, alpha: 1), .strokeWidth:-4.0]
        countdownTimerLabel.attributedText = NSAttributedString(string: "\(Int(ceil(self.seconds)))", attributes: strokeTextAttributes)
        print("INT CEIL SELF.SECONDS: \(Int(ceil(self.seconds)))")
        print("CEIL SELF.SECONDS: \(ceil(self.seconds))")
        print("SELF.SECONDS: \(self.seconds)")
    }
    
    // MARK: Present a pause child view controller when app goes in background and pause everything(timers, etc.)
    private func pauseGame() {
        print("INT CEIL SELF.SECONDS: \(Int(ceil(self.seconds)))")
        print("CEIL SELF.SECONDS: \(ceil(self.seconds))")
        print("SELF.SECONDS: \(self.seconds)")
        countdownTimer.invalidate()
        print("INT CEIL SELF.SECONDS2: \(Int(ceil(self.seconds)))")
        print("CEIL SELF.SECONDS2: \(ceil(self.seconds))")
        print("SELF.SECONDS2: \(self.seconds)")
        for letter in finalLettersWithIndexAndStringRep.keys {
            pauseLetter(layer: letter.layer)
        }
        print("pause game!")
    }
    
    func pauseLetter(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    @objc func resumeGame() {
        isPaused = false
        print("GAME HAS BEEN RESUMED!")
        startTimer()
        for letter in finalLettersWithIndexAndStringRep.keys {
            resumeLayer(layer: letter.layer)
        }
    }
    
    //TODO: reset all variables(lists, booleans, etc.) and refresh UI by creating new instance of game and calling addLetters() and addBlankSpaces() --> See what is done in the viewDidLoad() function(compartmentalize by calling this function in viewDidLoad() and moving the code from there to here)
    public func createNewWord() {
        for blankSpace in blankSpaces {
            blankSpace.removeFromSuperview()
        }
        for letter in letters {
            letter.layer.removeAllAnimations()
            letter.removeFromSuperview()
        }
        countdownTimer.invalidate()
        //backgroundImage.image = UIImage(named: imageName)
        
        blankSpaces = [UIImageView]()
        letters = [UIImageView]()
        
        letterXAndYPositions = [[CGFloat]]()
        letterAndIndex = [:]
        finalLettersWithIndexAndStringRep = [:]
        indexOfTappedLetter = [Int]()
        
        hintLetterIndices = [Int]()
        hintLetterPositions = [Int]()
        
        chosenLetterStack = [UIImageView]()
        chosenLetterStackIndices = [Int]()
        
        nextUnvisitedBlankSpace = 0
        completedLetterAnimations = 0
        
        seconds = 15.0
        startTimer()
        
        game = Game(themeFile: themeFileName)
        //game!.scrambledIndices = [Int]()
        
        addBlankSpaces()
        addLetters()
        // this is set to false again when assignRightAmountOfHints() for 3-letter words
        hintsButton.isEnabled = true
        assignRightAmountOfHints()
    }
    
    // Also save data in Core Data before segueing
    private func gameOver() {
        // save data here
        self.performSegue(withIdentifier: "segueFromGameToGameOver", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromGameToGameOver" {
            if let destVC = segue.destination as? GameOverViewController {
                print("IM ETHAN BRADBERRY")
                destVC.worldsSolved = totalWordsSolvedThisGame
                destVC.score = totalScoreThisGame
                destVC.totalHints = totalHintsUsedThisGame
            }
        }
    }
    
    @IBAction func unwindToGameFromGameOverVC(segue: UIStoryboardSegue) {
        print("unwinded!")
    }
    
}
    
    

extension UIImageView {
    func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.2
        rotation.isCumulative = true
        // animation duration divided by rotation.duration
        rotation.repeatCount = 6
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
