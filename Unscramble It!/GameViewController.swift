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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.layer.zPosition = -1
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
    
    private func addBlankSpaces() {
        for _ in 0..<game!.unscrambledWord.count {
            blankSpaces.append(UIImageView(image: UIImage(named: "Blank Space")!))
        }
        
    }
    
    private func addLetters() {
        for letter in game!.scrambledWord.indices {
            if game!.scrambledWord[letter] != " " {
                letters.append(UIImageView(image: UIImage(named: String(game!.scrambledWord[letter].uppercased()))!))
            }
        }
        //let xValue = self.view.frame.width/2 - letters[0].bounds.width/2
        //print("X Value: \(xValue)")
        /*let frameWidth2 = self.view.frame.width/2
        print("self.view.frame.width/2 + \(frameWidth2)")
        let letterBoundWidth = letters[0].bounds.width/2
        print("letters[0].bounds.width/2 + \(letterBoundWidth)") */
        letters[0].frame = CGRect(x: self.view.frame.width/2 - self.view.frame.width/8/2, y: self.view.frame.height/6*5, width: self.view.frame.width/8, height: self.view.frame.width/8)
        let xValue = self.view.frame.width/2 - letters[0].bounds.width/2
        //print("X Value: \(xValue)")
        self.view.addSubview(letters[0])
        /*print(self.view.frame.width/2)
        print(letters[0].bounds.width/2)
        print("Added values: \(self.view.frame.width/2 + letters[0].bounds.width/2)")
        print("Subtracted values: \(self.view.frame.width/2 - letters[0].bounds.width/2)") */
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
