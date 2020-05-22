//
//  Word.swift
//  Unscramble It!
//
//  Created by Alexander Hall on 5/20/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import Foundation

class Game {

    var word = ""
    
    enum fileName: String {
        case Adjectives
        case Common_Words
        case Countries
        case Nature
        case Space
    }
    
    init?(theme: String) {
        word = getRandomShuffledWord(from: theme)
    }
    
    //MARK: Finish switch statement and consider changing strings to an enum in CategoryViewController
    private func getRandomShuffledWord(from fileName: String) -> String {
        
        var randomWord = ""
        
        /*switch fileName {
        case fileName.Adjectives.rawValue: return
        } */
        return shuffleLetters(word: randomWord)
    }
    
    private func shuffleLetters(word: String) -> String {
    
        var shuffledWord = ""
        
        repeat {
            shuffledWord = String(Array(word).shuffled())
        } while !hasWordChanged(word, shuffledWord)
        
        return shuffledWord
    }
   
    private func hasWordChanged(_ firstWord: String, _ secondWord: String) -> Bool {
        if firstWord != secondWord {
            return true
        }
        return false
    }
    
}
