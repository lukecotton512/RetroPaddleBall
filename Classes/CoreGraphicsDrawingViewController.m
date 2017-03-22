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

// Size definitions for various objects on the screen.
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
@synthesize mainView, didStart, speedTimer, scoreField, score, pauseView, didInvalidate, isPaused, powerUpEnabled, powerUpTimer, powerUpEnabledEnabled, didStartPowerUp, powerUpStartedTimer, didStartStartPowerUp, scoreMultiplier, fireTimeInterval, difficultyMultiplier, paddleLocked, noScoreZone, noScoreZone2, noScoreZone3, noScoreZone4, wallScoreBoostTimer, wallEnabled, wallToEnable, justStartedWallTimer, isPlaying, soundIsOn, areYouSureView, pauseButton, ballViewArray, audioFile1, audioFile2, audioFile3, playcount, audioFile4, doSlowDown, randomBrickArray, randomBrickTimer, wallToLose, highScoreField, didStartLoseWall, loseWallChangeTimer, randomBrickHitCounter, paddleSize, context;



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



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

// View appeared and disappeared functions.
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
    // The paddle is in the middle of where the random rects go, so get out of here.
    if(CGRectIntersectsRect(RANDOMBRICKAREA, self.paddle.rect)){
        randomBrickFailed = YES;
        return CGRectNull;
    } else {
        randomBrickFailed = NO;
    }
    // We have gone on for too long, so get out of here.
    if (k==19) {
        return CGRectMake(-9999999, -9999999, 0, 0);
    }
    // Some variables.
    float randomNumberx;
    float randomNumbery;
    CGRect randomRect;
    // Generate a random location for the rect.
    // For iPad.
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        if (j==0) {
            randomNumberx = (arc4random() % (214 - 38)) + 38;
            randomNumbery = (arc4random() % (200 - 50)) + 50;
        } else if (j==1) {
            randomNumberx = (arc4random() % (400 - 204)) + 204;
            randomNumbery = (arc4random() % (200 - 50)) + 50;
        } else {
            randomNumberx = (arc4random() % (400 - 38)) + 38;
            randomNumbery = (arc4random() % (500 - 260)) + 260;
        }
        randomRect=CGRectMake(randomNumberx, randomNumbery, 160, 60);
    }
    // For the iPhone.
    else {
        if (j==0) {
            randomNumberx = (arc4random() % (70 - 19)) + 19;
            randomNumbery = (arc4random() % (120 - 50)) + 50;
        } else if (j==1) {
            randomNumberx = (arc4random() % (120 - 101)) + 101;
            randomNumbery = (arc4random() % (120 - 50)) + 50;
        } else {
            randomNumberx = (arc4random() % (150 - 19)) + 19;
            randomNumbery = (arc4random() % (200 - 81)) + 81;
        }
        randomRect=CGRectMake(randomNumberx, randomNumbery, 80, 30);
    }
    // Debug logging.
	RPBLog(@"randomRectangle2: x: %f y: %f j: %i count:%i", randomNumberx, randomNumbery, j, k);
    
    // Loop through all the bricks.
    for (int i=0;i<randomBrickArray.count;i++) {
        // We are in the middle of the paddle.
        if (CGRectIntersectsRect(self.paddle.rect, randomRect)) {
            randomRect=[self randomRectangle2:j count:k+1];
        }
        // Check for an available powerup, and if it is there and we intersect, then absorb it.
        if (powerUpEnabled == 1 && CGRectIntersectsRect(powerup.rectangle.rect, randomRect)) {
            if (powerup.whichPowerUp == RPBPowerUpTypeSpeedUp) {
                powerUpAbsorbed=1;
                whichBrick=j;
            } else if(powerup.whichPowerUp == RPBPowerUpTypeSlowDown){
                powerUpAbsorbed=2;
                whichBrick=j;
            } else if (powerup.whichPowerUp == RPBPowerUpTypeSplitBall) {
                powerUpAbsorbed=3;
                whichBrick=j;
            } else if (powerup.whichPowerUp == RPBPowerUpTypeChangeWall) {
                powerUpAbsorbed=4;
                whichBrick=j;
            } else {
                powerUpAbsorbed=0;
            }
        }
    }
    // Get new random rect if the ball is in the middle of one.
    for (int i=0; i<ballViewArray.count; i++) {
        if (CGRectIntersectsRect([(RPBBall *)ballViewArray[i] rect], randomRect)) {
            randomRect=[self randomRectangle2:j count:k+1];
        }
    }
    // Return the new rect.
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
// Returns a random amount of time for a timer.
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
    for (int i = 0; i < ballViewArray.count; i++) {
        RPBBall * ballPointer = ballViewArray[i];
        [ballPointer render];
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
    [self moveBall];
}

// Our main animation method..
-(void)moveBall
{
    // Loop through all balls.
    for (int i = 0; i < ballViewArray.count; i++) {
        // Get the ball.
        RPBBall *ballPointer = ballViewArray[i];
        // Lock the paddle.
        [self lockPaddle];
        // Get various variables we need to manipulate.
        float bounceAngle;
        int potentialScore = 0;
        
        // Get velocity vectors and the ball's rectangle.
        float xbounce = ballPointer.xBounce;
        float bounce = ballPointer.bounce;
        CGRect ballPointerRect = ballPointer.rect;
        
        // Ball hit counters, useful for making sure we only hit something once, and the ball doesn't get stuck.
        int ballHitCounter = ballPointer.ballHitCounter;
        int ballHitCounterTop = ballPointer.ballHitCounterTop;
        int ballHitCounterLeft = ballPointer.ballHitCounterLeft;
        int ballHitCounterRight = ballPointer.ballHitCounterRight;
        int ballHitCounterBottom = ballPointer.ballHitCounterBottom;
        CGRect paddleRect = self.paddle.rect;
        
        // Get intersection of paddle and ball.
        CGRect intersectRect = CGRectIntersection(paddleRect, ballPointerRect);
        
        // If there is a powerup on the screen and we intersected it.
        if (powerUpEnabled == 1 && (CGRectIntersectsRect(powerup.rectangle.rect, ballPointerRect) || brickIntersectionEnablePowerUp==YES)) {
            // We intersected the first power-up.
            if ((powerup.whichPowerUp == RPBPowerUpTypeSpeedUp) || absorbedPowerup==1) {
                // Handle the case where we hit a brick, and disable the powerup.
                powerUpEnabledEnabled = 1;
                brickIntersectionEnablePowerUp=NO;
                if (whichBrick!=4) {
                    [randomBrickArray[whichBrick] setPowerUpAbsorbed:0];
                    ((RPBRandomRect*) randomBrickArray[whichBrick]).color = [UIColor greenColor];
                }
                whichBrick=4;
                powerUpAbsorbed=0;
                didStartStartPowerUp = 1;
                scoreMultiplier = 3.0f;
                powerUpEnabled = 0;
                
                // Speed up the ball.
                for (int k=0; k<ballViewArray.count; k++) {
                    RPBBall *ballPointer2=ballViewArray[k];
                    [ballPointer2 speedUpBall];
                }
                
                // Start the expiration timer.
                self.powerUpStartedTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpEndPowerUp:) userInfo:nil repeats:YES];
                [powerUpStartedTimer fire];
                
                // Play a sound.
                [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile2];
                return;
            }
            // We intersected the second power-up.
            else if ((powerup.whichPowerUp == RPBPowerUpTypeSlowDown) || absorbedPowerup == 2) {
                // Handle the case where we hit a brick, and enable the powerup.
                powerUpEnabledEnabled = 1;
                brickIntersectionEnablePowerUp=NO;
                if (whichBrick!=4) {
                    [randomBrickArray[whichBrick] setPowerUpAbsorbed:0];
                    ((RPBRandomRect*) randomBrickArray[whichBrick]).color = [UIColor greenColor];
                }
                whichBrick=4;
                powerUpAbsorbed=0;
                didStartStartPowerUp = 1;
                scoreMultiplier = 2.0f;
                powerUpEnabled = 0;
                
                // Slow down the ball.
                for (int k=0; k<ballViewArray.count; k++) {
                    RPBBall *ballPointer2=ballViewArray[k];
                    [ballPointer2 slowDownBall];
                }
                
                // Start the expiration timer.
                self.powerUpStartedTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpEndPowerUp:) userInfo:nil repeats:YES];
                [powerUpStartedTimer fire];
                
                // Play the sound.
                [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile3];
                return;
            }
            
            // We intersected the ball split powerup.
            else if ((powerup.whichPowerUp == RPBPowerUpTypeSplitBall) || absorbedPowerup == 3) {
                // Handle the case where we hit a brick, and disable the powerup.
                brickIntersectionEnablePowerUp=NO;
                if (whichBrick!=4) {
                    [randomBrickArray[whichBrick] setPowerUpAbsorbed:0];
                    ((RPBRandomRect*) randomBrickArray[whichBrick]).color = [UIColor greenColor];
                }
                whichBrick=4;
                powerUpAbsorbed=0;
                powerUpEnabled = 0;
                
                // Create a new ball and split it off.
                RPBBall *newBall=[[RPBBall alloc] init];
                newBall.rect=CGRectMake(ballPointerRect.origin.x-(ballPointerRect.size.width+1), ballPointerRect.origin.y, ballPointerRect.size.width, ballPointerRect.size.height);
                newBall.bounce=ballPointer.bounce;
                newBall.xBounce=-(ballPointer.xBounce);
                newBall.speedMultiplier=ballPointer.speedMultiplier;
                newBall.projectMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, self.view.frame.size.height, 0, -1024, 1024);
                newBall.multiplyFactor = ballPointer.multiplyFactor;
                [ballViewArray addObject:newBall];
                
                // Play the power up sound.
                [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile4];
            }
            
            // We intersected the fourth power-up.
            else if ((powerup.whichPowerUp == RPBPowerUpTypeChangeWall) || absorbedPowerup == 4) {
                // Handle the case where we hit a brick, and start the powerup.
                brickIntersectionEnablePowerUp=NO;
                if (whichBrick!=4) {
                    [randomBrickArray[whichBrick] setPowerUpAbsorbed:0];
                    ((RPBRandomRect*) randomBrickArray[whichBrick]).color = [UIColor greenColor];
                }
                whichBrick=4;
                powerUpAbsorbed=0;
                powerUpEnabled = 0;
                didStartStartPowerUp=1;
                powerUpEnabledEnabled=1;
                
                // Change the wall based off a random number.
                int oldWallToLose=wallToLose;
                while (oldWallToLose==wallToLose||wallToLose==wallEnabled) {
                    wallToLose = (arc4random() % 4) + 1;
                    walls.wallToLose = wallToLose;
                }
                scoreMultiplier=4.0f;
                
                // Start the expiration timer for the powerup.
                self.loseWallChangeTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(loseTimeChangeWall:) userInfo:nil repeats:YES];
                [loseWallChangeTimer fire];
                didStartLoseWall=YES;
            }
        }
        
        // We intersected the left wall.
        if (CGRectIntersectsRect(walls.leftWall.rect, ballPointerRect)) {
            ballHitCounterLeft = ballHitCounterLeft+1;
            // We hit the losing wall.
            if (walls.wallToLose==1) {
                // We have only one ball, so end the game.
                if (ballViewArray.count==1) {
                    [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
                    return;
                } else {
                    // We have more than one, so get rid of the one that hit the wall.
                    [ballViewArray removeObjectAtIndex:i];
                    return;
                }
            } else {
                // This isn't the losing wall, and we aren't stuck in the wall.
                if (ballHitCounterLeft<=1)
                {
                    // Play sound, change direction, and add to score.
                    [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile1];
                    xbounce = -xbounce;
                    xbounce = xbounce+0.01f;
                    if (walls.wallToEnable == 1) {
                        potentialScore += (250*scoreMultiplier);
                    } else {
                        potentialScore += (10*scoreMultiplier);
                    }
                }
            }
        } else {
            // Set hit counter for left wall back to 0.
            ballHitCounterLeft=0;
        }
        // We hit the right wall.
        if (CGRectIntersectsRect(walls.rightWall.rect, ballPointerRect)) {
            // Increment ball counter.
            ballHitCounterRight= ballHitCounterRight+1;
            // We are the losing wall.
            if (walls.wallToLose==3) {
                if (ballViewArray.count==1) {
                    // We are the only ball left, so end the game.
                    [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
                    return;
                } else {
                    // We aren't the only ball, so just remove the current ball.
                    [ballViewArray removeObjectAtIndex:i];
                    return;
                }
            } else {
                if (ballHitCounterRight<=1)
                {
                    // We aren't the losing wall, and we aren't stuck in the wall.
                    // As before, play sound, increment, and add to score.
                    xbounce = -xbounce;
                    xbounce = xbounce+0.01f;
                    [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile1];
                    if (walls.wallToEnable == 3) {
                        potentialScore += (250*scoreMultiplier);
                    } else {
                        potentialScore += (10*scoreMultiplier);
                    }
                }
            }
        } else {
            // We haven't hit the right wall, so revert to 0.
            ballHitCounterRight=0;
        }
        // We hit the bottom wall.
        if (CGRectIntersectsRect(walls.bottomWall.rect, ballPointerRect)) {
            // Increment ball counter.
            ballHitCounterBottom = ballHitCounterBottom+1;
            // We are the losing wall.
            if (walls.wallToLose==4) {
                // We are the last ball, so end the game.
                if (ballViewArray.count==1) {
                    [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
                    return;
                } else {
                    // We are not the only ball, so remove the ball that got hit.
                    [ballViewArray removeObjectAtIndex:i];
                    return;
                }
            } else {
                if (ballHitCounterBottom<=1)
                {
                    // We are not the losing wall, so invert the ball trajectory and proceed to play a sound.
                    bounce = -bounce;
                    bounce = bounce + 0.01f;
                    [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile1];
                    if (walls.wallToEnable == 6) {
                        potentialScore += (250*scoreMultiplier);
                    } else {
                        potentialScore += (10*scoreMultiplier);
                    }
                }
            }
        } else {
            // We haven't hit the bottom wall, so revert to 0.
            ballHitCounterBottom = 0;
        }
        // We hit the top wall.
        if (CGRectIntersectsRect(walls.topWall.rect, ballPointerRect)) {
            ballHitCounterTop = ballHitCounterTop+1;
            // We hit the losing wall, so end the game.
            if (walls.wallToLose==2) {
                if (ballViewArray.count==1) {
                    // End the game, safe for future multithreading.
                    [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
                    return;
                } else {
                    [ballViewArray removeObjectAtIndex:i];
                    return;
                }
            } else {
                // We didn't hit the losing wall.
                if (ballHitCounterTop<=1) {
                    // Reverse ball with variance.
                    bounce = -bounce;
                    bounce = bounce + 0.01f;
                    // Calculate the points earned if we are a
                    if (walls.wallToEnable == 2) {
                        potentialScore += (250*scoreMultiplier);
                    } else {
                        potentialScore += (10*scoreMultiplier);
                    }
                    // Play a sound, safe for future multithreading.
                    [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile1];
                }
            }
        } else {
            // We haven't hit the top wall, so revert to 0.
            ballHitCounterTop=0;
        }
        // Random bricks are on the screen
        if (randomBrickIsEnabled) {
            // Go through each one.
            for (int i=0; i<randomBrickArray.count; i++) {
                // Get it and where it is on the screen.
                RPBRandomRect *randomRect = randomBrickArray[i];
                CGRect rectOfBrick = randomRect.rectOfView;
                // We intersect the ball.
                if (CGRectIntersectsRect(ballPointerRect, rectOfBrick)) {
                    // Get intersection.
                    CGRect brickIntersect = CGRectIntersection(ballPointerRect, rectOfBrick);
                    // If hit counter is less than 1.
                    if (randomBrickHitCounter<=1) {
                        // Don't let the paddle move if we are wedged between the ball and the paddle.
                        if ((CGRectIntersectsRect(randomRect.topRectBall, ballPointerRect)||CGRectIntersectsRect(randomRect.bottomRectBall, ballPointerRect)||CGRectIntersectsRect(randomRect.leftRectBall, ballPointerRect)||CGRectIntersectsRect(randomRect.rightRectBall, ballPointerRect))&&(CGRectIntersectsRect(randomRect.topRectBall, paddleRect)||CGRectIntersectsRect(randomRect.bottomRectBall, paddleRect)||CGRectIntersectsRect(randomRect.leftRectBall, paddleRect)||CGRectIntersectsRect(randomRect.rightRectBall, paddleRect))) {
                            dontmove=YES;
                        } else {
                            dontmove=NO;
                        }
                        // Temporary rect to prevent the ball from being stuck in the brick.
                        CGRect currentBallRect=ballPointer.rect;
                        // We are intesecting the top.
                        if (CGRectIntersectsRect(randomRect.topRect, ballPointerRect)&&brickIntersect.size.width>brickIntersect.size.height) {
                            // We, in addition to reversing the bounce, we also move the ball back so it doesn't get stuck in the brick.
                            currentBallRect.origin.y=(randomRect.topRect.origin.y-(ballPointerRect.size.height+3));
                            bounce=-bounce+0.1f;
                        }
                        // We are intersecting the bottom.
                        if (CGRectIntersectsRect(randomRect.bottomRect, ballPointerRect)&&brickIntersect.size.width>brickIntersect.size.height) {
                            // We, in addition to reversing the bounce, we also move the ball back so it doesn't get stuck in the brick.
                            currentBallRect.origin.y=(randomRect.bottomRect.origin.y+3);
                            bounce=-bounce+0.1f;
                        }
                        // We are intersecting the left side.
                        if (CGRectIntersectsRect(randomRect.leftRect, ballPointerRect) && brickIntersect.size.width<brickIntersect.size.height) {
                            // We, in addition to reversing the bounce, we also move the ball back so it doesn't get stuck in the brick.
                            currentBallRect.origin.x=(randomRect.leftRect.origin.x-(ballPointerRect.size.height+3));
                            xbounce=-xbounce+0.1f;
                        }
                        // We are intersecting the right.
                        if (CGRectIntersectsRect(randomRect.rightRect, ballPointerRect) && brickIntersect.size.width<brickIntersect.size.height) {
                            // We, in addition to reversing the bounce, we also move the ball back so it doesn't get stuck in the brick.
                            currentBallRect.origin.x=(randomRect.rightRect.origin.x+3);
                            xbounce=-xbounce+0.1f;
                        }
                        // Put the new rect back.
                        ballPointerRect=currentBallRect;
                        ballPointer.rect = ballPointerRect;
                        
                        // If we hit a brick with an absorbed power up, then set variables for the next round where the absorbed powerup is transferred to the ball.
                        if (whichBrick==i&&randomRect.powerUpAbsorbed!=0) {
                            brickIntersectionEnablePowerUp=YES;
                            absorbedPowerup=randomRect.powerUpAbsorbed;
                        }
                        // Increment the score.
                        potentialScore += 20;
                        // Play a hit sound.
                        [NSThread detachNewThreadSelector:@selector(playSound:) toTarget:self withObject:self.audioFile1];
                    }
                    // Increment brick counter.
                    randomBrickHitCounter +=1;
                } else if(!CGRectIntersectsRect(ballPointerRect, rectOfBrick)) {
                    // Set random brick hit counter back to 0.
                    randomBrickHitCounter=0;
                }
            }
        }
        
        // We hit the paddle.
        if (!CGRectIsNull(intersectRect)) {
            // Make sure ball hit counter not greater than 1.
            if (ballHitCounter<1)
            {
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
            ballHitCounter = ballHitCounter+1;
        } else {
            // Set ball hit counter for a collision with the paddle to 0.
            ballHitCounter=0;
        }
        
        // Check for cheating.
        if((!(CGRectIntersectsRect(noScoreZone, paddleRect) && CGRectIntersectsRect(noScoreZone, ballPointerRect))&&!(CGRectIntersectsRect(noScoreZone2, paddleRect) && CGRectIntersectsRect(noScoreZone2, ballPointerRect))&&!(CGRectIntersectsRect(noScoreZone3, paddleRect) && CGRectIntersectsRect(noScoreZone3, ballPointerRect))&&!(CGRectIntersectsRect(noScoreZone4, paddleRect) && CGRectIntersectsRect(noScoreZone4, ballPointerRect))))
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
        
        // Animate the ball.
        ballPointerRect.origin.y=ballPointerRect.origin.y-ballPointer.bounce;
        ballPointerRect.origin.x=ballPointerRect.origin.x-ballPointer.xBounce;
        ballPointer.rect=ballPointerRect;
        
        // Update the score with the new score.
        scoreField.text=[NSString localizedStringWithFormat:NSLocalizedString(@"SCORE:", nil), score];
        [self unlockPaddle];
    }
}
// Our function to put random bricks on the screen.
-(void)randomBrickTimerFire:(NSTimer *)theTimer
{
    // Prevents the timer from starting if we haven't fired once.
    if (randomBrickDidStart==YES) {
        randomBrickDidStart=NO;
        return;
    }
    // If the bricks are not on the screen.
    if(randomBrickIsEnabled==NO)
    {
        // Create them.
        for (int i = 0; i < 3; i++) {
            [randomBrickArray addObject:[[RPBRandomRect alloc] init]];
            CGRect randomRect = [self randomRectangle2:i count:0];
            if (randomBrickFailed) {
                return;
            }
            // Create a new random rect and set it up, and add it to the view.
            ((RPBRandomRect *)randomBrickArray[i]).projectMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, self.view.frame.size.height, 0, -1024, 1024);
            // Check for absorbed powerup and if so then enable powerup absorbtion.
            if (powerUpAbsorbed!=0) {
                ((RPBRandomRect *)randomBrickArray[i]).color = [UIColor redColor];
                powerUpEnabled=1;
                ((RPBRandomRect *)randomBrickArray[i]).powerUpAbsorbed = powerUpAbsorbed;
            } else {
                ((RPBRandomRect *)randomBrickArray[i]).color = [UIColor greenColor];
            }
            [randomBrickArray[i] setRectOfView:randomRect];
        }
        randomBrickIsEnabled=YES;
        return;
    }
    if(randomBrickIsEnabled==YES) {
        // Remove all bricks from the screen and get out of here.
        for (int i = 0; i < 3; i++) {
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
    // Set game over to true.
    _gameOver = YES;
    // More clean up after losing the game.
    [self lostGame];
    // Update score in app delegate and call the end game function.
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] setScore:score];
    // Load in the appropriate storyboard.
    UIStoryboard *theStoryboard;
    if([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        theStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPad" bundle:nil];
    } else {
        theStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPhone" bundle:nil];
    }
    // Unset all audio players's delegates.
    for (AVAudioPlayer *thePlayer in self.audioPlayers) {
        thePlayer.delegate = nil;
    }
    // Push in the game over view controller and show it.
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
        // If the user requested no sound, then return.
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBSound"]== NO) {
            return;
        }
        // If we are already playing a sound and playing too many, then return.
        if(isPlaying==YES&&playcount>=10)
        {
            return;
        }
        // Create a new audio player, and play the sound.
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
    // If we just started, then return.
    if (justStartedWallTimer == YES) {
        justStartedWallTimer = NO;
        return;
    }
    if(wallEnabled == NO)
    {
        // Choose a wall to give the 250 point boost, and enable that wall.
        wallToEnable = (arc4random() % 3) + 1;
        walls.wallToEnable = wallToEnable;
        [wallScoreBoostTimer invalidate];
        self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
        justStartedWallTimer = YES;
        [wallScoreBoostTimer fire];
        wallEnabled = YES;
    } else if (wallEnabled == YES) {
        // Change wall back.
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
    
    // If we are wedged between the ball and then paddle, then just return.
    if (dontmove == YES) {
        return;
    }
    
    // Get the current position from the touch object.
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.mainView];
    
    // First, adjust the paddle according to the walls.
    // If we collide, then set the respective coordinate to the edge of that wall.
    CGRect tempRect;
    tempRect.origin.x=location.x-(paddleSize/2);
    tempRect.origin.y=location.y-(paddleSize/2);
    tempRect.size=CGSizeMake(paddleSize, paddleSize);
    CGPoint paddlePointTemp = location;
    if (CGRectIntersectsRect(tempRect, walls.topPaddleWall.rect)) {
        paddlePointTemp.y = walls.topPaddleWall.rect.origin.x-(paddleSize/2);
    }
    if (CGRectIntersectsRect(tempRect, walls.bottomPaddleWall.rect)) {
        paddlePointTemp.y = walls.bottomPaddleWall.rect.origin.y-(paddleSize/2);
        
    } if (CGRectIntersectsRect(tempRect, walls.leftPaddleWall.rect)) {
        paddlePointTemp.x = walls.leftPaddleWall.rect.size.width+((paddleSize/2)+wallSize);
        
    } if(CGRectIntersectsRect(tempRect, walls.rightPaddleWall.rect)){
        paddlePointTemp.x = walls.rightPaddleWall.rect.origin.x-(paddleSize/2);
    }
    
    // Handle the random rectangles on the display.
    CGRect tempRect2;
    tempRect2.origin.x=paddlePointTemp.x-(paddleSize/2);
    tempRect2.origin.y=paddlePointTemp.y-(paddleSize/2);
    tempRect2.size=CGSizeMake(paddleSize, paddleSize);
    for (RPBRandomRect *brickPointer in randomBrickArray) {
        if (CGRectIntersectsRect(brickPointer.rectOfView, tempRect2)) {
            // If we have an intersection, well have the paddle freeze in place in the vicinity.
            // So in this case, just return.
            return;
        }
    }
    
    // If we intersect a ball, then don't update anything and just get out of here.
    for (RPBBall *ballPointer in ballViewArray) {
        if (CGRectIntersectsRect(tempRect, ballPointer.rect)) {
            return;
        }
    }
    
    // Set the new position for the paddle.
    self.paddle.paddleCenter = paddlePointTemp;
    
}
// We moved the paddle, so really call the method that handles the beginning of the touch.
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesBegan:touches withEvent:event];
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
	if (powerUpEnabledEnabled == 1) {
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
        // Remove the power up from the screen.
		powerUpEnabled = 0;
	}
}
// Pause the game.
-(IBAction)pauseGame:(id)sender
{
    // if we are already paused, then return.
    if(isPaused == 1)
    {
        return;
    }
    // If the app delegate paused the game, then set that it did pause us.
    if (sender == [CoreGraphicsDrawingAppDelegate sharedAppDelegate]) {
        _pausedAtUI = NO;
    } else {
        _pausedAtUI = YES;
    }
	[speedTimer invalidate];
	[powerUpTimer invalidate];
    
    // If the timer is running for the lost wall., then invalidate it.
    if (loseWallChangeTimer.valid) {
        [loseWallChangeTimer invalidate];
    }

    // Save the amount of time we have left on the powerup.
	if (powerUpStartedTimer.valid) {
		NSDate *fireTime = powerUpStartedTimer.fireDate;
		fireTimeInterval = fireTime.timeIntervalSinceNow;
		[powerUpStartedTimer invalidate];
	}
    // Invalidate other timers.
    [wallScoreBoostTimer invalidate];
    [randomBrickTimer invalidate];
    // Set other variables back to some defaults.
    randomBrickDidStart = YES;
	didStartStartPowerUp = 1;
	didInvalidate = 1;
	isPaused = 1;
    // Update UI and pause game.
    pauseButton.enabled=NO;
    self.paused = YES;
	[self.mainView addSubview:pauseView];
    [self lockPaddle];
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
    // Check to make sure the user is sure.
    [pauseView removeFromSuperview];
    [mainView addSubview:areYouSureView];
}
-(IBAction)yesClicked:(id)sender
{
    // They are, so end the game.
    [areYouSureView removeFromSuperview];
    [self theEnd];
}
-(IBAction)noClicked:(id)sender
{
    // If they aren't, then go back to pause.
    [areYouSureView removeFromSuperview];
    [mainView addSubview:pauseView];
}
-(IBAction)resumeGame:(id)sender
{
    // Refire timers, while setting their respective did start variables to true.
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
    // Undo the pause and start the game.
	didInvalidate = 0;
	isPaused = 0;
    pauseButton.enabled=YES;
    self.paused = NO;
	[pauseView removeFromSuperview];
}

// Slightly speed up the ball.
-(void)speedUp:(NSTimer *)theTimer
{
    // If we started, then get out of here.
	if (didStart == 1)
	{
		didStart = 0;
		return;
	}
    // If the user hit a powerup, then also get out of here.
	if (powerUpEnabledEnabled == 1) {
		return;
	}
    // Loop through for each ball and boost the speed multiplier.
    for(int i=0; i<ballViewArray.count; i++)
    {
        RPBBall *ballPointer=ballViewArray[i];
        ballPointer.xBounce=ballPointer.xBounce/ballPointer.speedMultiplier;
        ballPointer.bounce=ballPointer.bounce/ballPointer.speedMultiplier;
        ballPointer.speedMultiplier=ballPointer.speedMultiplier+.75f;
        ballPointer.xBounce=ballPointer.xBounce*ballPointer.speedMultiplier;
        ballPointer.bounce=ballPointer.bounce*ballPointer.speedMultiplier;
    }
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
	[speedTimer invalidate];
	[powerUpTimer invalidate];
	if (powerUpStartedTimer.valid) {
		[powerUpStartedTimer invalidate];
	}
    [randomBrickTimer invalidate];
    [wallScoreBoostTimer invalidate];
    [pauseButton setEnabled:YES];
	didInvalidate = 1;
    powerUpEnabled = 0;
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
    scoreMultiplier = 1.0f;
    wallEnabled = NO;
    justStartedWallTimer = YES;
    self.audioPlayers = [[NSMutableArray alloc] init];
    
    // Setup OpenGL.
    [self setupGL];
    
    // Setup shaders.
    [RPBRectangle setupShaders];
    
    // Setup various objects on the display.
    ballViewArray = [[NSMutableArray alloc] init];
    randomBrickArray=[[NSMutableArray alloc] init];
    CGRect screenSize = [UIScreen mainScreen].bounds;
	CGRect pauseViewRect = pauseView.frame;
	CGRect newPauseViewRect = CGRectMake((screenSize.size.width/2)-138, (screenSize.size.height/2)-121, pauseViewRect.size.width, pauseViewRect.size.height);
	pauseView.frame = newPauseViewRect;
    CGRect areYouSureViewRect = areYouSureView.frame;
	CGRect newAreYouSureViewRect = CGRectMake((screenSize.size.width/2)-121, (screenSize.size.height/2)-104, areYouSureViewRect.size.width, areYouSureViewRect.size.height);
	areYouSureView.frame = newAreYouSureViewRect;
    
    // Setup multiply factor.
    float multiplyFactor;
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        multiplyFactor = 1.5f;
    } else {
        multiplyFactor = 1.0f;
    }
    
    // Set size of ball and paddle for the correct screen size.
    CGRect ballRect;
    ballRect.size.width = 10 * multiplyFactor;
    ballRect.size.height = 10 * multiplyFactor;
    paddleSize = PADDLESIZE * multiplyFactor;

    // Set right size for walls.
    wallSize = WALLSIZE * multiplyFactor;
    noscorezone = NOSCOREZONE * multiplyFactor;
    
    // Setup areas where the player can't score.
    noScoreZone = CGRectMake(wallSize,wallSize, screenSize.size.width-(wallSize*2), noscorezone);
    noScoreZone2 = CGRectMake(wallSize, noscorezone+wallSize, noscorezone, screenSize.size.height-(noscorezone*2));
    noScoreZone3 = CGRectMake(wallSize, screenSize.size.height-(noscorezone+wallSize), screenSize.size.width-(wallSize*2), noscorezone);
    noScoreZone4 = CGRectMake(screenSize.size.height-(noscorezone+wallSize), noscorezone+wallSize, noscorezone, screenSize.size.height-(noscorezone*2));
    
    // Setup the paddle.
    self.paddle = [[RPBPaddle alloc] init];
    CGFloat redColorPaddle = [userDefaults floatForKey:@"RPBRedColorPaddle"];
    CGFloat greenColorPaddle = [userDefaults floatForKey:@"RPBGreenColorPaddle"];
    CGFloat blueColorPaddle = [userDefaults floatForKey:@"RPBBlueColorPaddle"];
    self.paddle.color = [UIColor colorWithRed:redColorPaddle/255.0f green:greenColorPaddle/255.0f blue:blueColorPaddle/255.0f alpha:1.0];
    self.paddle.projectMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, self.view.frame.size.height, 0, -1024, 1024);
    self.paddle.rect = CGRectMake(CGRectGetMidX(self.view.frame)-paddleSize/2, CGRectGetMidY(self.view.frame)-paddleSize/2, paddleSize, paddleSize);
    CGRect paddleImageRect = CGRectMake(self.paddle.paddleCenter.x-(paddleSize/2), self.paddle.paddleCenter.y-(paddleSize/2), paddleSize, paddleSize);
    paddleImageRect.size.width = paddleSize;
    paddleImageRect.size.height = paddleSize;
    self.paddle.paddleCenter=CGPointMake((screenSize.size.width/2),(screenSize.size.height/2));
    
    // Setup the ball.
    RPBBall *ball1 = [[RPBBall alloc] init];
    ballRect.origin.x = (screenSize.size.width/2)-5;
    ballRect.origin.y = (self.paddle.paddleCenter.y-paddleSize/2)-(ballRect.size.height/2)-5;
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
    walls.sizeMultiplier = multiplyFactor;
    
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

- (void)dealloc {
    // Invalidate timers.
	[speedTimer invalidate];
	[powerUpTimer invalidate];
	[powerUpStartedTimer invalidate];
    [wallScoreBoostTimer invalidate];
}

@end
