//
//  Menus.swift
//  FlappySwift
//
//  Created by Gaurav Tamhan on 10/21/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Menus: GamePlayScene {
    
    var audioPlayer = AVAudioPlayer()
    
    override func didLoadFromCCB() {
        playAudio()
    }
    
    override func update(delta: CCTime) {
        
    }
    
    func playAudio() {
        do {
            if let bundle = NSBundle.mainBundle().pathForResource("menuMusic", ofType: "mp3") {
                let alertSound = NSURL(fileURLWithPath: bundle)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                try audioPlayer = AVAudioPlayer(contentsOfURL: alertSound)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
        } catch {
            print(error)
        }
    }

}
