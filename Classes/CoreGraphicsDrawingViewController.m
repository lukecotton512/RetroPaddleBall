//
//  CoreGraphicsDrawingViewController.m
//  CoreGraphicsDrawing
//
//  Created by Luke Cotton on 2/5/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import "CoreGraphicsDrawingViewController.h"
#import "CoreGraphicsDrawingAppDelegate.h"
#import "GameOverViewController.h"
#import "RPBRectangle.h"
#import "RPBUsefulFunctions.h"

#define PADDLESIZE 80
#define PADDLESIZEIPAD 160
#define NOSCOREZONE 30
#define NOSCOREZONEIPAD 60
#define WALLSIZE 4
#define WALLSIZEIPAD (WALLSIZE*2)
#define WALLBORDER 15
#define WALLBORDERIPAD (WALLBORDER*2)

@implementation CoreGraphicsDrawingViewController
// Synthesize various variables.
@synthesize ballTimer, mainView, topOfScreen, rightOfScreen, leftOfScreen, bottomOfScreen, didStart, speedBounce, speedTimer, scoreField, score, oldBallRect, oldPaddleRect, pauseView, didInvalidate, isPaused, powerUpRect, powerUpEnabled, powerUpTimer, powerUpEnabledEnabled, didStartPowerUp, powerUpStartedTimer, didStartStartPowerUp, timerToRelease, scoreMultiplier, fireTimeInterval, difficultyMultiplier, ballRect, paddlelocation, paddleLocked, cheatCheckTimer, doAddOnToScore, noScoreZone,noScoreZone2,noScoreZone3,noScoreZone4, lastTimeUpdate, velocityX, velocityY, xAccel, yAccel, xAccelCali, yAccelCali, wallScoreBoostTimer, wallEnabled, wallToEnable, justStartedWallTimer,bottomOfScreenBall,topOfScreenBall,rightOfScreenBall,leftOfScreenBall, isPlaying, soundIsOn, leftTopRect, rightTopRect, leftBottomRect, rightBottomRect, upperLeftRect, lowerLeftRect, upperRightRect, lowerRightRect, areYouSureView, pauseButton, ballViewArray, audioFile1, audioFile2, audioFile3, playcount, audioFile4, speedMultiplier, doSlowDown, randomBrickArray, randomBrickTimer, wallToLose, highScoreField, didStartLoseWall, loseWallChangeTimer, dontmoveUp, dontmoveDown, randomBrickHitCounter, randomRect1, randomRect2, randomRect3, velocityLockEnabled,velocitySignX, velocitySignY, paddleSize, context, paddleEffect;



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    // Superclass implementation.
    [super viewDidLoad];
    
    // Setup OpenGL context.
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (self.context == nil) {
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (self.context == nil) {
            RPBLog(@"Failed to create context");
            return;
        }
    }
    mainView.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    self.preferredFramesPerSecond = 60;
    self.resumeOnDidBecomeActive = NO;
}

// Sets up everything for OpenGL.
-(void)setupGL {
    // Unpause everything and setup current context.
    self.paused = NO;
    [EAGLContext setCurrentContext:self.context];
    
}

// Shuts down everything.
-(void)tearDownGL {
    self.paused = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self newGame];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self theEnd];
}

// Generates random rectangle for bricks.
-(CGRect)randomRectangle2:(int)j count:(int)k;
{
    if(CGRectIntersectsRect(RANDOMBRICKAREA, CGRectMake(paddleCenter.x-(paddleSize/2), paddleCenter.y-(paddleSize/2), paddleSize, paddleSize))){
        randomBrickFailed = YES;
        return CGRectNull;
    } else {
        randomBrickFailed = NO;
    }
    if (k==19) {
        return CGRectMake(-9999999, -9999999, 0, 0);
    }
    float randomNumberx;
    float randomNumbery;
    CGRect randomRect;
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        if (j==0) {
            randomNumberx = (arc4random() % 214) + 38;
            randomNumbery = (arc4random() % 200) + 50;
        } else if (j==1) {
            randomNumberx = (arc4random() % 400) + 204;
            randomNumbery = (arc4random() % 200) + 50;
        } else {
            randomNumberx = (arc4random() % 400) + 38;
            randomNumbery = (arc4random() % 500) + 260;
        }
        randomRect=CGRectMake(randomNumberx, randomNumbery, 160, 60);
    } else {
        if (j==0) {
            randomNumberx = (arc4random() % 70) + 19;
            randomNumbery = (arc4random() % 120) + 50;
        } else if (j==1) {
            randomNumberx = (arc4random() % 120) + 101;
            randomNumbery = (arc4random() % 120) + 50;
        } else {
            randomNumberx = (arc4random() % 150) + 19;
            randomNumbery = (arc4random() % 200) + 81;
        }
        randomRect=CGRectMake(randomNumberx, randomNumbery, 80, 30);
    }
	RPBLog(@"randomRectangle2: x: %f y: %f j: %i count:%i", randomNumberx, randomNumbery, j, k);
    int i;
    for (i=0;i<randomBrickArray.count;i++) {
        if (CGRectIntersectsRect([randomBrickArray[i] rectOfView], randomRect)) {
            randomRect=[self randomRectangle2:j count:k+1];
        }
        if (CGRectIntersectsRect(CGRectMake(paddleCenter.x-(paddleSize/2), paddleCenter.y-(paddleSize/2), paddleSize, paddleSize), randomRect)) {
            randomRect=[self randomRectangle2:j count:k+1];
        }
        if (CGRectIntersectsRect(powerUpRect, randomRect)&&powerUpEnabled==1) {
            powerUpAbsorbed=1;
            whichBrick=j;
        }
        else if(CGRectIntersectsRect(powerUpRect2, randomRect)&&powerUpEnabled==1){
            powerUpAbsorbed=2;
            whichBrick=j;
        }
        else if (CGRectIntersectsRect(powerUpRect3, randomRect)&&powerUpEnabled==1) {
            powerUpAbsorbed=3;
            whichBrick=j;
        } else if (CGRectIntersectsRect(powerUpRect4, randomRect)&&powerUpEnabled==1) {
            powerUpAbsorbed=4;
            whichBrick=j;
        } else {
            powerUpAbsorbed=0;
        }
    }
    for (i=0; i<ballViewArray.count; i++) {
        if (CGRectIntersectsRect([(RPBBall *)ballViewArray[i] rect], randomRect)) {
            randomRect=[self randomRectangle2:j count:k+1];
        }
    }
    return randomRect;
}
-(CGRect)randomRectangle
{
    // Generate random rectangles on different coordinates based on whether or not we are on the iPad or not.
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        float randomNumberx = (arc4random() % (450 - 72)) + 72;
        float randomNumbery = (arc4random() % (606 - 72)) + 72;
        RPBLog(@"randomRectangle: x: %f y: %f", randomNumberx, randomNumbery);
        return CGRectMake(randomNumberx, randomNumbery, 40, 40);
    } else {
        float randomNumberx = (arc4random() % (241 - 38)) + 38;
        float randomNumbery = (arc4random() % (311 - 38)) + 38;
        RPBLog(@"randomRectangle: x: %f y: %f", randomNumberx, randomNumbery);
        return CGRectMake(randomNumberx, randomNumbery, 20, 20);
    }
}
-(double)randomTimerTime
{
	return (arc4random() % 60 - 20) + 20;
}
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // Bind framebuffer.
    [self.mainView bindDrawable];
    // Clear the display and set blending.
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    // If there is no game, then don't render.
    if (_gameOver==YES) {
        return;
    }
    // Check to make sure things have been set up.
    if (self.paddle==nil || walls==nil) {
        return;
    }
    // Render the power up on the display.
    if (powerUpEnabled == 1 && whichBrick==4 && powerUpAbsorbed==0) {
        [powerup render];
    }
    // Render the paddle.
    [self.paddle render];
    
    // Render the walls.
    [walls render];
    
    // Render each ball.
    for (RPBBall *ball in ballViewArray) {
        [ball render];
    }
    // Render each random brick if they are supposed to be on display.
    if (randomBrickIsEnabled == YES) {
        for (RPBRandomRect *randomRectPointer in randomBrickArray) {
            [randomRectPointer render];
        }
    }
}

// Called when the view controller wants to update the frame, in this case we call moveball.
-(void)update {
    [self moveBall:nil];
}

-(void)moveBall:(NSTimer *)theTimer
{
    int i;
    for (i=0; i<ballViewArray.count; i++) {
        RPBBall *ballPointer=ballViewArray[i];
        // Lock the paddle.
        [self lockPaddle];
        // Get various variables we need to manipulate.
        float bounceAngle;
        int potentialScore=0;
        float xbounce=ballPointer.xBounce;
        float bounce=ballPointer.bounce;
        CGRect ballPointerRect = ballPointer.rect;
        int ballHitCounter = ballPointer.ballHitCounter;
        int ballHitCounterTop = ballPointer.ballHitCounterTop;
        int ballHitCounterLeft = ballPointer.ballHitCounterLeft;
        int ballHitCounterRight = ballPointer.ballHitCounterRight;
        int ballHitCounterScore = ballPointer.ballHitCounterScore;
        CGRect paddleRect = CGRectMake(paddleCenter.x-paddleSize/2, paddleCenter.y-paddleSize/2, paddleSize, paddleSize);
        CGRect paddleRectangle = paddleRect;
        
        // Get intersection of paddle and ball.
        CGRect intersectRect = CGRectIntersection(paddleRect, ballPointerRect);
        
        // If there is a powerup on the screen and we intersected it.
        if (powerUpEnabled == 1 && CGRectIntersectsRect(powerup.rectangle.rect, ballPointerRect)) {
            // We intersected the first power-up.
            if ((powerup.whichPowerUp == RPBPowerUpTypeSpeedUp) || (brickIntersectionEnablePowerUp==YES&&powerUpAbsorbedTemp==1)) {
                powerUpEnabledEnabled = 1;
                brickIntersectionEnablePowerUp=NO;
                if (whichBrick!=4) {
                    [randomBrickArray[whichBrick] setPowerUpAbsorbed:0];
                }
                whichBrick=4;
                powerUpAbsorbed=0;
                didStartStartPowerUp = 1;
                scoreMultiplier = 3.0f;
                powerUpEnabled = 0;
                speedBounce = speedBounce+2;
                int k;
                for (k=0; k<ballViewArray.count; k++) {
                    RPBBall *ballPointer2=ballViewArray[k];
                    [ballPointer2 speedUpBall];
                }
                speedMultiplier=(1+speedBounce);
                self.powerUpStartedTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpEndPowerUp:) userInfo:nil repeats:YES];
                [powerUpStartedTimer fire];
                [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile2];
                return;
            }
            // We intersected the second power-up.
            if ((powerup.whichPowerUp == RPBPowerUpTypeSlowDown) || (brickIntersectionEnablePowerUp==YES&&powerUpAbsorbedTemp == 2)) {
                powerUpEnabledEnabled = 1;
                brickIntersectionEnablePowerUp=NO;
                if (whichBrick!=4) {
                    [randomBrickArray[whichBrick] setPowerUpAbsorbed:0];
                }
                whichBrick=4;
                powerUpAbsorbed=0;
                didStartStartPowerUp = 1;
                scoreMultiplier = 2.0f;
                powerUpEnabled = 0;
                speedBounce = speedBounce-2;
                int k;
                for (k=0; k<ballViewArray.count; k++) {
                    RPBBall *ballPointer2=ballViewArray[k];
                    [ballPointer2 slowDownBall];
                }
                speedMultiplier=(1+speedBounce);
                self.powerUpStartedTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpEndPowerUp:) userInfo:nil repeats:YES];
                [powerUpStartedTimer fire];
                [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile3];
                return;
            }
            
            // We intersected the ball split powerup.
            if ((powerup.whichPowerUp == RPBPowerUpTypeSplitBall) || (brickIntersectionEnablePowerUp==YES&&powerUpAbsorbedTemp == 3)) {
                brickIntersectionEnablePowerUp=NO;
                if (whichBrick!=4) {
                    [randomBrickArray[whichBrick] setPowerUpAbsorbed:0];
                }
                whichBrick=4;
                powerUpAbsorbed=0;
                powerUpEnabled = 0;
                RPBBall *currentBall = ballViewArray[i];
                RPBBall *newBall=[[RPBBall alloc] init];
                newBall.rect=CGRectMake(ballPointerRect.origin.x-(ballPointerRect.size.width+1), ballPointerRect.origin.y, ballPointerRect.size.width, ballPointerRect.size.height);
                newBall.bounce=currentBall.bounce;
                newBall.xBounce=-(currentBall.xBounce);
                newBall.speedMultiplier=currentBall.speedMultiplier;
                newBall.projectMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, self.view.frame.size.height, 0, -1024, 1024);
                newBall.multiplyFactor = currentBall.multiplyFactor;
                [ballViewArray addObject:newBall];
                // Play the power up sound.
                [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile4];
            }
            
            // We intersected the fourth power-up.
            if ((powerup.whichPowerUp == RPBPowerUpTypeChangeWall) || (brickIntersectionEnablePowerUp==YES&&powerUpAbsorbedTemp == 4)) {
                brickIntersectionEnablePowerUp=NO;
                if (whichBrick!=4) {
                    [randomBrickArray[whichBrick] setPowerUpAbsorbed:0];
                }
                whichBrick=4;
                powerUpAbsorbed=0;
                powerUpEnabled = 0;
                didStartStartPowerUp=1;
                powerUpEnabledEnabled=1;
                int oldWallToLose=wallToLose;
                while (oldWallToLose==wallToLose||wallToLose==wallEnabled) {
                    wallToLose = (arc4random() % 4) + 1;
                    walls.wallToLose = wallToLose;
                }
                scoreMultiplier=4.0f;
                self.loseWallChangeTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(loseTimeChangeWall:) userInfo:nil repeats:YES];
                didStartLoseWall=YES;
                [loseWallChangeTimer fire];
            }
        }
        
        // We intersected the left wall.
        if (CGRectIntersectsRect(walls.leftWall.rect, ballPointerRect)) {
            ballHitCounterLeft = ballHitCounterLeft+1;
            // We hit the losing wall.
            if (walls.wallToLose==1) {
                if (ballViewArray.count==1) {
                    [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
                    return;
                } else {
                    [ballViewArray removeObjectAtIndex:i];
                    return;
                }
            } else {
                if (ballHitCounterRight<=1)
                {
                    [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile1];
                    xbounce = -xbounce;
                    xbounce = xbounce+0.01f;
                    if (walls.wallToEnable == 1) {
                        potentialScore += (250*scoreMultiplier);
                    } else {
                        potentialScore += (10*scoreMultiplier);
                }
            }
            ballHitCounterScore = ballHitCounterScore + 1;
            }
            if(ballHitCounterLeft>=5)
            {
                return;
            }
        } else {
            ballHitCounterLeft=0;
        }
        if (CGRectIntersectsRect(walls.rightWall.rect, ballPointerRect)) {
            ballHitCounterRight= ballHitCounterRight+1;
            if (walls.wallToLose==3) {
                if (ballViewArray.count==1) {
                    [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
                    return;
                } else {
                    [ballViewArray removeObjectAtIndex:i];
                    return;
                }
            } else {
                if (ballHitCounterRight<=1)
                {
                    xbounce = -xbounce;
                    xbounce = xbounce+0.01f;
                    [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile1];
                    if (walls.wallToEnable == 3) {
                        potentialScore += (250*scoreMultiplier);
                    } else {
                        potentialScore += (10*scoreMultiplier);
                    }
                    ballHitCounterScore = ballHitCounterScore + 1;
                }
                if(ballHitCounterRight>=5)
                {
                    return;
                }
            }
        } else {
            ballHitCounterRight=0;
        }
        if (CGRectIntersectsRect(walls.bottomWall.rect, ballPointerRect)) {
            if (walls.wallToLose==4) {
                if (ballViewArray.count==1) {
                    [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
                        return;
                    } else {
                        [ballViewArray removeObjectAtIndex:i];
                        return;
                    }
            } else {
                bounce = -bounce;
                bounce = bounce +0.01f;
                [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile1];
                if (walls.wallToEnable == 6) {
                    potentialScore += (250*scoreMultiplier);
                } else {
                    potentialScore += (10*scoreMultiplier);
                }
                ballHitCounterScore = ballHitCounterScore + 1;
            }
        }
        if (CGRectIntersectsRect(walls.topWall.rect, ballPointerRect)) {
            ballHitCounterTop = ballHitCounterTop+1;
            if (walls.wallToLose==2) {
                if (ballViewArray.count==1) {
                    [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
                    return;
                } else {
                    [ballViewArray removeObjectAtIndex:i];
                    return;
                }
            } else {
                if (ballHitCounterTop<=1)
                {
                    bounce = -bounce;
                    bounce = bounce +0.01f;
                    [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile1];
                    if (walls.wallToEnable == 2) {
                        potentialScore += (250*scoreMultiplier);
                    } else {
                        potentialScore += (10*scoreMultiplier);
                    }
                        ballHitCounterScore = ballHitCounterScore + 1;
                    }
                }
                if(ballHitCounterTop>=5)
                {
                    return;
                }
        } else {
            ballHitCounterTop=0;
        }
        // Random bricks are on the screen
        if (randomBrickIsEnabled) {
            // Go through each one.
            for (int i=0; i<randomBrickArray.count; i++) {
                // Get it and where it is on the screen.
                RPBRandomRect *randomRect = randomBrickArray[i];
                CGRect rectOfBrick = randomRect.rectOfView;
                //
                if (CGRectIntersectsRect(ballPointerRect, rectOfBrick)) {
                    if (randomBrickHitCounter<=1) {
                        CGRect intersectRect = CGRectIntersection(rectOfBrick, ballPointerRect);
                        if (CGRectIntersectsRect(randomRect.bottomRectBall, ballPointerRect)&&CGRectIntersectsRect(randomRect.bottomRectBall, paddleRect)) {
                            dontmoveUp=YES;
                        } else {
                            dontmoveUp=NO;
                        }
                        if (CGRectIntersectsRect(randomRect.topRectBall, ballPointerRect)&&CGRectIntersectsRect(randomRect.topRectBall, paddleRect)) {
                            dontmoveDown=YES;
                        } else {
                            dontmoveDown=NO;
                        }
                        // Don't let the paddle move if we are wedged between the ball and the paddle.
                        if ((CGRectIntersectsRect(randomRect.topRectBall, ballPointerRect)||CGRectIntersectsRect(randomRect.bottomRectBall, ballPointerRect)||CGRectIntersectsRect(randomRect.leftRectBall, ballPointerRect)||CGRectIntersectsRect(randomRect.rightRectBall, ballPointerRect))&&(CGRectIntersectsRect(randomRect.topRectBall, paddleRect)||CGRectIntersectsRect(randomRect.bottomRectBall, paddleRect)||CGRectIntersectsRect(randomRect.leftRectBall, paddleRect)||CGRectIntersectsRect(randomRect.rightRectBall, paddleRect))) {
                            dontmove=YES;
                        } else {
                            dontmove=NO;
                        }
                        // We are intesecting the top.
                        if (CGRectIntersectsRect(randomRect.topRect, ballPointerRect)&&intersectRect.size.width>intersectRect.size.height) {
                            CGRect tempRect4=ballPointer.rect;
                            tempRect4.origin.y=(randomRect.topRect.origin.y-(ballPointerRect.size.height+3));
                            bounce=-bounce+0.1f;
                            ballPointer.rect=tempRect4;
                            ballPointerRect=ballPointer.rect;
                        }
                        // We are intersecting the bottom.
                        if (CGRectIntersectsRect(randomRect.bottomRect, ballPointerRect)&&intersectRect.size.width>intersectRect.size.height) {
                            CGRect tempRect4=ballPointer.rect;
                            tempRect4.origin.y=(randomRect.bottomRect.origin.y+3);
                            bounce=-bounce+0.1f;
                            ballPointer.rect=tempRect4;
                            ballPointerRect=ballPointer.rect;
                        }
                        // We are intersecting the left side.
                        if (CGRectIntersectsRect(randomRect.leftRect, ballPointerRect)&&intersectRect.size.width<intersectRect.size.height) {
                            CGRect tempRect4=ballPointer.rect;
                            tempRect4.origin.x=(randomRect.leftRect.origin.x-(ballPointerRect.size.height+3));
                            xbounce=-xbounce+0.1f;
                            ballPointer.rect=tempRect4;
                            ballPointerRect=ballPointer.rect;
                        }
                        // We are intersecting the right.
                        if (CGRectIntersectsRect(randomRect.rightRect, ballPointerRect)&&intersectRect.size.width<intersectRect.size.height) {
                            CGRect tempRect4=ballPointer.rect;
                            tempRect4.origin.x=(randomRect.rightRect.origin.x+3);
                            xbounce=-xbounce+0.1f;
                            ballPointer.rect=tempRect4;
                            ballPointerRect=ballPointer.rect;
                        }
                        if (whichBrick==i&&randomRect.powerUpAbsorbed!=0) {
                            brickIntersectionEnablePowerUp=YES;
                            powerUpAbsorbedTemp=randomRect.powerUpAbsorbed;
                        }
                        potentialScore += 20;
                        [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile1];
                    }
                    randomBrickHitCounter +=1;
                } else if(!CGRectIntersectsRect(ballPointerRect, rectOfBrick)) {
                    randomBrickHitCounter=0;
                }
            }
        }
        // We hit the paddle.
        if (!CGRectIsNull(intersectRect)) {
            if (ballHitCounterScore<1)
            {
                isPlaying = YES;
                // Get the center of the collision and convert it to the paddle's coordinate system.
                float whereBallHit = ((paddleRect.origin.x + paddleRect.size.width/2) - (intersectRect.origin.x+(intersectRect.size.width/2)));
                float whereBallHitY = ((paddleRect.origin.y + paddleRect.size.height/2) - (intersectRect.origin.y+(intersectRect.size.height/2)));
                // Our score to reward the player.
                potentialScore += (20*scoreMultiplier);
                // Get the hit location as a ratio.
                float ratioX=(whereBallHit/(paddleRect.size.width/2));
                float ratioY=(whereBallHitY/(paddleRect.size.height/2));
                bounceAngle=((60.0f*(M_PI/180)));
                // Get our ball trajectory.
                if (ABS(ratioX) < ABS(ratioY)) {
                    xbounce = sinf(bounceAngle * ratioX);
                    bounce = cosf(bounceAngle * ratioX) * ratioY;
                } else {
                    xbounce = cosf(bounceAngle * ratioY) * ratioX;
                    bounce = sinf(bounceAngle * ratioY);
                }
                // Apply speed multiplier.
                bounce *=ballPointer.speedMultiplier;
                xbounce *=ballPointer.speedMultiplier;
                // Play our audio.
                [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile1];
            }
            // Increment ball counters.
            ballHitCounterScore = ballHitCounterScore + 1;
            ballHitCounter = ballHitCounter+1;
        }
        else if (!CGRectIntersectsRect(paddleRectangle, ballPointerRect)){
            ballHitCounter=0;
        }
        // Check for cheating.
        if((!(CGRectIntersectsRect(noScoreZone, paddleRectangle) && CGRectIntersectsRect(noScoreZone, ballPointerRect))&&!(CGRectIntersectsRect(noScoreZone2, paddleRectangle) && CGRectIntersectsRect(noScoreZone2, ballPointerRect))&&!(CGRectIntersectsRect(noScoreZone3, paddleRectangle) && CGRectIntersectsRect(noScoreZone3, ballPointerRect))&&!(CGRectIntersectsRect(noScoreZone4, paddleRectangle) && CGRectIntersectsRect(noScoreZone4, ballPointerRect))))
        {
            score += potentialScore;
        
        }
        // Update the ball with our newly calculated information.
        ballPointer.xBounce=xbounce;
        ballPointer.bounce=bounce;
        ballPointer.ballHitCounter=ballHitCounter;
        ballPointer.ballHitCounterTop=ballHitCounterTop;
        ballPointer.ballHitCounterLeft=ballHitCounterLeft;
        ballPointer.ballHitCounterRight=ballHitCounterRight;
        ballViewArray[i] = ballPointer;
        [self unlockPaddle];
        ballPointerRect.origin.y=ballPointerRect.origin.y-ballPointer.bounce;
        ballPointerRect.origin.x=ballPointerRect.origin.x-ballPointer.xBounce;
        ballPointer.rect=ballPointerRect;
        if (!(CGRectIntersectsRect(paddleRectangle, ballPointerRect)||CGRectIntersectsRect(ballPointerRect, topOfScreen)||CGRectIntersectsRect(ballPointerRect, leftOfScreen)||CGRectIntersectsRect(ballPointerRect, rightOfScreen)||CGRectIntersectsRect(ballPointerRect, bottomOfScreen))) {
            ballHitCounterScore=0;
        }
        scoreField.text=[NSString localizedStringWithFormat:NSLocalizedString(@"SCORE:", nil), score];
        ballViewArray[i] = ballPointer;
    }
}
// Our function to put random bricks on the screen.
-(void)randomBrickTimerFire:(NSTimer *)theTimer
{
    if (randomBrickDidStart==YES) {
        randomBrickDidStart=NO;
        return;
    }
    if(randomBrickIsEnabled==NO)
    {
        int i;
        for (i=0;i<3;i++) {
            [randomBrickArray addObject:[[RPBRandomRect alloc] init]];
            CGRect randomRect = [self randomRectangle2:i count:0];
            if (randomBrickFailed) {
                return;
            }
            // Create a new random rect and set it up, and add it to the view.
            ((RPBRandomRect *)randomBrickArray[i]).projectMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, self.view.frame.size.height, 0, -1024, 1024);
            if (powerUpAbsorbed!=0) {
                ((RPBRandomRect *)randomBrickArray[i]).color = [UIColor redColor];
                powerUpEnabled=1;
                ((RPBRandomRect *)randomBrickArray[i]).powerUpAbsorbed = powerUpAbsorbed;
            } else {
                ((RPBRandomRect *)randomBrickArray[i]).color = [UIColor greenColor];
            }
            [randomBrickArray[i] setRectOfView:randomRect];
            if(i==1) {
                randomRect1=randomBrickArray[i];
            } else if(i==2) {
                randomRect2=randomBrickArray[i];
            } else if(i==3) {
                randomRect3=randomBrickArray[i];
            }
        }
        randomBrickIsEnabled=YES;
        return;
    }
    if(randomBrickIsEnabled==YES) {
        int i;
        for (i=0;i<3;i++) {
            [randomBrickArray removeObjectAtIndex:0];
        }
        randomBrickIsEnabled=NO;
        powerUpAbsorbed=0;
        whichBrick=4;
    }
}
// Ends the game.
-(void)theEnd
{
    _gameOver = YES;
    [self lostGame];
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] setScore:score];
    [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] endGame];
    UIStoryboard *theStoryboard;
    if([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        theStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPad" bundle:nil];
    } else {
        theStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPhone" bundle:nil];
    }
    for (AVAudioPlayer *thePlayer in self.audioPlayers) {
        thePlayer.delegate = nil;
    }
    GameOverViewController *gameOver = [theStoryboard instantiateViewControllerWithIdentifier:@"GameOverScene"];
    UINavigationController *naviControl = self.navigationController;
    NSMutableArray *viewControllerArray = [NSMutableArray arrayWithArray:naviControl.viewControllers];
    [viewControllerArray removeLastObject];
    [viewControllerArray addObject:gameOver];
    naviControl.viewControllers = viewControllerArray;
}
-(IBAction)createNewGame:(UIStoryboardSegue *)sender {
    
}
-(void)playSound:(NSData *)soundData
{
    @autoreleasepool {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBSound"]== NO) {
            return;
        }
        if(isPlaying==YES&&playcount>=10)
        {
            return;
        }
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData  error:nil];
        if (audioPlayer==nil) {
            return;
        }
        [self.audioPlayers addObject:audioPlayer];
        if (soundData==self.audioFile1) {
            audioPlayer.volume=0.0625f;
        } else {
            audioPlayer.volume = 1.0f;
        }
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
        [audioPlayer play];
        isPlaying=YES;
        playcount=playcount+1;
    }
}
// Do cleanup after playing a sound.
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    isPlaying=NO;
    playcount=playcount-1;
    [self.audioPlayers removeObject:player];
}
-(void)wallScoreBoostEnableOrDisable:(NSTimer *)theTimer
{
    if (justStartedWallTimer == YES) {
        justStartedWallTimer = NO;
        return;
    }
    if(wallEnabled == NO)
    {
        wallToEnable = (rand() % 3) + 1;
        walls.wallToEnable = wallToEnable;
        [wallScoreBoostTimer invalidate];
        self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
        justStartedWallTimer = YES;
        [wallScoreBoostTimer fire];
        wallEnabled = YES;
    } else if (wallEnabled == YES) {
        // Change wall back
        wallToEnable = 0;
        walls.wallToEnable = wallToEnable;
        [wallScoreBoostTimer invalidate];
        self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:[self randomTimerTime] target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
        justStartedWallTimer = YES;
        [wallScoreBoostTimer fire];
        wallEnabled = NO;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Return if the paddle is locked.
    if(paddleLocked == 1) {
        return;
    }
    BOOL dontsety=NO;
    BOOL dontsetx=NO;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.mainView];
    CGRect tempRect;
    tempRect.origin.x=location.x-(paddleSize/2);
    tempRect.origin.y=location.y-(paddleSize/2);
    tempRect.size=CGSizeMake(paddleSize, paddleSize);
    CGPoint paddleImagePointTemp = location;
    paddleImagePointTemp = location;
    int i;
    if (CGRectIntersectsRect(tempRect, topOfScreenBall)) {
        paddleImagePointTemp.y = topOfScreenBall.size.height+((paddleSize/2)+wallSize);
    }
    if (CGRectIntersectsRect(tempRect, bottomOfScreenBall)) {
        paddleImagePointTemp.y = bottomOfScreenBall.origin.y-(paddleSize/2);
        
    } if (CGRectIntersectsRect(tempRect, leftOfScreenBall)) {
        paddleImagePointTemp.x = leftOfScreenBall.size.width+((paddleSize/2)+wallSize);
        
    } if(CGRectIntersectsRect(tempRect, rightOfScreenBall)){
        paddleImagePointTemp.x = rightOfScreenBall.origin.x-(paddleSize/2);
    }
    BOOL goThroughAgain, goThroughAgain2;
    goThroughAgain=NO;
    goThroughAgain2=NO;
    BOOL skip4jump=NO;
    CGRect tempRect2;
    tempRect2.origin.x=paddleImagePointTemp.x-(paddleSize/2);
    tempRect2.origin.y=paddleImagePointTemp.y-(paddleSize/2);
    tempRect2.size=CGSizeMake(paddleSize, paddleSize);
    BOOL stillIntersecting=YES;
    for (i=0; (i<randomBrickArray.count&&(stillIntersecting==YES)); i++) {
        RPBRandomRect *brickPointer = randomBrickArray[i];
        if (CGRectIntersectsRect(brickPointer.rectOfView, tempRect2)) {
            tempRect2.origin.x=paddleImagePointTemp.x-(paddleSize/2);
            tempRect2.origin.y=paddleImagePointTemp.y-(paddleSize/2);
            tempRect2.size=CGSizeMake(paddleSize, paddleSize);
            CGRect intersectRect = CGRectIntersection(brickPointer.rectOfView, tempRect);
            if (((CGRectIntersectsRect(brickPointer.topRect, tempRect2))||(CGRectIntersectsRect(brickPointer.bottomRect, tempRect2)))&&((CGRectIntersectsRect(brickPointer.leftRect, tempRect2))||(CGRectIntersectsRect(brickPointer.rightRect, tempRect2)))) {
                return;
            }
            if ((CGRectIntersectsRect(brickPointer.topRect, tempRect2))&&CGRectIntersectsRect(topOfScreenBall, tempRect2)) {
                return;
            }
            if ((CGRectIntersectsRect(brickPointer.bottomRect, tempRect2))&&CGRectIntersectsRect(bottomOfScreenBall, tempRect2)) {
                return;
            }
            if ((CGRectIntersectsRect(brickPointer.leftRect, tempRect))&&CGRectIntersectsRect(leftOfScreenBall, tempRect2)) {
                return;
            }
            if ((CGRectIntersectsRect(brickPointer.rightRect, tempRect2))&&CGRectIntersectsRect(rightOfScreenBall, tempRect2)) {
                return;
            }
            if (CGRectIntersectsRect(brickPointer.topRect, tempRect2)&&(intersectRect.size.width>intersectRect.size.height)&&!dontsety) {
                //paddleImagePointTemp.x=paddleImagePointTemp.x;
                if (((CGRectIntersectsRect(randomRect1.rectOfView, tempRect2)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect1.rectOfView))||(CGRectIntersectsRect(randomRect2.rectOfView, tempRect2)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect2.rectOfView))||(CGRectIntersectsRect(randomRect3.rectOfView, tempRect2)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect3.rectOfView)))){
                    //return;
                    RPBLog(@"Condition Met");
                }
                velocityLockEnabled=YES;
                velocitySignY=NO;
                paddleImagePointTemp.y=brickPointer.topRect.origin.y-(paddleSize/2);
                //dontsety=YES;
            }
            if(CGRectIntersectsRect(brickPointer.bottomRect, tempRect2)&&(intersectRect.size.width>intersectRect.size.height)&&!dontsety) {
                //paddleImagePointTemp.x=paddleImagePointTemp.x;
                if (((CGRectIntersectsRect(randomRect1.rectOfView, tempRect2)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect1.rectOfView))||(CGRectIntersectsRect(randomRect2.rectOfView, tempRect2)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect2.rectOfView))||(CGRectIntersectsRect(randomRect3.rectOfView, tempRect2)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect3.rectOfView)))){
                    //return;
                    RPBLog(@"Condition Met");
                }
                velocityLockEnabled=YES;
                velocitySignY=YES;
                paddleImagePointTemp.y=brickPointer.bottomRect.origin.y+(paddleSize/2);
                //dontsety=YES;
            }
            if (CGRectIntersectsRect(brickPointer.leftRect, tempRect2)&&(intersectRect.size.height>intersectRect.size.width)&&!dontsetx) {
                //paddleImagePointTemp.y=paddleImagePointTemp.y;
                if (((CGRectIntersectsRect(randomRect1.rectOfView, tempRect2)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect1.rectOfView))||(CGRectIntersectsRect(randomRect2.rectOfView, tempRect2)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect2.rectOfView))||(CGRectIntersectsRect(randomRect3.rectOfView, tempRect2)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect3.rectOfView)))){
                    //return;
                    RPBLog(@"Condition Met");
                }
                velocityLockEnabled=YES;
                velocitySignX=YES;
                paddleImagePointTemp.x=brickPointer.leftRect.origin.x-(paddleSize/2);
                //dontsetx=YES;
            }
            if (CGRectIntersectsRect(brickPointer.rightRect, tempRect2)&&(intersectRect.size.height>intersectRect.size.width)&&!dontsetx) {
                //paddleImagePointTemp.y=paddleImagePointTemp.y;
                if (((CGRectIntersectsRect(randomRect1.rectOfView, tempRect2)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect1.rectOfView))||(CGRectIntersectsRect(randomRect2.rectOfView, tempRect2)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect2.rectOfView))||(CGRectIntersectsRect(randomRect3.rectOfView, tempRect2)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect3.rectOfView)))){
                    //return;
                    RPBLog(@"Condition Met");
                }
                velocityLockEnabled=YES;
                velocitySignX=NO;
                paddleImagePointTemp.x=brickPointer.rightRect.origin.x+(paddleSize/2);
                //dontsetx=YES;
            }
            if (CGRectIntersectsRect(tempRect2, topOfScreenBall)) {
                paddleImagePointTemp.y = topOfScreenBall.size.height+((paddleSize/2)+wallSize);
                //dontsety=YES;
                //paddleImagePointTemp.x = location.x;
            }
            if (CGRectIntersectsRect(tempRect2, bottomOfScreenBall)) {
                paddleImagePointTemp.y = bottomOfScreenBall.origin.y-(paddleSize/2);
                //dontsety=YES;
                //paddleImagePointTemp.x = location.x;
            } if (CGRectIntersectsRect(tempRect2, leftOfScreenBall)) {
                paddleImagePointTemp.x = leftOfScreenBall.size.width+((paddleSize/2)+wallSize);
                //dontsetx=YES;
                //paddleImagePointTemp.y = location.y;
            } if(CGRectIntersectsRect(tempRect2, rightOfScreenBall)){
                paddleImagePointTemp.x = rightOfScreenBall.origin.x-(paddleSize/2);
                //dontsetx=YES;
                //paddleImagePointTemp.y = location.y;
            }
            tempRect2.origin.x=paddleImagePointTemp.x-(paddleSize/2);
            tempRect2.origin.y=paddleImagePointTemp.y-(paddleSize/2);
            tempRect2.size=CGSizeMake(paddleSize, paddleSize);
        }
    }
    if (goThroughAgain==YES&&goThroughAgain2==YES) {
        skip4jump=YES;
    }
    for (i=0; i<ballViewArray.count; i++) {
        RPBBall *ballPointer = ballViewArray[i];
        CGRect intersectRect = CGRectIntersection(tempRect, ballPointer.rect);
        if (!CGRectIsNull(intersectRect)) {
            return;
        }
    }
    paddleCenter=paddleImagePointTemp;
    tempRect = CGRectMake(paddleImagePointTemp.x-(paddleSize/2), paddleImagePointTemp.y-(paddleSize/2), paddleSize, paddleSize);
    self.paddle.rect = tempRect;
    
    
    leftTopRect = CGRectMake(tempRect.origin.x, tempRect.origin.y-4, (paddleSize/2), 4);
    rightTopRect = CGRectMake(tempRect.origin.x+(paddleSize/2), tempRect.origin.y-4, (paddleSize/2), 4);
    leftBottomRect = CGRectMake(tempRect.origin.x, tempRect.origin.y+paddleSize+4, (paddleSize/2), 4);
    rightBottomRect = CGRectMake(tempRect.origin.x+(paddleSize/2), tempRect.origin.y+paddleSize+4, (paddleSize/2), 4);
    upperLeftRect = CGRectMake(tempRect.origin.x-4, tempRect.origin.y, 4, (paddleSize/2));
    lowerLeftRect = CGRectMake(tempRect.origin.x-4, tempRect.origin.y+(paddleSize/2), 4, (paddleSize/2));
    upperRightRect = CGRectMake(tempRect.origin.x+paddleSize, tempRect.origin.y, 4, (paddleSize/2));
    lowerRightRect = CGRectMake(tempRect.origin.x+paddleSize, tempRect.origin.y+(paddleSize/2), 4, (paddleSize/2));
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesBegan:touches withEvent:event];
}
-(void)releaseBallTimer
{
	[timerToRelease invalidate];
}
-(void)powerUpCreate:(NSTimer *)theTimer
{
    // If this is the first time the timer fired, then set did start to 0 and get out of here.
	if(didStartPowerUp == 1)
	{
		didStartPowerUp = 0;
		return;
	}
    
    // If the powerup is already on the screen, then get out of here.
	if (powerUpEnabledEnabled ==1) {
		return;
	}
    
    // If we don't have a powerup on the screen.
	if(powerUpEnabled == 0)
	{
        // Then update for a random location on the screen, and randomize the powerup.
        powerup.rectangle.rect = [self randomRectangle];
        [powerup randomizePowerup];
        powerUpEnabled = 1;
	} else {
        // Disable the power up from the screen.
		powerUpEnabled=0;
	}
}
-(IBAction)pauseGame:(id)sender
{
    if(isPaused == 1)
    {
        return;
    }
    if (sender == [CoreGraphicsDrawingAppDelegate sharedAppDelegate]) {
        _pausedAtUI = NO;
    } else {
        _pausedAtUI = YES;
    }
	[speedTimer invalidate];
	[powerUpTimer invalidate];
    if (loseWallChangeTimer.valid) {
        [loseWallChangeTimer invalidate];
    }
    lastTimeUpdate=0;
	if (powerUpStartedTimer.valid) {
		NSDate *fireTime = powerUpStartedTimer.fireDate;
		fireTimeInterval = fireTime.timeIntervalSinceNow;
		[powerUpStartedTimer invalidate];
	}
    [wallScoreBoostTimer invalidate];
    [randomBrickTimer invalidate];
    randomBrickDidStart = YES;
	[self lockPaddle];
	didStartStartPowerUp = 1;
	didInvalidate = 1;
	isPaused = 1;
    pauseButton.enabled=NO;
    self.paused = YES;
	[self.mainView addSubview:pauseView];
}
-(void)loseTimeChangeWall:(NSTimer *)theTimer
{
    if (didStartLoseWall==YES) {
        didStartLoseWall=NO;
        return;
    }
    //RPBLog(@"wallToLose:%i", wallToLose);
    wallToLose=4;
    walls.wallToLose = wallToLose;
    scoreMultiplier=1.0f;
    [mainView setNeedsDisplay];
    [theTimer invalidate];
    powerUpEnabledEnabled=0;
}
-(IBAction)endGame:(id)sender
{
    [pauseView removeFromSuperview];
    [mainView addSubview:areYouSureView];
	
}
-(IBAction)yesClicked:(id)sender
{
    [areYouSureView removeFromSuperview];
    [self theEnd];
}
-(IBAction)noClicked:(id)sender
{
    [areYouSureView removeFromSuperview];
    [mainView addSubview:pauseView];
}
-(IBAction)resumeGame:(id)sender
{
	didStart = 1;
	didStartPowerUp = 1;
	self.speedTimer = [NSTimer scheduledTimerWithTimeInterval:10.00 target:self selector:@selector(speedUp:) userInfo:nil repeats:YES];
	[speedTimer fire];
	powerUpTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpCreate:) userInfo:nil repeats:YES];
	[powerUpTimer fire];
    randomBrickTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(randomBrickTimerFire:) userInfo:nil repeats:YES];
    [randomBrickTimer fire];
    if (powerUpEnabledEnabled==1 && powerup.whichPowerUp==4) {
        didStartLoseWall=YES;
        self.loseWallChangeTimer=[NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(loseTimeChangeWall:) userInfo:nil repeats:YES];
        [loseWallChangeTimer fire];
    }
    if (wallEnabled == YES) {
        self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
    } else {
        self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:[self randomTimerTime] target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
    }
    justStartedWallTimer = YES;
    [wallScoreBoostTimer fire];
    [self unlockPaddle];
	if (powerUpEnabledEnabled == 1) {
		self.powerUpStartedTimer = [NSTimer scheduledTimerWithTimeInterval:fireTimeInterval target:self selector:@selector(powerUpEndPowerUp:) userInfo:nil repeats:YES];
		[powerUpStartedTimer fire];
	}
	didInvalidate = 0;
	isPaused = 0;
    pauseButton.enabled=YES;
    self.paused = NO;
	[pauseView removeFromSuperview];
}

// Slightly speed up the ball.
-(void)speedUp:(NSTimer *)theTimer
{
	if (didStart == 1)
	{
		didStart = 0;
		return;
	}
	if (powerUpEnabledEnabled == 1) {
		return;
	}
    int i;
    for(i=0; i<ballViewArray.count; i++)
    {
        RPBBall *ballPointer=ballViewArray[i];
        ballPointer.xBounce=ballPointer.xBounce/ballPointer.speedMultiplier;
        ballPointer.bounce=ballPointer.bounce/ballPointer.speedMultiplier;
        ballPointer.speedMultiplier=ballPointer.speedMultiplier+.75f;
        ballPointer.xBounce=ballPointer.xBounce*ballPointer.speedMultiplier;
        ballPointer.bounce=ballPointer.bounce*ballPointer.speedMultiplier;
    }
	speedBounce = speedBounce + .5;
}

// End the power that was on the screen.
-(void)powerUpEndPowerUp:(NSTimer *)theTimer
{
	if (didStartStartPowerUp == 1) {
		didStartStartPowerUp = 0;
		return;
	}
    // Loop through for each ball, and if we have modified the speed of the ball,
    // then bring it back to normal.
    int k;
    for (k=0; k<ballViewArray.count; k++) {
        RPBBall *ballPointer=ballViewArray[k];
        if (powerup.whichPowerUp == RPBPowerUpTypeSpeedUp) {
            [ballPointer undoSpeedUp];
        } else if (powerup.whichPowerUp == RPBPowerUpTypeSlowDown) {
            [ballPointer undoSlowDown];
        }
    }
    // Disable the powerup and invalidate ourself.
	powerUpEnabledEnabled = 0;
	scoreMultiplier = 1.0f;
	[theTimer invalidate];
}
-(void)lostGame
{
    // Tear down all timers and shut down OpenGL rendering.
	[ballTimer invalidate];
	[speedTimer invalidate];
	[powerUpTimer invalidate];
	if (powerUpStartedTimer.valid) {
		[powerUpStartedTimer invalidate];
	}
    powerUpEnabled=0;
    [randomBrickTimer invalidate];
    [wallScoreBoostTimer invalidate];
    [pauseButton setEnabled:YES];
	didInvalidate = 1;
	isPaused = 1;
    [self tearDownGL];
}
-(void)newGame
{
    // Reset various variables back to their normal state.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.paused = YES;
    isPlaying=NO;
    _gameOver = NO;
    whichBrick=4;
    powerUpAbsorbed=0;
    playcount=0;
    randomBrickFailed=NO;
    brickIntersectionEnablePowerUp=NO;
    randomBrickIsEnabled=NO;
    didStartLoseWall=YES;
    wallToLose=4;
    wallToEnable = 0;
    doSlowDown=NO;
    score=0;
    didStart = 1;
    didStartPowerUp = 1;
    difficultyMultiplier = [[NSUserDefaults standardUserDefaults] doubleForKey:@"RPBDifficultyMultiplier"];
    didInvalidate = 0;
    isPaused = 0;
    speedBounce = 1.0;
    speedMultiplier=1;
    scoreMultiplier = 1.0f;
    doAddOnToScore = YES;
    wallEnabled = NO;
    justStartedWallTimer = YES;
    
    // Setup OpenGL.
    [self setupGL];
    
    // Setup shaders.
    [RPBRectangle setupShaders];
    
    // Setup various objects on the display.
    ballViewArray = [[NSMutableArray alloc] init];
    randomBrickArray=[[NSMutableArray alloc] init];
    self.audioPlayers = [[NSMutableArray alloc] init];
    CGRect screenSize = [UIScreen mainScreen].bounds;
	CGRect pauseViewRect = pauseView.frame;
	CGRect newPauseViewRect = CGRectMake((screenSize.size.width/2)-138, (screenSize.size.height/2)-121, pauseViewRect.size.width, pauseViewRect.size.height);
	pauseView.frame = newPauseViewRect;
    CGRect areYouSureViewRect = areYouSureView.frame;
	CGRect newAreYouSureViewRect = CGRectMake((screenSize.size.width/2)-121, (screenSize.size.height/2)-104, areYouSureViewRect.size.width, areYouSureViewRect.size.height);
	areYouSureView.frame = newAreYouSureViewRect;
    
    // Set size of ball and paddle for the correct screen size.
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        ballRect.size.width = 20;
        ballRect.size.height = 20;
    } else {
        ballRect.size.width = 10;
        ballRect.size.height = 10;
    }
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        paddleSize=PADDLESIZEIPAD;
    } else {
        paddleSize=PADDLESIZE;
    }
    // Setup verticies.
    float multiplyFactor;
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        multiplyFactor = 2.0f;
    } else {
        multiplyFactor = 1.0f;
    }
    
    // Setup proper images for powerup based off scaling.
    if ([UIScreen mainScreen].scale>1.0f) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            self.powerUpTexture1 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LightningBolt@2x~ipad.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture2 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SlowDown@2x~ipad.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture3 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BallSplit@2x~iPad.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
        } else {
            self.powerUpTexture1 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LightningBolt@2x.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture2 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SlowDown@2x.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture3 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BallSplit@2x.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
        }
    } else {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            self.powerUpTexture1 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LightningBolt~ipad.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture2 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SlowDown~ipad.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture3 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BallSplit~iPad.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
        } else {
            self.powerUpTexture1 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LightningBolt.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture2 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SlowDown.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture3 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BallSplit.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
        }
    }
    CGRect paddleImageRect = CGRectMake(paddleCenter.x-(paddleSize/2), paddleCenter.y-(paddleSize/2), paddleSize, paddleSize);
    paddleImageRect.size.width = paddleSize;
    paddleImageRect.size.height = paddleSize;
    paddleCenter=CGPointMake((screenSize.size.width/2),(screenSize.size.height/2));
    ballRect.origin.x = (screenSize.size.width/2)-5;
    ballRect.origin.y = (paddleCenter.y-paddleSize/2)-(ballRect.size.height/2)-5;
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        wallSize = WALLSIZEIPAD;
        wallBorderSize = WALLBORDERIPAD;
        noscorezone=NOSCOREZONEIPAD;
    } else {
        wallSize = WALLSIZE;
        wallBorderSize = WALLBORDER;
        noscorezone=NOSCOREZONE;
    }
    topOfScreen = CGRectMake(0, 0, screenSize.size.width, wallSize);
	leftOfScreen = CGRectMake(0, 0, wallSize, screenSize.size.height);
	rightOfScreen = CGRectMake((screenSize.size.width-wallSize), 0, wallSize, screenSize.size.height);
	bottomOfScreen = CGRectMake(0, (screenSize.size.height-wallSize), screenSize.size.width, wallSize);
    topOfScreenBall = CGRectMake((wallBorderSize+wallSize), wallSize, screenSize.size.width-((wallBorderSize+wallSize)*2), wallBorderSize);
    leftOfScreenBall = CGRectMake(wallSize, (wallBorderSize+wallSize), wallBorderSize, (screenSize.size.height-((wallBorderSize+wallSize)*2)));
    rightOfScreenBall = CGRectMake((screenSize.size.width-(wallBorderSize+wallSize)), (wallBorderSize+wallSize), wallBorderSize, (screenSize.size.height-((wallBorderSize+wallSize)*2)));
    bottomOfScreenBall = CGRectMake((wallBorderSize+wallSize), (screenSize.size.height-(wallBorderSize+wallSize)), (screenSize.size.width-((wallBorderSize+wallSize)*2)), wallBorderSize);
    noScoreZone = CGRectMake(wallSize,wallSize, screenSize.size.width-(wallSize*2), noscorezone);
    noScoreZone2 = CGRectMake(wallSize, noscorezone+wallSize, noscorezone, screenSize.size.height-(noscorezone*2));
    noScoreZone3 = CGRectMake(wallSize, screenSize.size.height-(noscorezone+wallSize), screenSize.size.width-(wallSize*2), noscorezone);
    noScoreZone4 = CGRectMake(screenSize.size.height-(noscorezone+wallSize), noscorezone+wallSize, noscorezone, screenSize.size.height-(noscorezone*2));
    CGRect tempRect = CGRectMake(paddleCenter.x-(paddleSize/2), paddleCenter.y-(paddleSize/2), paddleSize, paddleSize);
    leftTopRect = CGRectMake(tempRect.origin.x, tempRect.origin.y-4, paddleSize/2, 4);
    rightTopRect = CGRectMake(tempRect.origin.x+(paddleSize/2), tempRect.origin.y-4, (paddleSize/2), 4);
    leftBottomRect = CGRectMake(leftTopRect.origin.x, leftTopRect.origin.y+(paddleSize/2), (paddleSize/2), 4);
    rightBottomRect = CGRectMake(rightTopRect.origin.x, rightTopRect.origin.y+paddleSize, (paddleSize/2), 4);
    upperLeftRect = CGRectMake(tempRect.origin.x-4, tempRect.origin.y, 4, (paddleSize/2));
    lowerLeftRect = CGRectMake(tempRect.origin.x-4, tempRect.origin.y+(paddleSize/2), 4, (paddleSize/2));
    upperRightRect = CGRectMake(tempRect.origin.x+paddleSize, tempRect.origin.y, 4, (paddleSize/2));
    lowerRightRect = CGRectMake(tempRect.origin.x+paddleSize, tempRect.origin.y+(paddleSize/2), 4, (paddleSize/2));
    
    // Setup the paddle.
    self.paddle = [[RPBPaddle alloc] init];
    CGFloat redColorPaddle = [userDefaults floatForKey:@"RPBRedColorPaddle"];
    CGFloat greenColorPaddle = [userDefaults floatForKey:@"RPBGreenColorPaddle"];
    CGFloat blueColorPaddle = [userDefaults floatForKey:@"RPBBlueColorPaddle"];
    self.paddle.color = [UIColor colorWithRed:redColorPaddle/255.0f green:greenColorPaddle/255.0f blue:blueColorPaddle/255.0f alpha:1.0];
    self.paddle.projectMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, self.view.frame.size.height, 0, -1024, 1024);
    self.paddle.rect = CGRectMake(CGRectGetMidX(self.view.frame)-paddleSize/2, CGRectGetMidY(self.view.frame)-paddleSize/2, paddleSize, paddleSize);
    
    // Setup the ball.
    RPBBall *ball1 = [[RPBBall alloc] init];
    ball1.rect=ballRect;
    ball1.xBounce=0.0f;
    ball1.bounce=2.0f;
    ball1.multiplyFactor = multiplyFactor;
    ball1.speedMultiplier *= ball1.multiplyFactor;
    ball1.oldSpeedMultiplier *= multiplyFactor;
    ball1.projectMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, self.view.frame.size.height, 0, -1024, 1024);
    CGFloat redColor = [userDefaults floatForKey:@"RPBRedColorBall"];
    CGFloat greenColor = [userDefaults floatForKey:@"RPBGreenColorBall"];
    CGFloat blueColor = [userDefaults floatForKey:@"RPBBlueColorBall"];
    UIColor *ballColor = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1.0];
    ball1.color = ballColor;
    [ballViewArray addObject:ball1];
    
    // Setup the power up object.
    powerup = [[RPBPowerUp alloc] init];
    powerup.rectangle.projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, self.view.frame.size.height, 0, -1024, 1024);
    
    // Setup the wall.
    walls = [[RPBWall alloc] initWithViewSize:self.view.bounds];
    
    // Setup high scores.
    NSMutableArray *highScoreArray=[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores];
    NSDictionary *highScoreEntry = highScoreArray[0];
    NSNumber *highScoreValue = highScoreEntry[@"RPBScore"];
    if (highScoreValue.intValue!=0) {
        self.highScoreField.text=[NSString stringWithFormat:@"High Score: %d",[highScoreArray[0][@"RPBScore"] intValue],nil];
    }
    
    // Seed random number generator.
	srand((unsigned int)time(NULL));
    
    // Load audio files.
    audioFile1 = [[NSData alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"BallHit" withExtension:@"caf"]];
    audioFile2 = [[NSData alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"RetroPaddleBall FX Lightning" withExtension:@"caf"]];
    audioFile3 = [[NSData alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"RetroPaddleBall Slow Down" withExtension:@"caf"]];
    audioFile4 = [[NSData alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"RetroPaddleBall Ball Splitter" withExtension:@"caf"]];
    randomBrickDidStart=YES;
    randomBrickTimer = [NSTimer scheduledTimerWithTimeInterval:21.0 target:self selector:@selector(randomBrickTimerFire:) userInfo:nil repeats:YES];
    
    // Setup timers and get them going.
    self.speedTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(speedUp:) userInfo:nil repeats:YES];
	self.powerUpTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpCreate:) userInfo:nil repeats:YES];
    double time = [self randomTimerTime];
    self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
	
    // Fire timers.
	[speedTimer fire];
	[powerUpTimer fire];
    [wallScoreBoostTimer fire];
    [randomBrickTimer fire];
    
    // Unpause the game.
    self.paused = NO;
}
// Sets paddle locked variable to 1 (locked).
-(void)lockPaddle
{
	paddleLocked=1;
}
// Sets paddle locked variable to 0 (unlocked).
-(void)unlockPaddle
{
	paddleLocked=0;
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    // Invalidate timers.
	[ballTimer invalidate];
	[speedTimer invalidate];
	[powerUpTimer invalidate];
	[powerUpStartedTimer invalidate];
    [wallScoreBoostTimer invalidate];
}

@end
