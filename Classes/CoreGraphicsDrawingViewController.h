//
//  CoreGraphicsDrawingViewController.h
//  CoreGraphicsDrawing
//
//  Created by Luke Cotton on 2/5/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#import "RPBBall.h"
#import "RPBPaddle.h"
#import "RPBRandomRect.h"
#import "RetroPaddleBall-Swift.h"

#define RANDOMBRICKAREA CGRectMake(0,0,320,200)
#define BRICKDEBUG 1

@interface CoreGraphicsDrawingViewController : GLKViewController <AVAudioPlayerDelegate> {
	IBOutlet GLKView *mainView;
	IBOutlet UILabel *scoreField;
    IBOutlet UILabel *highScoreField;
	IBOutlet UIView *pauseView;
    IBOutlet UIView *areYouSureView;
    IBOutlet UIButton *pauseButton;
    EAGLContext *context;
    NSMutableArray *ballViewArray;
    NSMutableArray *randomBrickArray;
    RPBWall *walls;
    RPBPowerUp *powerup;
    BOOL _pausedAtUI;
	int score;
    int playcount;
    BOOL dontmove;
    BOOL dontmoveball;
    float paddleSize;
	NSTimer *speedTimer;
	NSTimer *powerUpTimer;
	NSTimer *powerUpStartedTimer;
    NSTimer *wallScoreBoostTimer;
    NSTimer *loseWallChangeTimer;
    NSTimer *randomBrickTimer;
	double difficultyMultiplier;
	float angleToBounce;
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
    BOOL _gameOver;
    int absorbedPowerup;
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
    int paddleLocked;
	float scoreMultiplier;
	double fireTimeInterval;
    CGRect noScoreZone;
    CGRect noScoreZone2;
    CGRect noScoreZone3;
    CGRect noScoreZone4;
    int wallSize;
    int wallBorderSize;
    int noscorezone;
    NSData *audioFile1;
    NSData *audioFile2;
    NSData *audioFile3;
    NSData *audioFile4;
}
-(void)lockPaddle;
-(void)unlockPaddle;
-(IBAction)pauseGame:(id)sender;
-(IBAction)endGame:(id)sender;
-(IBAction)resumeGame:(id)sender;
-(void)moveBall;
-(void)speedUp:(NSTimer *)theTimer;
-(void)powerUpCreate:(NSTimer *)theTimer;
-(void)powerUpEndPowerUp:(NSTimer *)theTimer;
-(void)wallScoreBoostEnableOrDisable:(NSTimer *)theTimer;
-(void)randomBrickTimerFire:(NSTimer *)theTimer;
-(void)loseTimeChangeWall:(NSTimer *)theTimer;
@property (nonatomic, readonly) double randomTimerTime;
@property (nonatomic, readonly) CGRect randomRectangle;
-(CGRect)randomRectangle2:(int)j count:(int)k;
-(void)lostGame;
-(void)newGame;
-(void)playSound:(NSData *)soundData;
-(IBAction)yesClicked:(id)sender;
-(IBAction)noClicked:(id)sender;
-(void)theEnd;
-(IBAction)createNewGame:(UIStoryboardSegue *)sender;
-(void)setupGL;
@property (nonatomic, strong) NSTimer *speedTimer;
@property (nonatomic, strong) NSTimer *powerUpTimer;
@property (nonatomic, strong) NSTimer *powerUpStartedTimer;
@property (nonatomic, strong) NSTimer *wallScoreBoostTimer;
@property (nonatomic, strong) NSTimer *randomBrickTimer;
@property (nonatomic, strong) NSTimer *loseWallChangeTimer;
@property (nonatomic, assign) int randomBrickHitCounter;
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, strong) IBOutlet GLKView *mainView;
@property (nonatomic, strong) IBOutlet UILabel *scoreField;
@property (nonatomic, strong) IBOutlet UILabel *highScoreField;
@property (nonatomic, strong) IBOutlet UIView *pauseView;
@property (nonatomic, strong) IBOutlet UIView *areYouSureView;
@property (nonatomic, strong) IBOutlet UIButton *pauseButton;
@property (nonatomic, strong) NSMutableArray *ballViewArray;
@property (nonatomic, strong) NSMutableArray *randomBrickArray;
@property (nonatomic, strong) RPBPaddle *paddle;
@property (nonatomic, assign) int wallToLose;
@property (nonatomic, strong) NSData *audioFile1;
@property (nonatomic, strong) NSData *audioFile2;
@property (nonatomic, strong) NSData *audioFile3;
@property (nonatomic, strong) NSData *audioFile4;
@property (nonatomic, strong) NSMutableArray *audioPlayers;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) BOOL dontmoveUp;
@property (nonatomic, assign) BOOL dontmoveDown;
@property (nonatomic, assign) int didInvalidate;
@property (nonatomic, assign) int isPaused;
@property (nonatomic, assign) int powerUpEnabled;
@property (nonatomic, assign) int powerUpEnabledEnabled;
@property (nonatomic, assign) int didStartStartPowerUp;
@property (nonatomic, assign) double fireTimeInterval;
@property (nonatomic, assign) BOOL wallEnabled;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL soundIsOn;
@property (nonatomic, assign) BOOL doSlowDown;
@property (nonatomic, assign) BOOL didStartLoseWall;
@property (nonatomic, assign) int didStart;
@property (nonatomic, assign) int didStartPowerUp;
@property (nonatomic, assign) int paddleLocked;
@property (nonatomic, assign) int wallToEnable;
@property (nonatomic, assign) int playcount;
@property (nonatomic, assign) double difficultyMultiplier;
@property (nonatomic, assign) float scoreMultiplier;
@property (nonatomic, assign) BOOL justStartedWallTimer;
@property (nonatomic, assign) CGRect powerUpRect;
@property (nonatomic, assign) CGRect noScoreZone;
@property (nonatomic, assign) CGRect noScoreZone2;
@property (nonatomic, assign) CGRect noScoreZone3;
@property (nonatomic, assign) CGRect noScoreZone4;
@property (nonatomic, assign) float paddleSize;
@property (nonatomic, assign) BOOL pausedAtUI;
@end

