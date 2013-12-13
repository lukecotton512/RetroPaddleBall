//
//  CoreGraphicsDrawingView.h
//  CoreGraphicsDrawing
//
//  Created by Luke Cotton on 2/5/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WALLSIZE 4
#define WALLSIZEIPAD (WALLSIZE*2)
#define WALLBORDER 15
#define WALLBORDERIPAD (WALLBORDER*2)

@interface CoreGraphicsDrawingView : UIView {
	CGPoint initalPoint;
	CGPoint secondPoint;
	CGPoint thirdPoint;
	CGPoint fourthPoint;
	CGPathRef ballPath;
	CGPathRef ballPath2;
	CGRect ballRect;
	CGRect ballRect2;
	CGRect topOfScreen;
	CGRect rightOfScreen;
	CGRect leftOfScreen;
	CGRect bottomOfScreen;
    CGRect topOfScreenBall;
	CGRect rightOfScreenBall;
	CGRect leftOfScreenBall;
	CGRect bottomOfScreenBall;
	CGRect oldBallRect;
	CGRect oldPaddleRect;
	CGRect powerUpRect;
	int paddleLocked;
    int wallEnabled;
    int wallToLose;
    int wallSize;
    int wallBorderSize;
}
//-(CGMutablePathRef)pathFromRect:(CGRect)chosenRect;
-(void)lockPaddle;
-(void)unlockPaddle;
@property (nonatomic, assign) CGPoint initalPoint;
@property (nonatomic, assign) CGPoint secondPoint;
@property (nonatomic, assign) CGPoint thirdPoint;
@property (nonatomic, assign) CGPoint fourthPoint;
@property (nonatomic, assign) CGRect ballRect;
@property (nonatomic, assign) CGRect ballRect2;
@property (nonatomic, assign) CGRect inFrontBallRect2;
@property (nonatomic, assign) CGRect topOfScreen;
@property (nonatomic, assign) CGRect rightOfScreen;
@property (nonatomic, assign) CGRect leftOfScreen;
@property (nonatomic, assign) CGRect bottomOfScreen;
@property (nonatomic, assign) CGRect topOfScreenBall;
@property (nonatomic, assign) CGRect rightOfScreenBall;
@property (nonatomic, assign) CGRect leftOfScreenBall;
@property (nonatomic, assign) CGRect bottomOfScreenBall;
@property (nonatomic, assign) CGRect oldBallRect;
@property (nonatomic, assign) CGRect oldPaddleRect;
@property (nonatomic, assign) CGRect powerUpRect;
@property (nonatomic, assign) int paddleLocked;
@property (nonatomic, assign) int wallEnabled;
@property (nonatomic, assign) int wallToLose;
@end
