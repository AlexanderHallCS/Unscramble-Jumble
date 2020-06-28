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
    var unscrambledWordWithoutSpaces = ""
    
    var scrambledIndices: [Int] = []
    
    init?(themeFile: String) {
        resetVariables()
        unscrambledWord = removeCarriageReturn(from: getRandomWord(from: themeFile))
        scrambledWord = shuffleLetters(word: unscrambledWord.split(separator: " ").joined())
        
        //scrambledIndices = getScrambledLetterIndices()
        print("Scrambled Indices: \(scrambledIndices)")
        //unscrambledWordLettersArray = getWordLetters()
        // MARK: Change this later
        /*unscrambledWord = removeCarriageReturn(from: "Solomon Islands")
        scrambledWord = shuffleLetters(word: "Solomon Islands".split(separator: " ").joined())*/
        unscrambledWordWithoutSpaces = unscrambledWord.split(separator: " ").joined().uppercased()
        print(unscrambledWord)
        print(scrambledWord)
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
   
    private func hasWordChanged(_ firstWord: String, _ secondWord: String) -> Bool {
        if firstWord != secondWord {
            return true
        }
        return false
    }
    
    // gets the string representation of the letter that was tapped
    public func getLetterStringRepresentation(from index: Int) -> String {
        return String(Array(scrambledWord)[index]).uppercased()
    }
    
    private func resetVariables() {
        scrambledWord = ""
        unscrambledWord = ""
        unscrambledWordWithoutSpaces = ""
        scrambledIndices = [Int]()
    }
}
