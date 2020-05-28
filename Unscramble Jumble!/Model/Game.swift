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
    
    init?(themeFile: String) {
        unscrambledWord = getRandomWord(from: themeFile)
        scrambledWord = shuffleLetters(word: unscrambledWord)
        print(unscrambledWord)
        print(scrambledWord)
        /*for _ in 0...40 {
            print(getRandomShuffledWord(from: themeFile) + "\n")
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
            shuffledWord = String(Array(word).shuffled())
        } while !hasWordChanged(word, shuffledWord)
        
        // remove carriage return in the word that appears in the file
        if shuffledWord.contains("\r") {
            shuffledWord.remove(at: shuffledWord.firstIndex(of: "\r")!)
        }
        
        return shuffledWord
    }
   
    public func hasWordChanged(_ firstWord: String, _ secondWord: String) -> Bool {
        if firstWord != secondWord {
            return true
        }
        return false
    }
    
}
