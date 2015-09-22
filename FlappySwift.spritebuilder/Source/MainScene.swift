//
//  MainScene.swift
//  FlappySwift
//
//  Created by Gaurav Tamhan on 9/21/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class MainScene: GamePlayScene {

    override func didLoadFromCCB() {
        super.didLoadFromCCB()
        
        userInteractionEnabled = true
        _gamePhysicsNode.collisionDelegate = self
        
        hero = CCBReader.load("Character") as? Character
        _gamePhysicsNode.addChild(hero)
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        hero?.flap()
        sinceTouch = 0
    }
}
