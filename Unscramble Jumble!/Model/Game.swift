//
//  Word.swift
//  Unscramble It!
//
//  Created by Alexander Hall on 5/20/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import Foundation

class Game {

    var scrambledWord = ""
    var unscrambledWord = ""
    
    var scrambledIndices: [Int] = []
    
    init?(themeFile: String) {
        unscrambledWord = removeCarriageReturn(from: getRandomWord(from: themeFile))
        scrambledWord = shuffleLetters(word: unscrambledWord.split(separator: " ").joined())
        
        //scrambledIndices = getScrambledLetterIndices()
        print("Scrambled Indices: \(scrambledIndices)")
        //unscrambledWordLettersArray = getWordLetters()
        // MARK: Change this later
        /*unscrambledWord = removeCarriageReturn(from: "Saudi Arabia")
        scrambledWord = shuffleLetters(word: "Saudi Arabia".split(separator: " ").joined())*/
        print(unscrambledWord)
        print(scrambledWord)
        // MARK: UNCOMMENT vvTHISvv TO TEST FOR BLANK SPACES AT END OF FILE
        /*let filePath = Bundle.main.path(forResource: themeFile, ofType: "txt")
        let fileContents = try! String(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
        let allWordsInFile = fileContents.components(separatedBy: ["\n"])
        for wooord in allWordsInFile {
            print(wooord)
        } */
        
    }
    
    private func getRandomWord(from fileName: String) -> String {
        
        let filePath = Bundle.main.path(forResource: fileName, ofType: "txt")
        let fileContents = try! String(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
        let allWordsInFile = fileContents.components(separatedBy: ["\n"])
        let randomWord = allWordsInFile.randomElement()!
        
        return randomWord
    }
    
    private func shuffleLetters(word: String) -> String {
    
        var shuffledWord = ""
        
        repeat {
            shuffledWord = ""
            scrambledIndices = Array(0..<word.count).shuffled()
            for letterIndex in 0..<scrambledIndices.count {
                shuffledWord.append(Array(word)[scrambledIndices[letterIndex]])
            }
        } while !hasWordChanged(word, shuffledWord)
        
        
        shuffledWord = removeCarriageReturn(from: shuffledWord)
        
        return shuffledWord
    }
    
    // remove carriage return from the word that appears in the file(all words in the file have one except
    // the last word in the file)
    private func removeCarriageReturn(from word: String) -> String {
        var wordCopy = word
        if wordCopy.contains("\r") {
            wordCopy.remove(at: wordCopy.firstIndex(of: "\r")!)
        }
        return wordCopy
    }
   
    public func hasWordChanged(_ firstWord: String, _ secondWord: String) -> Bool {
        if firstWord != secondWord {
            return true
        }
        return false
    }
    
    /*private func getLowercaseSpacelessScrambledWord() -> String {
        return scrambledWord.split(separator: " ").joined().lowercased()
    } */
   
    /*private func getScrambledLetterIndices() -> [Int] {
        var unscrambledWordFormattedCopy = unscrambledWord.split(separator: " ").joined().lowercased()
        for letter in getLowercaseSpacelessScrambledWord() {
            print("LEEETTTERRRR: \(letter)")
            if !scrambledIndices.contains(unscrambledWordFormattedCopy.firstIndex(of: letter)!) {
                scrambledIndices.append(unscrambledWordFormattedCopy.firstIndex(of: letter)!)
            } else {
                
            }
        }
        print("OOOO KILL EM: \(correctLetterWithIndex)")
        return correctLetterWithIndex.values.joined().map{ Int(String($0))! }
    } */
    
    
}
