//
//  RPBWall.swift
//  RetroPaddleBall
//
//  Created by Luke Cotton on 12/23/16.
//
//

import UIKit
import GLKit

@objc class RPBWall: NSObject {
    // Main walls.
    private(set) var leftWall: RPBRectangle
    private(set) var rightWall: RPBRectangle
    private(set) var topWall: RPBRectangle
    private(set) var bottomWall: RPBRectangle
    
    // Paddle walls.
    private(set) var leftPaddleWall: RPBRectangle
    private(set) var rightPaddleWall: RPBRectangle
    private(set) var topPaddleWall: RPBRectangle
    private(set) var bottomPaddleWall: RPBRectangle
    
    // Losing wall.
    var wallToLose = 4 {
        didSet {
            // Update wall colors.
            self.updateWallColors()
        }
    }
    var wallToEnable = 0 {
        didSet {
            // Update wall colors.
            self.updateWallColors()
        }
    }
    
    // Projection matrix.
    var projectMatrix: GLKMatrix4
    
    // Our view size.
    var viewSize: CGRect = CGRect()
    
    // Initalizers.
    init(viewSize: CGRect) {
        // Set viewSize to the view size
        self.viewSize = viewSize
        // Create main walls
        self.leftWall = RPBRectangle()
        self.rightWall = RPBRectangle()
        self.topWall = RPBRectangle()
        self.bottomWall = RPBRectangle()
        
        // Create paddle walls.
        self.leftPaddleWall = RPBRectangle()
        self.rightPaddleWall = RPBRectangle()
        self.topPaddleWall = RPBRectangle()
        self.bottomPaddleWall = RPBRectangle()
        
        // Setup projection matrix.
        self.projectMatrix = GLKMatrix4MakeOrtho(0, Float(viewSize.size.width), Float(viewSize.size.height), 0, -1024, 1024)
        
        // Main wall projection matricies.
        self.leftWall.projectionMatrix = self.projectMatrix
        self.rightWall.projectionMatrix = self.projectMatrix
        self.topWall.projectionMatrix = self.projectMatrix
        self.bottomWall.projectionMatrix = self.projectMatrix
        
        // Paddle wall projection matricies.
        self.leftPaddleWall.projectionMatrix = self.projectMatrix
        self.rightPaddleWall.projectionMatrix = self.projectMatrix
        self.topPaddleWall.projectionMatrix = self.projectMatrix
        self.bottomPaddleWall.projectionMatrix = self.projectMatrix
        
        // Call superclass initalizer
        super.init()
        
        // Set all information for the first time.
        self.updateWallDimensions()
        self.updateWallColors()
    }
    
    // Sets the dimensions of each wall.
    func updateWallDimensions() {
        // Main Walls.
        self.leftWall.rect = CGRect(x: 0, y: 0, width: 5, height: viewSize.size.height)
        self.rightWall.rect = CGRect(x: viewSize.size.width-5, y: 0, width: 5, height: viewSize.size.height)
        self.topWall.rect = CGRect(x: 0, y: 0, width: viewSize.size.width, height: 5)
        self.bottomWall.rect = CGRect(x: 0, y: viewSize.size.height-5, width: viewSize.size.width, height: 5)
        
        // Paddle walls.
        self.leftPaddleWall.rect = CGRect(x: 5, y: 5, width: 15, height: viewSize.size.height - 10)
        self.rightPaddleWall.rect = CGRect(x: viewSize.size.width-20, y: 5, width: 15, height: viewSize.size.height-10)
        self.topPaddleWall.rect = CGRect(x: 5, y: 5, width: viewSize.size.width-10, height: 15)
        self.bottomPaddleWall.rect = CGRect(x: 5, y: viewSize.size.height-20, width: viewSize.size.width-10, height: 15)
    }
    
    // Updates wall colors.
    func updateWallColors() {
        // Left walls.
        if (wallToLose == 1) {
            self.leftWall.rectColor = UIColor.red
            self.leftPaddleWall.rectColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        } else if (wallToEnable == 1) {
            self.leftWall.rectColor = UIColor.green
            self.leftPaddleWall.rectColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        } else {
            self.leftWall.rectColor = UIColor.blue
            self.leftPaddleWall.rectColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        }
        
        // Top walls.
        if (wallToLose == 2) {
            self.topWall.rectColor = UIColor.red
            self.topPaddleWall.rectColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        } else if (wallToEnable == 2) {
            self.topWall.rectColor = UIColor.green
            self.topPaddleWall.rectColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        } else {
            self.topWall.rectColor = UIColor.blue
            self.topPaddleWall.rectColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        }
        
        // Right walls.
        if (wallToLose == 3) {
            self.rightWall.rectColor = UIColor.red
            self.rightPaddleWall.rectColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        } else if (wallToEnable == 3) {
            self.rightWall.rectColor = UIColor.green
            self.rightPaddleWall.rectColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        } else {
            self.rightWall.rectColor = UIColor.blue
            self.rightPaddleWall.rectColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        }
        
        // Bottom walls.
        if (wallToLose == 4) {
            self.bottomWall.rectColor = UIColor.red
            self.bottomPaddleWall.rectColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        } else if (wallToEnable == 6) {
            self.bottomWall.rectColor = UIColor.green
            self.bottomPaddleWall.rectColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        } else {
            self.bottomWall.rectColor = UIColor.blue
            self.bottomPaddleWall.rectColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        }
    }
    
    // Render function.
    func render() {
        // Render our underlying rectangles.
        // Main walls.
        self.leftWall.render()
        self.topWall.render()
        self.rightWall.render()
        self.bottomWall.render()
        
        // Paddle wall.
        self.leftPaddleWall.render()
        self.topPaddleWall.render()
        self.rightPaddleWall.render()
        self.bottomPaddleWall.render()
    }
}
