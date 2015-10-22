//
//  StartScene.swift
//  FlappySwift
//
//  Created by Gaurav Tamhan on 10/19/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class StartScene: Menus {
    
    weak var _playButton: CCNode!
    weak var _optionsButton: CCNode!
    
    
    override func didLoadFromCCB() {
        super.didLoadFromCCB()
    }
    
    override func update(delta: CCTime) {
        
    }
    
    func play() {
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(scene)
    }
    
    func options() {
        let scene2 = CCBReader.loadAsScene("OptionScene")
        CCDirector.sharedDirector().replaceScene(scene2)
    }
    
    
    

}
