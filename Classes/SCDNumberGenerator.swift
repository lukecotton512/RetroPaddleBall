//
//  SCDNumberGenerator.swift
//  RetroPaddleBall
//
//  Created by Luke Cotton on 10/6/16.
//  Copyright © 2016 Luke Cotton. All rights reserved.
//

import Foundation

// Random number generator class.
class SCDNumberGenerator {
    // Upper and lower bounds.
    var upperBound: Int = 10
    var lowerBound: Int = 0
    // Return a random number within the given range.
    var randomNumber: Int {
        get {
            return Int.random(in: lowerBound ..< upperBound)
        }
    }
    // Initalizers.
    convenience init(upperBound highBound: Int, lowerBound lowBound: Int) {
        // Call init.
        self.init()
        // Setup high and low bounds
        self.upperBound = highBound
        self.lowerBound = lowBound
    }
}
