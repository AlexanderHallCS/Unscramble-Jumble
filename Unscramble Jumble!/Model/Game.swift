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
        /*unscrambledWord = removeCarriageReturn(from: getRandomWord(from: themeFile))
        scrambledWord = shuffleLetters(word: unscrambledWord) */
        // MARK: Change this later
        unscrambledWord = removeCarriageReturn(from: "Soloo Nib Zo")
        scrambledWord = shuffleLetters(word: "Soloo Nib Zo")
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
    
}
