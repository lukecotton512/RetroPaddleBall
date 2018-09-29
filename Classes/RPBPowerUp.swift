//
//  RPBPowerUp.swift
//  RetroPaddleBall
//
//  Created by Luke Cotton on 3/13/17.
//
//

import UIKit

@objc class RPBPowerUp: NSObject {
    
    /**
     The type of power up the power up represents.
    */
    @objc var whichPowerUp: RPBPowerUpType = .noPowerUp {
        didSet {
            self.updatePowerUpColor()
        }
    }
    
    /**
     RPBRectangle instance.
    */
    @objc private(set) var rectangle: RPBRectangle = RPBRectangle()
    
    /** 
     Create power up with random type.
    */
    @objc override init() {
        super.init()
        self.rectangle.rect.size = CGSize(width: 20, height: 20)
        self.randomizePowerup()
    }
    
    // Create power up with specified type.
    @objc init(powerUpType: RPBPowerUpType) {
        self.whichPowerUp = powerUpType
        self.rectangle.rect.size = CGSize(width: 20, height: 20)
        super.init()
    }
    
    /**
     Randomizes powerup
    */
    @objc func randomizePowerup() {
        let numGen = SCDNumberGenerator(upperBound: 5, lowerBound: 1)
        self.whichPowerUp = RPBPowerUpType(rawValue: numGen.randomNumber)!
    }
    
    /**
     Updates powerup color based on the type selected.
    */
    @objc func updatePowerUpColor() {
        switch (self.whichPowerUp) {
        case .speedUp:
            self.rectangle.rectColor = UIColor.green
        case .slowDown:
            self.rectangle.rectColor = UIColor.blue
        case .changeWall:
            self.rectangle.rectColor = UIColor.purple
        case .splitBall:
            self.rectangle.rectColor = UIColor.red
        default:
            break
        }
    }
    
    // Render the power up.
    @objc func render() {
        // Really render the rect.
        self.rectangle.render()
    }
    
}

// Power up enumeration.
@objc enum RPBPowerUpType: Int {
    case noPowerUp = 0
    case speedUp = 1
    case slowDown = 2
    case splitBall = 3
    case changeWall = 4
}
