//
//  GameViewController.swift
//  Unscramble Jumble!
//
//  Created by Alexander Hall on 5/16/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import UIKit
import NotificationCenter
import AVFoundation

class GameViewController: UIViewController {
    
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var undoLetterButton: UIButton!
    @IBOutlet var undoAllLettersButton: UIButton!
    @IBOutlet var hintsButton: UIButton!
    
    @IBOutlet var hintsLeftLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var countdownTimerLabel: UILabel!
    
    var game: Game?
    var coreDataManager = CoreDataManager()
    
    var audioPlayer: AVAudioPlayer?
    
    var themeFileName: String = ""
    var imageName: String = ""
    
    var hintsAndScoreLabelColor = UIColor.black
    
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
    var seconds = 30.0
    var secondsSubtractingMultiplier = 1.0
    
    var isPaused = false
    var didSuddenlyPause = false
    var didGetWordRight = false
    var didGetWordWrong = false
    var shouldAddRedBorder = true
    var shouldAddGreenBorder = true
    var isNewGame = false
    
    var completedLetterAnimations = 0
    
    var totalWordsSolvedThisGame = 0
    var totalScoreThisGame = 0
    var totalHintsUsedThisGame = 0
    
    var scoreAvailableFromWord = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: imageName)
        
        NotificationCenter.default.addObserver(self, selector: #selector(suddenlyPauseGame), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restorePausedState), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeGame), name: NSNotification.Name(rawValue: "removedPauseVCNotification"), object: nil)
        startTimer()
        
        game = Game(themeFile: themeFileName)
        
        scoreLabel.textColor = hintsAndScoreLabelColor
        hintsLeftLabel.textColor = hintsAndScoreLabelColor
        
        addBlankSpaces()
        addLetters()
        assignRightAmountOfHints()
        scoreAvailableFromWord = 20 * game!.unscrambledWordWithoutSpaces.count
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "removedPauseVCNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @IBAction func goToPauseVC(_ sender: UIButton) {
        isPaused = true
        pauseGame()
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
        for word in game!.unscrambledWord.split(separator: " ") {
            if word.count <= 6 {
                wordsLessThanLengthSix += 1
            }
        }
        if wordsLessThanLengthSix == game!.unscrambledWord.split(separator: " ").count {
            let centerXOfFrame = self.view.frame.width/2 - self.view.frame.width/8/2
            let widthOfLetterPlusSpacing = self.view.frame.width/8 + self.view.frame.width/32
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
                    playSound(fileName: "LetterTapSound")
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
            // checking if all letters have been tapped
            if self.completedLetterAnimations == self.game!.unscrambledWordWithoutSpaces.count {
                var correctValues = 0
                let unscrambledWordWithoutSpacesArray = Array(self.game!.unscrambledWordWithoutSpaces)
                for value in self.finalLettersWithIndexAndStringRep.values {
                    if String(unscrambledWordWithoutSpacesArray[value.index]) == value.stringRep {
                        correctValues += 1
                    }
                }
                // got word right
                if correctValues == unscrambledWordWithoutSpacesArray.count {
                    self.playSound(fileName: "CorrectAnswerSound")
                    self.didGetWordRight = true
                    self.didGetWordWrong = false
                    if self.isPaused == false {
                        self.totalScoreThisGame += self.scoreAvailableFromWord
                        self.scoreLabel.text = "Score: \(self.totalScoreThisGame)"
                        self.countdownTimer.invalidate()
                        self.totalWordsSolvedThisGame += 1
                        self.addGreenBorderAndCreateWord()
                    }
                // got word wrong
                } else {
                    self.playSound(fileName: "WrongAnswerSound")
                    self.didGetWordRight = false
                    self.didGetWordWrong = true
                    if self.isPaused == false {
                        self.addRedBorder()
                    }
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
        if completedLetterAnimations != game!.unscrambledWordWithoutSpaces.count {
            removeLetter()
        }
    }
    
    @IBAction func removeAllLetters(_ sender: UIButton) {
        if completedLetterAnimations != game!.unscrambledWordWithoutSpaces.count {
            for _ in chosenLetterStack {
                removeLetter()
            }
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
        
        // if statement fixes a bug where the first hint is removed from the finalLetters dictionary
        if !hintLetterPositions.contains(finalLettersWithIndexAndStringRep[chosenLetterStack.last!]!.index) {
            finalLettersWithIndexAndStringRep.removeValue(forKey: chosenLetterStack.last!)
        }
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
        if completedLetterAnimations != game!.unscrambledWordWithoutSpaces.count {
            // don't allow the hint button to be pressed once all hints are used up
            if hintsLeft == 0 {
                if game!.unscrambledWordWithoutSpaces.count == 3 {
                    hintsButton.isEnabled = false
                } else {
                    scoreAvailableFromWord -= 20
                }
            } else if hintsLeft == 1 {
                scoreAvailableFromWord -= 20
                totalHintsUsedThisGame += 1
                hintsLeft -= 1
                hintsLeftLabel.text? = "Hints Left: \(hintsLeft)"
                hintsButton.isEnabled = false
            } else {
                scoreAvailableFromWord -= 20
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
            
            playSound(fileName: "LetterTapSound")
            UIView.animate(withDuration: 1.2, animations: {
                self.letters[randomLetterIndex].frame = CGRect(x: self.blankSpaces[self.game!.scrambledIndices[randomLetterIndex]].frame.origin.x, y: self.blankSpaces[self.game!.scrambledIndices[randomLetterIndex]].frame.origin.y, width: self.blankSpaces[self.game!.scrambledIndices[randomLetterIndex]].frame.width, height: self.blankSpaces[self.game!.scrambledIndices[randomLetterIndex]].frame.height)
                self.letters[randomLetterIndex].rotate()
                self.view.bringSubviewToFront(self.letters[randomLetterIndex])
            }, completion: { _ in
                self.completedLetterAnimations += 1
            })
            letters[randomLetterIndex].isUserInteractionEnabled = false
        }
    }
    
    func assignRightAmountOfHints() {
        switch game!.scrambledWord.count {
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
    
    private func startTimer() {
        let strokeTextAttributes: [NSAttributedString.Key:Any] = [.strokeColor:#colorLiteral(red: 0, green: 0, blue: 0.737254902, alpha: 1), .strokeWidth:-4.0]
        countdownTimerLabel.attributedText = NSAttributedString(string: "\(Int(ceil(self.seconds)))", attributes: strokeTextAttributes)
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
            if self.seconds > -1.0 {
                if Double(String(String(self.seconds).split(separator: ".")[1].first!))! == 0.0 {
                    self.countdownTimerLabel.attributedText = NSAttributedString(string: "\(Int(self.seconds))", attributes: strokeTextAttributes)
                }
                self.seconds -= 0.1
            } else {
                self.countdownTimerLabel.attributedText = NSAttributedString(string: "0", attributes: strokeTextAttributes)
                self.countdownTimer.invalidate()
                self.gameOver()
            }
        })
    }
    
    // called when the app goes to the background(ex: someone gets a call, home button is pressed, notification center is opened, etc.)
    @objc private func suddenlyPauseGame() {
        if isPaused == false {
            isPaused = true
            didSuddenlyPause = true
            pauseGame()
            let pauseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PausePopUpID") as! PauseViewController
            self.addChild(pauseVC)
            pauseVC.view.frame = self.view.frame
            self.view.addSubview(pauseVC.view)
            pauseVC.didMove(toParent: self)
        }
    }
    
    // is called when app goes back into foreground after being interrupted
    @objc private func restorePausedState() {
        let strokeTextAttributes: [NSAttributedString.Key:Any] = [.strokeColor:#colorLiteral(red: 0, green: 0, blue: 0.737254902, alpha: 1), .strokeWidth:-4.0]
        countdownTimerLabel.attributedText = NSAttributedString(string: "\(Int(ceil(self.seconds)))", attributes: strokeTextAttributes)
        if didGetWordRight {
            for letter in letters {
                letter.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                letter.layer.borderWidth = letter.frame.width/20
            }
        }
    }
    
    private func pauseGame() {
        countdownTimer.invalidate()
        for letter in finalLettersWithIndexAndStringRep.keys {
            pauseLayer(layer: letter.layer)
        }
    }
    
    func pauseLayer(layer: CALayer) {
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
        if didGetWordRight {
            if didSuddenlyPause {
                playSound(fileName: "CorrectAnswerSound")
                totalScoreThisGame += scoreAvailableFromWord
                scoreLabel.text = "Score: \(totalScoreThisGame)"
                totalWordsSolvedThisGame += 1
            }
            createNewWord()
        } else if didGetWordWrong && completedLetterAnimations == game!.unscrambledWordWithoutSpaces.count {
            startTimer()
            if shouldAddRedBorder == false {
                for letter in finalLettersWithIndexAndStringRep.keys {
                    resumeLayer(layer: letter.layer)
                }
                for letter in letters {
                    letter.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    removeLetter()
                }
            } else {
                if didSuddenlyPause {
                    playSound(fileName: "WrongAnswerSound")
                    for letter in finalLettersWithIndexAndStringRep.keys {
                        resumeLayer(layer: letter.layer)
                    }
                }
                addRedBorder()
            }
        } else {
            startTimer()
            for letter in finalLettersWithIndexAndStringRep.keys {
                resumeLayer(layer: letter.layer)
            }
        }
        isPaused = false
    }
    
    // Resets all variables, removes animations and UIImageViews, and creates another instance of game which, in turn, creates a new word
    public func createNewWord() {
        for blankSpace in blankSpaces {
            blankSpace.removeFromSuperview()
        }
        for letter in letters {
            letter.layer.removeAllAnimations()
            letter.removeFromSuperview()
        }
        countdownTimer.invalidate()
        
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
        
        didSuddenlyPause = false
        didGetWordRight = false
        didGetWordWrong = false
        shouldAddGreenBorder = true
        shouldAddRedBorder = true
        
        //takes away 2 seconds for every word solved down to a minimum of 2 seconds
        if isNewGame == false {
            seconds = 30.0 - 2*secondsSubtractingMultiplier
            if 30.0 - 2*secondsSubtractingMultiplier > 2.0 {
                secondsSubtractingMultiplier += 1
            }
        } else {
            seconds = 30.0
            secondsSubtractingMultiplier = 1.0
            isNewGame = false
        }
        
        startTimer()
        
        game = Game(themeFile: themeFileName)
        
        addBlankSpaces()
        addLetters()
        // this is set to false again when assignRightAmountOfHints() for 3-letter words
        hintsButton.isEnabled = true
        assignRightAmountOfHints()
        scoreAvailableFromWord = 20 * game!.unscrambledWordWithoutSpaces.count
        scoreLabel.text = "Score: \(totalScoreThisGame)"
    }
    
    // Saves and fetches data then segues to GameOver VC.
    private func gameOver() {
        // this is to stop any words from being created after the segue
        //isPaused = true
        for letter in letters {
            letter.layer.removeAllAnimations()
            letter.isUserInteractionEnabled = false
        }
        // save totals to database
        coreDataManager.addAndSaveTotalStatsData(totalGamesPlayed: coreDataManager.fetchTotalStatsData().totalGamesPlayed + 1, totalScore: coreDataManager.fetchTotalStatsData().totalScore + totalScoreThisGame, totalWordsSolved: coreDataManager.fetchTotalStatsData().totalWordsSolved + totalWordsSolvedThisGame)
        // save best game data if this is the best game(higher score compared to original highest score)
        if totalScoreThisGame > coreDataManager.fetchBestGameData().bestScore {
            coreDataManager.addAndSaveBestGameData(bestCategory: game!.category, bestHintsUsed: totalHintsUsedThisGame, bestScore: totalScoreThisGame, bestWordsSolved: totalWordsSolvedThisGame)
        }
        self.performSegue(withIdentifier: "segueFromGameToGameOver", sender: nil)
    }
    
    private func addGreenBorderAndCreateWord() {
        shouldAddGreenBorder = false
        for letter in letters {
            letter.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            letter.layer.borderWidth = letter.frame.width/20
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            if self.isPaused == false {
                self.createNewWord()
            }
        })
    }
    
    private func addRedBorder() {
        shouldAddRedBorder = false
        for letter in letters {
            letter.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            letter.layer.borderWidth = letter.frame.width/20
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            if self.isPaused == false {
                for letter in self.letters {
                    letter.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    self.removeLetter()
                }
            }
        })
    }
    
    func playSound(fileName: String) {
        if isSoundOn {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
                return
            }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                guard let audioPlayer = audioPlayer else {
                    return
                }
                audioPlayer.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromGameToGameOver" {
            if let destVC = segue.destination as? GameOverViewController {
                destVC.worldsSolved = totalWordsSolvedThisGame
                destVC.score = totalScoreThisGame
                destVC.totalHints = totalHintsUsedThisGame
            }
        }
    }
    
    @IBAction func unwindToGameFromGameOverVC(segue: UIStoryboardSegue) {
   
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
