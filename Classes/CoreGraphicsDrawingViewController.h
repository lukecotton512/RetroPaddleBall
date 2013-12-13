//
//  CoreGraphicsDrawingViewController.h
//  CoreGraphicsDrawing
//
//  Created by Luke Cotton on 2/5/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#import "CoreGraphicsDrawingView.h"
//#import "CoreGraphicsDrawingAppDelegate.h"
#import "RPBBall.h"
#import "RPBRandomRect.h"
#define FILTERINGFACTOR 0.15
#define RANDOMBRICKAREA CGRectMake(0,0,320,200)
#define BRICKDEBUG 1
@interface CoreGraphicsDrawingViewController : UIViewController <UIAccelerometerDelegate, AVAudioPlayerDelegate> {
	IBOutlet CoreGraphicsDrawingView *mainView;
	IBOutlet UILabel *scoreField;
    IBOutlet UILabel *highScoreField;
	IBOutlet UIView *pauseView;
	IBOutlet UIImageView *powerUpImage;
	IBOutlet UIImageView *powerUpImage2;
    UIView *powerUpImage4;
    UIView *ballImage;
    IBOutlet UIView *paddleImage;
    IBOutlet UIView *areYouSureView;
    IBOutlet UIButton *pauseButton;
    IBOutlet UIView *powerUpImage3;
    IBOutlet UIView *ball3;
    IBOutlet UIView *ball2;
    NSMutableArray *ballViewArray;
    NSMutableArray *bounceArray;
    NSMutableArray *xBounceArray;
    NSMutableArray *randomBrickArray;
    RPBRandomRect *randomRect1;
    RPBRandomRect *randomRect2;
    RPBRandomRect *randomRect3;
    BOOL velocityLockEnabled;
    BOOL velocitySignX;
    BOOL velocitySignY;
    //NSMutableArray *ballRectArray;
	int score;
    int playcount;
    BOOL dontmove;
    float paddleSize;
	NSTimer *ballTimer;
	NSTimer *speedTimer;
	NSTimer *powerUpTimer;
	NSTimer *powerUpStartedTimer;
	NSTimer *timerToRelease;
    NSTimer *cheatCheckTimer;
    NSTimer *wallScoreBoostTimer;
    NSTimer *loseWallChangeTimer;
    NSTimer *randomBrickTimer;
    //NSAutoreleasePool *autoPool;
    CMMotionManager *accelerometerDelegate;
    UIAccelerationValue xAccel;
    UIAccelerationValue yAccel;
    UIAccelerationValue xAccelCali;
    UIAccelerationValue yAccelCali;
    NSTimeInterval lastTimeUpdate;
    //AVAudioPlayer *audioPlayer;
	double difficultyMultiplier;
    double speedMultiplier;
	//float bounce;
	//float xbounce;
	float angleToBounce;
    BOOL doAddOnToScore;
    BOOL wallEnabled;
    BOOL justStartedWallTimer;
    BOOL brickIntersectionEnablePowerUp;
    int powerUpAbsorbed;
    int whichBrick;
    BOOL brickTriggered;
    BOOL isPlaying;
    BOOL soundIsOn;
    BOOL doSlowDown;
    BOOL randomBrickDidStart;
    BOOL randomBrickIsEnabled;
    BOOL randomBrickFailed;
    int powerUpAbsorbedTemp;
	int didStart;
	int didStartPowerUp;
	int didStartStartPowerUp;
    int wallToLose;
    BOOL didStartLoseWall;
	int isPaused;
    int wallToEnable;
	int didInvalidate;
	int powerUpEnabled;
	int powerUpEnabledEnabled;
	int whichPowerUp;
    int paddleLocked;
	float scoreMultiplier;
    float velocityX;
    float velocityY;
	double speedBounce;
	double fireTimeInterval;
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
    CGRect ballRect;
    CGPoint paddlelocation;
    CGRect noScoreZone;
    CGRect noScoreZone2;
    CGRect noScoreZone3;
    CGRect noScoreZone4;
    CGRect leftTopRect;
    CGRect rightTopRect;
    CGRect leftBottomRect; 
    CGRect rightBottomRect;
    CGRect upperLeftRect;
    CGRect lowerLeftRect;
    CGRect upperRightRect; 
    CGRect lowerRightRect;
    int wallSize;
    int wallBorderSize;
    int noscorezone;
    //BOOL resumedFromPause;
    //CoreGraphicsDrawingAppDelegate *delegateLinkback;
    /*AVAudioPlayer *audioPlayer;
    AVAudioPlayer *audioPlayer2;
    AVAudioPlayer *audioPlayer3;*/
    NSData *audioFile1;
    NSData *audioFile2;
    NSData *audioFile3;
    NSData *audioFile4;
    /*SystemSoundID soundID;
    SystemSoundID soundID2;
    SystemSoundID soundID3;*/
}
//-(void)calculateBallPosition:(NSArray *)ballPointerArray
-(void)ballEmergencyRescue:(NSArray *)ballAndSideToFix;
-(void)lockPaddle;
-(void)unlockPaddle;
-(IBAction)pauseGame:(id)sender;
-(IBAction)endGame:(id)sender;
-(IBAction)resumeGame:(id)sender;
-(void)releaseBallTimer;
-(void)moveBall:(NSTimer *)theTimer;
-(void)speedUp:(NSTimer *)theTimer;
-(void)powerUpCreate:(NSTimer *)theTimer;
-(void)powerUpEndPowerUp:(NSTimer *)theTimer;
-(void)wallScoreBoostEnableOrDisable:(NSTimer *)theTimer;
-(void)randomBrickTimerFire:(NSTimer *)theTimer;
-(void)loseTimeChangeWall:(NSTimer *)theTimer;
- (void)accelerometerDidAccelerate:(UIAccelerationValue)theX y:(UIAccelerationValue)theY;
//-(void)cheatCheck:(NSTimer *)theTimer;
-(double)randomTimerTime;
-(CGRect)randomRectangle;
-(CGRect)randomRectangle2:(int)j count:(int)k;
-(void)lostGame;
-(void)newGame;
-(void)playSound;
-(IBAction)yesClicked:(id)sender;
-(IBAction)noClicked:(id)sender;
-(void)theEnd;
-(void)playSound2;
-(void)playSound3;
-(void)playSound4;
@property (nonatomic, retain) NSTimer *ballTimer;
@property (nonatomic, retain) NSTimer *speedTimer;
@property (nonatomic, retain) NSTimer *powerUpTimer;
@property (nonatomic, retain) NSTimer *powerUpStartedTimer;
@property (nonatomic, retain) NSTimer *cheatCheckTimer;
@property (nonatomic, assign) NSTimer *timerToRelease;
@property (nonatomic, retain) NSTimer *wallScoreBoostTimer;
@property (nonatomic, retain) NSTimer *randomBrickTimer;
@property (nonatomic, retain) NSTimer *loseWallChangeTimer;
@property (nonatomic, assign) CMMotionManager *accelerometerDelegate;
@property (nonatomic, assign) int randomBrickHitCounter;
//@property (nonatomic, assign) CoreGraphicsDrawingAppDelegate *delegateLinkback;
@property (nonatomic, retain) IBOutlet CoreGraphicsDrawingView *mainView;
@property (nonatomic, retain) IBOutlet UILabel *scoreField;
@property (nonatomic, retain) IBOutlet UILabel *highScoreField;
@property (nonatomic, retain) IBOutlet UIView *pauseView;
@property (nonatomic, retain) IBOutlet UIImageView *powerUpImage;
@property (nonatomic, retain) IBOutlet UIImageView *powerUpImage2;
@property (nonatomic, retain) UIView *ballImage;
@property (nonatomic, retain) IBOutlet UIView *paddleImage;
@property (nonatomic, retain) IBOutlet UIView *areYouSureView;
@property (nonatomic, retain) IBOutlet UIButton *pauseButton;
@property (nonatomic, retain) IBOutlet UIView *powerUpImage3;
@property (nonatomic, retain) UIView *powerUpImage4;
@property (nonatomic, retain) IBOutlet UIView *ball3;
@property (nonatomic, retain) IBOutlet UIView *ball2;
@property (nonatomic, retain) NSMutableArray *ballViewArray;
@property (nonatomic, retain) NSMutableArray *randomBrickArray;
@property (nonatomic, retain) RPBRandomRect *randomRect1;
@property (nonatomic, retain) RPBRandomRect *randomRect2;
@property (nonatomic, retain) RPBRandomRect *randomRect3;
@property (nonatomic, assign) int wallToLose;
//@property (nonatomic, retain) NSAutoreleasePool *autoPool;
/*@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer2;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer3;*/
//@property (nonatomic, retain) NSMutableArray *ballRectArray;
@property (nonatomic, retain) NSData *audioFile1;
@property (nonatomic, retain) NSData *audioFile2;
@property (nonatomic, retain) NSData *audioFile3;
@property (nonatomic, retain) NSData *audioFile4;
@property (nonatomic, assign) CGPoint paddlelocation;
@property (nonatomic, assign) CGRect ballRect;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) BOOL dontmoveUp;
@property (nonatomic, assign) BOOL dontmoveDown;
@property (nonatomic, assign) BOOL velocityLockEnabled;
@property (nonatomic, assign) BOOL velocitySignX;
@property (nonatomic, assign) BOOL velocitySignY;
/*@property (nonatomic, assign) SystemSoundID soundID;
@property (nonatomic, assign) SystemSoundID soundID2;
@property (nonatomic, assign) SystemSoundID soundID3;*/
@property (nonatomic, assign) int didInvalidate;
@property (nonatomic, assign) int isPaused;
@property (nonatomic, assign) int powerUpEnabled;
@property (nonatomic, assign) int powerUpEnabledEnabled;
@property (nonatomic, assign) int didStartStartPowerUp;
@property (nonatomic, assign) double fireTimeInterval;
@property (nonatomic, assign) double speedMultiplier;
//@property (nonatomic, assign) float bounce;
@property (nonatomic, assign) BOOL doAddOnToScore;
@property (nonatomic, assign) BOOL wallEnabled;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL soundIsOn;
@property (nonatomic, assign) BOOL doSlowDown;
@property (nonatomic, assign) BOOL didStartLoseWall;
//@property (nonatomic, assign) float xbounce;
@property (nonatomic, assign) int didStart;
@property (nonatomic, assign) int didStartPowerUp;
@property (nonatomic, assign) int whichPowerUp;
@property (nonatomic, assign) int paddleLocked;
@property (nonatomic, assign) int wallToEnable;
@property (nonatomic, assign) int playcount;
@property (nonatomic, assign) double speedBounce;
@property (nonatomic, assign) NSTimeInterval lastTimeUpdate;
@property (nonatomic, assign) double difficultyMultiplier;
@property (nonatomic, assign) float velocityX;
@property (nonatomic, assign) float velocityY;
@property (nonatomic, assign) float scoreMultiplier;
@property (nonatomic, assign) UIAccelerationValue xAccel;
@property (nonatomic, assign) UIAccelerationValue yAccel; 
@property (nonatomic, assign) UIAccelerationValue xAccelCali;
@property (nonatomic, assign) UIAccelerationValue yAccelCali;
@property (nonatomic, assign) BOOL justStartedWallTimer;
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
@property (nonatomic, assign) CGRect noScoreZone;
@property (nonatomic, assign) CGRect noScoreZone2;
@property (nonatomic, assign) CGRect noScoreZone3;
@property (nonatomic, assign) CGRect noScoreZone4;
@property (nonatomic, assign) CGRect leftTopRect;
@property (nonatomic, assign) CGRect rightTopRect;
@property (nonatomic, assign) CGRect leftBottomRect; 
@property (nonatomic, assign) CGRect rightBottomRect;
@property (nonatomic, assign) CGRect upperLeftRect;
@property (nonatomic, assign) CGRect lowerLeftRect;
@property (nonatomic, assign) CGRect upperRightRect; 
@property (nonatomic, assign) CGRect lowerRightRect;
@property (nonatomic, assign) float paddleSize;
@end

