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
    
    var game = Game?
    
    var gameTheme: String = ""
    var imageName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: imageName)
        //maybe change the event of willResignActiveNotification to something more forgiving
        NotificationCenter.default.addObserver(self, selector: #selector(pauseGame), name: UIApplication.willResignActiveNotification, object: nil)
        
        game = Game(theme: gameTheme)
    }
    
    deinit {
        print("did deinit3!")
    }

    // MARK: Present a pause child view controller when app goes in background and pause everything(timers, etc.)
    @objc func pauseGame() {
        print("pause game!")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
