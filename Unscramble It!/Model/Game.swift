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
    
    init?(theme: String) {
        word = getRandomShuffledWord(from: theme)
    }
    
    //MARK: Finish switch statement and consider changing strings to an enum in CategoryViewController
    private func getRandomShuffledWord(from fileName: String) -> String {
        /*switch fileName {
        case "Adjectives": return
        } */
        return ""
    }
    
    //MARK: Implement functionality by using Array(String).shuffled() -> [String]
    private func shuffleLetters(word: String) -> String {
        //make sure to check if the shuffled words are not equal to the same word before it was shuffled
        // ^^ do this with hasWordChanged(firstWord, secondWord) function
        return ""
    }
   
    private func hasWordChanged(firstWord: String, secondWord: String) -> Bool {
        if firstWord != secondWord {
            return true
        }
        return false
    }
    
}
