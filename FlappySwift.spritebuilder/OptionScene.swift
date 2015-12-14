//
//  OptionScene.swift
//  FlappySwift
//
//  Created by Gaurav Tamhan on 10/21/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class OptionScene: Menus {
    
    override func didLoadFromCCB() {
        if (sound == true) {
            playAudio()
        }
    }
    
    override func update(delta: CCTime) {
    
    }
    
    func back() {
        let scene = CCBReader.loadAsScene("StartScene")
        CCDirector.sharedDirector().replaceScene(scene)
    }

}