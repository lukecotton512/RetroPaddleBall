//
//  CoreGraphicsDrawingViewController.m
//  CoreGraphicsDrawing
//
//  Created by Luke Cotton on 2/5/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import "CoreGraphicsDrawingViewController.h"
#import "CoreGraphicsDrawingAppDelegate.h"
//#import "RPBRandomRect.h"
#define PADDLESIZE 80
#define PADDLESIZEIPAD 160
#define NOSCOREZONE 30
#define NOSCOREZONEIPAD 60
@implementation CoreGraphicsDrawingViewController
@synthesize ballTimer, mainView, /*bounce, xbounce,*/ topOfScreen, rightOfScreen, leftOfScreen, bottomOfScreen, didStart, speedBounce, speedTimer, scoreField, score, oldBallRect, oldPaddleRect, pauseView, didInvalidate, isPaused, powerUpRect, powerUpEnabled, powerUpTimer, powerUpEnabledEnabled, powerUpImage, didStartPowerUp, powerUpStartedTimer, didStartStartPowerUp, timerToRelease, scoreMultiplier, fireTimeInterval, powerUpImage2, whichPowerUp, difficultyMultiplier, ballImage, ballRect, paddlelocation, paddleImage, paddleLocked, cheatCheckTimer, doAddOnToScore, noScoreZone,noScoreZone2,noScoreZone3,noScoreZone4, accelerometerDelegate, lastTimeUpdate, velocityX, velocityY, xAccel, yAccel, xAccelCali, yAccelCali, wallScoreBoostTimer, wallEnabled, wallToEnable, justStartedWallTimer,bottomOfScreenBall,topOfScreenBall,rightOfScreenBall,leftOfScreenBall, isPlaying, soundIsOn, leftTopRect, rightTopRect, leftBottomRect, rightBottomRect, upperLeftRect, lowerLeftRect, upperRightRect, lowerRightRect, areYouSureView, pauseButton, ballViewArray, powerUpImage3, audioFile1, audioFile2, audioFile3, playcount, ball3, ball2, audioFile4, speedMultiplier, doSlowDown, randomBrickArray, randomBrickTimer, wallToLose, powerUpImage4, highScoreField, didStartLoseWall, loseWallChangeTimer, dontmoveUp, dontmoveDown, randomBrickHitCounter, randomRect1, randomRect2, randomRect3, velocityLockEnabled,velocitySignX, velocitySignY, paddleSize;



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
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
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    isPlaying=NO;
    whichBrick=4;
    powerUpAbsorbed=0;
    playcount=0;
    randomBrickFailed=NO;
    brickIntersectionEnablePowerUp=NO;
    didStartLoseWall=YES;
    wallToLose=4;
    //autoPool = [[NSAutoreleasePool alloc] init];
    ballViewArray = [[NSMutableArray alloc] init];
    xBounceArray = [[NSMutableArray alloc] init];
    bounceArray = [[NSMutableArray alloc] init];
    randomBrickArray=[[NSMutableArray alloc] init];
    ballImage = [[UIView alloc] init];
    CGRect screenSize = [[UIScreen mainScreen] bounds];
	CGRect pauseViewRect = pauseView.frame;
	CGRect newPauseViewRect = CGRectMake((screenSize.size.width/2)-138, (screenSize.size.height/2)-121, pauseViewRect.size.width, pauseViewRect.size.height);
	pauseView.frame = newPauseViewRect;
    CGRect areYouSureViewRect = areYouSureView.frame;
	CGRect newAreYouSureViewRect = CGRectMake((screenSize.size.width/2)-121, (screenSize.size.height/2)-104, areYouSureViewRect.size.width, areYouSureViewRect.size.height);
	areYouSureView.frame = newAreYouSureViewRect;
    ballRect.origin.x = (screenSize.size.width/2)-5;
	ballRect.origin.y = 20;
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
    CGRect paddleImageRect = paddleImage.frame;
    paddleImageRect.size.width = paddleSize;
    paddleImageRect.size.height = paddleSize;
    paddleImage.frame=paddleImageRect;
    paddleImage.center=CGPointMake((screenSize.size.width/2),(screenSize.size.height/2));
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        wallSize = WALLSIZEIPAD;
        wallBorderSize = WALLBORDERIPAD;
        noscorezone=NOSCOREZONEIPAD;
    } else {
        wallSize = WALLSIZE;
        wallBorderSize = WALLBORDERIPAD;
        noscorezone=NOSCOREZONE;
    }
    topOfScreen = mainView.topOfScreen;
	leftOfScreen = mainView.leftOfScreen;
	rightOfScreen = mainView.rightOfScreen;
	bottomOfScreen = mainView.bottomOfScreen;
    topOfScreenBall = mainView.topOfScreenBall;
    leftOfScreenBall = mainView.leftOfScreenBall;
    rightOfScreenBall = mainView.rightOfScreenBall;
    bottomOfScreenBall = mainView.bottomOfScreenBall;
    noScoreZone = CGRectMake(wallSize,wallSize, screenSize.size.width-(wallSize*2), noscorezone);
    noScoreZone2 = CGRectMake(wallSize, noscorezone+wallSize, noscorezone, screenSize.size.height-(noscorezone*2));
    noScoreZone3 = CGRectMake(wallSize, screenSize.size.height-(noscorezone+wallSize), screenSize.size.width-(wallSize*2), noscorezone);
    noScoreZone4 = CGRectMake(screenSize.size.height-(noscorezone+wallSize), noscorezone+wallSize, noscorezone, screenSize.size.height-(noscorezone*2));
    /*audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"BallHit" withExtension:@"aiff"]  error:nil];
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];*/
    /*AudioServicesCreateSystemSoundID((CFURLRef)[[NSBundle mainBundle] URLForResource:@"BallHit" withExtension:@"aiff"], &soundID);
    AudioServicesCreateSystemSoundID((CFURLRef)[[NSBundle mainBundle] URLForResource:@"RetroPaddleBall FX Lightning" withExtension:@"m4a"], &soundID2);
    AudioServicesCreateSystemSoundID((CFURLRef)[[NSBundle mainBundle] URLForResource:@"RetroPaddleBall Slow Down" withExtension:@"m4a"], &soundID3);*/
    paddlelocation = paddleImage.center;
    CGRect tempRect = paddleImage.frame;
    leftTopRect = CGRectMake(tempRect.origin.x, tempRect.origin.y-4, paddleSize/2, 4);
    rightTopRect = CGRectMake(tempRect.origin.x+(paddleSize/2), tempRect.origin.y-4, (paddleSize/2), 4);
    leftBottomRect = CGRectMake(leftTopRect.origin.x, leftTopRect.origin.y+(paddleSize/2), (paddleSize/2), 4);
    rightBottomRect = CGRectMake(rightTopRect.origin.x, rightTopRect.origin.y+paddleSize, (paddleSize/2), 4);
    upperLeftRect = CGRectMake(tempRect.origin.x-4, tempRect.origin.y, 4, (paddleSize/2));
    lowerLeftRect = CGRectMake(tempRect.origin.x-4, tempRect.origin.y+(paddleSize/2), 4, (paddleSize/2));
    upperRightRect = CGRectMake(tempRect.origin.x+paddleSize, tempRect.origin.y, 4, (paddleSize/2));
    lowerRightRect = CGRectMake(tempRect.origin.x+paddleSize, tempRect.origin.y+(paddleSize/2), 4, (paddleSize/2));
    ballImage.frame = ballRect;
    RPBBall *ball1 = [[RPBBall alloc] init];
    ball1.ballView = ballImage;
    ball1.ballRect=ballRect;
    ball1.xBounce=0.0f;
    ball1.bounce=2.0f;
    NSMutableArray *highScoreArray=[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores];
    if ([[[highScoreArray objectAtIndex:0] objectForKey:@"RPBScore"] intValue]!=0) {
        self.highScoreField.text=[NSString stringWithFormat:@"High Score: %d",[[[highScoreArray objectAtIndex:0] objectForKey:@"RPBScore"] intValue],nil];
    }
    [mainView addSubview:ball1.ballView];
    [mainView addSubview:paddleImage];
    [mainView sendSubviewToBack:paddleImage];
    [mainView sendSubviewToBack:ball1.ballView];
    [ballViewArray addObject:ball1];
    [ball1 release];
	[self newGame];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBAccelerometerEnabled"] == YES) {
        accelerometerDelegate = [[CMMotionManager alloc] init];
        accelerometerDelegate.accelerometerUpdateInterval = .05;
        [accelerometerDelegate startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelData,NSError *error){[self accelerometerDidAccelerate:accelData.acceleration.x y:accelData.acceleration.y];}];
    }
	srand(time(NULL));
    audioFile1 = [[NSData alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"BallHit" withExtension:@"m4a"]];
    audioFile2 = [[NSData alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"RetroPaddleBall FX Lightning" withExtension:@"m4a"]];
    audioFile3 = [[NSData alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"RetroPaddleBall Slow Down" withExtension:@"m4a"]];
    audioFile4 = [[NSData alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"RetroPaddleBall Ball Splitter" withExtension:@"m4a"]];
    randomBrickDidStart=YES;
    randomBrickTimer = [NSTimer scheduledTimerWithTimeInterval:21.0 target:self selector:@selector(randomBrickTimerFire:) userInfo:nil repeats:YES];
    [randomBrickTimer fire];
    [randomBrickTimer retain];
     /*audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"RetroPaddleBall FX Lightning" withExtension:@"m4a"]  error:nil];
     audioPlayer3 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"RetroPaddleBall Slow Down" withExtension:@"m4a"]  error:nil];*/
	/*bounce = 1.0f;
	xbounce = 0.0f;
	didStart = 1;
	speedBounce = 0.01;
	topOfScreen = CGRectMake(0, -1, 320, 4);
	leftOfScreen = CGRectMake(1, 0, 4, 480);
	rightOfScreen = CGRectMake(315, 1, 4, 480);
	bottomOfScreen = CGRectMake(0, 479, 320, 4);
	ballTimer = [NSTimer scheduledTimerWithTimeInterval:speedBounce target:self selector:@selector(moveBall:) userInfo:nil repeats:YES];
	[ballTimer retain];
	speedTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(speedUp:) userInfo:nil repeats:YES];
	[speedTimer retain];
	[ballTimer fire];
	[speedTimer fire];*/
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(CGRect)randomRectangle2:(int)j count:(int)k;
{
    if(CGRectIntersectsRect(RANDOMBRICKAREA, paddleImage.frame)){
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
        } else if (j==2) {
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
        } else if (j==2) {
            randomNumberx = (arc4random() % 150) + 19;
            randomNumbery = (arc4random() % 200) + 81;
        }
        randomRect=CGRectMake(randomNumberx, randomNumbery, 80, 30);
    }
	NSLog(@"randomRectangle2: x: %f y: %f j: %i count:%i", randomNumberx, randomNumbery, j, k);
    int i;
    for (i=0;i<[randomBrickArray count];i++) {
        if (CGRectIntersectsRect([[randomBrickArray objectAtIndex:i] rectOfView], randomRect)) {
            randomRect=[self randomRectangle2:j count:k+1];
        }
        if (CGRectIntersectsRect(paddleImage.frame, randomRect)) {
            //CGRect intersectRect = CGRectIntersection(paddleImage.frame, CGRectMake(randomNumberx, randomNumbery, 80, 30));
            randomRect=[self randomRectangle2:j count:k+1];
        }
        if (CGRectIntersectsRect(powerUpImage.frame, randomRect)&&[powerUpImage isDescendantOfView:self.view]) {
            powerUpAbsorbed=1;
            whichBrick=j;
        }
        else if(CGRectIntersectsRect(powerUpImage2.frame, randomRect)&&[powerUpImage2 isDescendantOfView:self.view]){
            powerUpAbsorbed=2;
            whichBrick=j;
        }
        else if (CGRectIntersectsRect(powerUpImage3.frame, randomRect)&&[powerUpImage3 isDescendantOfView:self.view]) {
            powerUpAbsorbed=3;
            whichBrick=j;
        } else if (CGRectIntersectsRect(powerUpImage4.frame, randomRect)&&[powerUpImage4 isDescendantOfView:self.view]) {
            powerUpAbsorbed=4;
            whichBrick=j;
        } else {
            powerUpAbsorbed=0;
        }
    }
    for (i=0; i<[ballViewArray count]; i++) {
        if (CGRectIntersectsRect([[[ballViewArray objectAtIndex:i] ballView] frame], randomRect)) {
            randomRect=[self randomRectangle2:j count:k+1];
        }
    }
    return randomRect;
}
-(CGRect)randomRectangle
{
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        float randomNumberx = (arc4random() % 650) + 38;
        float randomNumbery = (arc4random() % 906) + 38;
        //RPBLOG(@"randomRectangle: x: %f y: %f", randomNumberx, randomNumbery);
        return CGRectMake(randomNumberx, randomNumbery, 40, 40);
    } else {
        float randomNumberx = (arc4random() % 241) + 19;
        float randomNumbery = (arc4random() % 311) + 19;
        //RPBLOG(@"randomRectangle: x: %f y: %f", randomNumberx, randomNumbery);
        return CGRectMake(randomNumberx, randomNumbery, 20, 20);
    }
}
-(double)randomTimerTime
{
    srand(time(NULL));
	return (rand() % 60) + 20;
}
-(void)moveBall:(NSTimer *)theTimer
{
    int i;
    for (i=0; i<[ballViewArray count]; i++) {
        RPBBall *ballPointer=[ballViewArray objectAtIndex:i];
        //CGRect tempRect = CGRectMake(ballPointer.ballRect.origin.x+ballPointer.xBounce, ballPointer.ballRect.origin.y+ballPointer.bounce, 10, 10);
        [self lockPaddle];
        float bounceAngle;
        int potentialScore=0;
        //RPBBall *ballPointer = [ballViewArray objectAtIndex:i];
        float xbounce=ballPointer.xBounce;
        float bounce=ballPointer.bounce;
        //UIView *ballView = ballPointer.ballView;
        CGRect tempRect = ballPointer.ballRect;
        int ballHitCounter = ballPointer.ballHitCounter;
        int ballHitCounterTop = ballPointer.ballHitCounterTop;
        int ballHitCounterLeft = ballPointer.ballHitCounterLeft;
        int ballHitCounterRight = ballPointer.ballHitCounterRight;
        int ballHitCounterScore = ballPointer.ballHitCounterScore;
        CGRect tempRect2 = paddleImage.frame;
        CGRect tempRect3;
        tempRect3.origin.y=tempRect2.origin.y+5;
        tempRect3.origin.x=tempRect2.origin.x-5;
        tempRect3.size.width=tempRect2.size.width+tempRect.size.width;
        tempRect3.size.height=tempRect2.size.height+tempRect.size.height;
        CGRect temptempRect = tempRect;
        temptempRect.origin.y = tempRect.origin.y+bounce;
        CGRect intersectRect = CGRectIntersection(paddleImage.frame,tempRect);
        /*if (doSlowDown==YES) {
            xbounce=(xbounce/speedMultiplier)*(1+speedBounce);
            bounce=(bounce/speedMultiplier)*(1+speedBounce);
            if (i==([ballViewArray count]-1)) {
                speedMultiplier=(1+speedBounce);
                doSlowDown=NO;
            }
        }*/
        if ((CGRectIntersectsRect(powerUpImage.frame, tempRect) && powerUpEnabled ==1 && whichPowerUp ==1) || (brickIntersectionEnablePowerUp==YES&&powerUpAbsorbedTemp==1)) {
            powerUpEnabledEnabled = 1;
            brickIntersectionEnablePowerUp=NO;
            if (whichBrick!=4) {
                [[[randomBrickArray objectAtIndex:whichBrick] rectView] setBackgroundColor:[UIColor greenColor]];
            }
            whichBrick=4;
            powerUpAbsorbed=0;
            didStartStartPowerUp = 1;
            scoreMultiplier = 3.0f;
            [powerUpImage removeFromSuperview];
            powerUpEnabled = 0;
            /*[ballTimer invalidate];
            [ballTimer release];*/
            speedBounce = speedBounce+2;
            /*xbounce=(xbounce/speedMultiplier)*(1+speedBounce);
            bounce=(bounce/speedMultiplier)*(1+speedBounce);*/
            int k;
            for (k=0; k<[ballViewArray count]; k++) {
                RPBBall *ballPointer2=[ballViewArray objectAtIndex:k];
                [ballPointer2 speedUpBall];
            }
            speedMultiplier=(1+speedBounce);
            //self.ballTimer = [NSTimer scheduledTimerWithTimeInterval:speedBounce target:self selector:@selector(moveBall:) userInfo:nil repeats:YES];
            /*[ballTimer retain];
            [ballTimer fire];
            [ballTimer retain];*/
            //doSlowDown=YES;
            self.powerUpStartedTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpEndPowerUp:) userInfo:nil repeats:YES];
            [powerUpStartedTimer fire];
            [powerUpStartedTimer retain];
            [NSThread detachNewThreadSelector:@selector(playSound2) toTarget:self withObject:nil];
            return;
        }
        if ((CGRectIntersectsRect(powerUpImage2.frame, tempRect) && powerUpEnabled ==1 && whichPowerUp ==2) || (brickIntersectionEnablePowerUp==YES&&powerUpAbsorbedTemp==2)){
            powerUpEnabledEnabled = 1;
            brickIntersectionEnablePowerUp=NO;
            if (whichBrick!=4) {
                [[[randomBrickArray objectAtIndex:whichBrick] rectView] setBackgroundColor:[UIColor greenColor]];
            }
            whichBrick=4;
            powerUpAbsorbed=0;
            didStartStartPowerUp = 1;
            scoreMultiplier = 2.0f;
            [powerUpImage2 removeFromSuperview];
            powerUpEnabled = 0;
            /*[ballTimer invalidate];
            [ballTimer release];*/
            speedBounce = speedBounce-2;
            /*xbounce=(xbounce/speedMultiplier)*(1+speedBounce);
            bounce=(bounce/speedMultiplier)*(1+speedBounce);*/
            int k;
            for (k=0; k<[ballViewArray count]; k++) {
                RPBBall *ballPointer2=[ballViewArray objectAtIndex:k];
                [ballPointer2 slowDownBall];
            }
            speedMultiplier=(1+speedBounce);
            /*self.ballTimer = [NSTimer scheduledTimerWithTimeInterval:speedBounce target:self selector:@selector(moveBall:) userInfo:nil repeats:YES];
            [ballTimer retain];
            [ballTimer fire];
            [ballTimer retain];*/
            //doSlowDown=YES;
            self.powerUpStartedTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpEndPowerUp:) userInfo:nil repeats:YES];
            [powerUpStartedTimer fire];
            [powerUpStartedTimer retain];
            [NSThread detachNewThreadSelector:@selector(playSound3) toTarget:self withObject:nil];
            return;
        }
        if ((CGRectIntersectsRect(powerUpImage3.frame, tempRect) && powerUpEnabled ==1 && whichPowerUp == 3)||(brickIntersectionEnablePowerUp==YES&&powerUpAbsorbedTemp==3)){
            //powerUpEnabledEnabled = 1;
            //didStartStartPowerUp = 1;
            brickIntersectionEnablePowerUp=NO;
            if (whichBrick!=4) {
                [[[randomBrickArray objectAtIndex:whichBrick] rectView] setBackgroundColor:[UIColor greenColor]];
            }
            whichBrick=4;
            powerUpAbsorbed=0;
            [powerUpImage3 removeFromSuperview];
            powerUpEnabled = 0;
            //powerUpEnabledEnabled=1;
            /*[ballTimer invalidate];
             [ballTimer release];*/
            RPBBall *currentBall = [ballViewArray objectAtIndex:i];
            RPBBall *newBall=[[RPBBall alloc] init];
            newBall.ballRect=CGRectMake(tempRect.origin.x-(tempRect.size.width+1), tempRect.origin.y, tempRect.size.width, tempRect.size.height);
            newBall.ballView.frame=CGRectMake(tempRect.origin.x-(tempRect.size.width+1), tempRect.origin.y, tempRect.size.width, tempRect.size.height);
            //UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(ballRect.origin.x-1, ballRect.origin.y, 10, 10)];
            newBall.ballView.backgroundColor=[UIColor colorWithRed:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"] green:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"] blue:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"] alpha:100.0f];;
            /*float tempNum = currentBall.xbounce;
             tempNum = -tempNum;*/
            newBall.bounce=currentBall.bounce;
            newBall.xBounce=-(currentBall.xBounce);
            newBall.speedMultiplier=currentBall.speedMultiplier;
            //tempNum = [[bounceArray objectAtIndex:i] floatValue];
            //[bounceArray addObject:[NSNumber numberWithFloat:tempNum]];
            [ballViewArray addObject:newBall];
            [mainView addSubview:newBall.ballView];
            [mainView sendSubviewToBack:newBall.ballView];
            [newBall release];
            [NSThread detachNewThreadSelector:@selector(playSound4) toTarget:self withObject:nil];
        }
        if ((CGRectIntersectsRect(powerUpImage4.frame, tempRect) && powerUpEnabled ==1 && whichPowerUp == 4)||(brickIntersectionEnablePowerUp==YES&&powerUpAbsorbedTemp==4)){
            brickIntersectionEnablePowerUp=NO;
            if (whichBrick!=4) {
                [[[randomBrickArray objectAtIndex:whichBrick] rectView] setBackgroundColor:[UIColor greenColor]];
            }
            whichBrick=4;
            powerUpAbsorbed=0;
            [powerUpImage4 removeFromSuperview];
            powerUpEnabled = 0;
            didStartStartPowerUp=1;
            powerUpEnabledEnabled=1;
            int oldWallToLose=wallToLose;
            while (oldWallToLose==wallToLose||wallToLose==mainView.wallEnabled) {
                wallToLose = (arc4random() % 4) +1;
            }
            mainView.wallToLose=wallToLose;
            [mainView setNeedsDisplay];
            scoreMultiplier=4.0f;
            self.loseWallChangeTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(loseTimeChangeWall:) userInfo:nil repeats:YES];
            didStartLoseWall=YES;
            [loseWallChangeTimer fire];
        }
            if (CGRectIntersectsRect(leftOfScreen, tempRect)) {
                ballHitCounterLeft = ballHitCounterLeft+1;
                if (wallToLose==1) {
                    if ([ballViewArray count]==1) {
                        [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
                        return;
                    } else {
                        [ballPointer.ballView removeFromSuperview];
                        [ballViewArray removeObjectAtIndex:i];
                        return;
                    }
                } else {
                    if (ballHitCounterRight<=1)
                    {
                        [NSThread detachNewThreadSelector:@selector(playSound) toTarget:self withObject:nil];
                        xbounce = -xbounce;
                        xbounce = xbounce+0.01f;
                        if (wallToEnable == 1) {
                            potentialScore += (250*scoreMultiplier);
                        } else {
                            potentialScore += (10*scoreMultiplier);
                    }
                }
                    //[xBounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:xbounce]];
                    //[bounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:bounce]];
                    //ballHitCounterLeft=ballHitCounterLeft +1;
                    ballHitCounterScore = ballHitCounterScore + 1;
                }
                if(ballHitCounterLeft>=5)
                {
                    [self performSelectorOnMainThread:@selector(ballEmergencyRescue:) withObject:[NSArray arrayWithObjects:ballPointer,[NSNumber numberWithInt:(1)],nil] waitUntilDone:YES];
                    return;
                }
            } else if (!CGRectIntersectsRect(leftOfScreen, tempRect)){
                ballHitCounterLeft=0;
            }
            if (CGRectIntersectsRect(rightOfScreen, tempRect)) {
                ballHitCounterRight= ballHitCounterRight+1;
                if (wallToLose==3) {
                    if ([ballViewArray count]==1) {
                        [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
                        return;
                    } else {
                        [ballPointer.ballView removeFromSuperview];
                        [ballViewArray removeObjectAtIndex:i];
                        return;
                    }
                } else {
                    if (ballHitCounterRight<=1)
                    {
                        xbounce = -xbounce;
                        xbounce = xbounce+0.01f;
                        [NSThread detachNewThreadSelector:@selector(playSound) toTarget:self withObject:nil];
                        if (wallToEnable == 3) {
                            potentialScore += (250*scoreMultiplier);
                        } else {
                            potentialScore += (10*scoreMultiplier);
                        }
                        ballHitCounterScore = ballHitCounterScore + 1;
                    //ballHitCounterRight=ballHitCounterRight+1;
                    //[xBounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:xbounce]];
                    //[bounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:bounce]];
                    }
                    if(ballHitCounterRight>=5)
                    {
                        [self performSelectorOnMainThread:@selector(ballEmergencyRescue:) withObject:[NSArray arrayWithObjects:ballPointer,[NSNumber numberWithInt:(3)],nil] waitUntilDone:YES];
                        return;
                    }
                }
            } else if (!CGRectIntersectsRect(rightOfScreen, tempRect)){
                ballHitCounterRight=0;
            }
            if (CGRectIntersectsRect(bottomOfScreen, tempRect)) {
                
                if (wallToLose==4) {
                    if ([ballViewArray count]==1) {
                        [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
                        return;
                    } else {
                        [ballPointer.ballView removeFromSuperview];
                        [ballViewArray removeObjectAtIndex:i];
                        return;
                    }
                } else {
                    bounce = -bounce;
                    bounce = bounce +0.01f;
                    [NSThread detachNewThreadSelector:@selector(playSound) toTarget:self withObject:nil];
                    if (wallToEnable == 6) {
                        potentialScore += (250*scoreMultiplier);
                    } else {
                        potentialScore += (10*scoreMultiplier);
                    }
                    //ballHitCounterTop=ballHitCounterTop+1;
                    ballHitCounterScore = ballHitCounterScore + 1;
                }
            }
            if (CGRectIntersectsRect(topOfScreen, tempRect)) {
                ballHitCounterTop = ballHitCounterTop+1;
                if (wallToLose==2) {
                    if ([ballViewArray count]==1) {
                        [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
                        return;
                    } else {
                        [ballPointer.ballView removeFromSuperview];
                        [ballViewArray removeObjectAtIndex:i];
                        return;
                    }
                } else {
                    if(CGRectIntersectsRect(tempRect2, tempRect))
                    {
                        xbounce= -2.0f;
                        bounce = 0.1f;
                    }
                    if (ballHitCounterTop<=1)
                    {
                        bounce = -bounce;
                        bounce = bounce +0.01f;
                        [NSThread detachNewThreadSelector:@selector(playSound) toTarget:self withObject:nil];
                        if (wallToEnable == 2) {
                            potentialScore += (250*scoreMultiplier);
                        } else {
                            potentialScore += (10*scoreMultiplier);
                        }
                    //ballHitCounterTop=ballHitCounterTop+1;
                        ballHitCounterScore = ballHitCounterScore + 1;
                    }
                    //[bounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:bounce]];
                }
                if(ballHitCounterTop>=5)
                {
                    [self performSelectorOnMainThread:@selector(ballEmergencyRescue:) withObject:[NSArray arrayWithObjects:ballPointer,[NSNumber numberWithInt:(2)],nil] waitUntilDone:YES];
                    return;
                }
            } else if (!CGRectIntersectsRect(topOfScreen, tempRect)){
                ballHitCounterTop=0;
            } if (randomBrickIsEnabled) {
                for (int i=0; i<[randomBrickArray count]; i++) {
                    RPBRandomRect *randomRect = [randomBrickArray objectAtIndex:i];
                    CGRect rectOfBrick = randomRect.rectOfView;
                    if (CGRectIntersectsRect(tempRect, rectOfBrick)) {
                        randomBrickHitCounter +=1;
                    }
                    if (CGRectIntersectsRect(tempRect, rectOfBrick)&&randomBrickHitCounter<=1) {
                        CGRect intersectRect = CGRectIntersection(rectOfBrick, tempRect);
                        if (CGRectIntersectsRect(randomRect.bottomRectBall, tempRect)&&CGRectIntersectsRect(randomRect.bottomRectBall, paddleImage.frame)) {
                            dontmoveUp=YES;
                        } else {
                            dontmoveUp=NO;
                        }
                        if (CGRectIntersectsRect(randomRect.topRectBall, tempRect)&&CGRectIntersectsRect(randomRect.topRectBall, paddleImage.frame)) {
                            dontmoveDown=YES;
                        } else {
                            dontmoveDown=NO;
                        }
                        if ((CGRectIntersectsRect(randomRect.topRectBall, tempRect)||CGRectIntersectsRect(randomRect.bottomRectBall, tempRect)||CGRectIntersectsRect(randomRect.leftRectBall, tempRect)||CGRectIntersectsRect(randomRect.rightRectBall, tempRect))&&(CGRectIntersectsRect(randomRect.topRectBall, paddleImage.frame)||CGRectIntersectsRect(randomRect.bottomRectBall, paddleImage.frame)||CGRectIntersectsRect(randomRect.leftRectBall, paddleImage.frame)||CGRectIntersectsRect(randomRect.rightRectBall, paddleImage.frame))) {
                            dontmove=YES;
                        } else {
                            dontmove=NO;
                        }
                        if (CGRectIntersectsRect(randomRect.topRect, tempRect)&&intersectRect.size.width>intersectRect.size.height) {
                            CGRect tempRect4=ballPointer.ballRect;
                            tempRect4.origin.y=(randomRect.topRect.origin.y-(tempRect.size.height+3));
                            bounce=-bounce+0.1f;
                            ballPointer.ballRect=tempRect4;
                            tempRect=ballPointer.ballRect;
                        }
                        if (CGRectIntersectsRect(randomRect.bottomRect, tempRect)&&intersectRect.size.width>intersectRect.size.height) {
                            CGRect tempRect4=ballPointer.ballRect;
                            tempRect4.origin.y=(randomRect.bottomRect.origin.y+3);
                            bounce=-bounce+0.1f;
                            ballPointer.ballRect=tempRect4;
                            tempRect=ballPointer.ballRect;
                        }
                        if (CGRectIntersectsRect(randomRect.leftRect, tempRect)&&intersectRect.size.width<intersectRect.size.height) {
                            CGRect tempRect4=ballPointer.ballRect;
                            tempRect4.origin.x=(randomRect.leftRect.origin.x-(tempRect.size.height+3));
                            xbounce=-xbounce+0.1f;
                            ballPointer.ballRect=tempRect4;
                            tempRect=ballPointer.ballRect;
                        }
                        if (CGRectIntersectsRect(randomRect.rightRect, tempRect)&&intersectRect.size.width<intersectRect.size.height) {
                            CGRect tempRect4=ballPointer.ballRect;
                            tempRect4.origin.x=(randomRect.rightRect.origin.x+3);
                            xbounce=-xbounce+0.1f;
                            ballPointer.ballRect=tempRect4;
                            tempRect=ballPointer.ballRect;
                        }
                        if (whichBrick==i&&[randomRect powerUpAbsorbed]!=0) {
                            brickIntersectionEnablePowerUp=YES;
                            powerUpAbsorbedTemp=[randomRect powerUpAbsorbed];
                        }
                        potentialScore += 20;
                        [NSThread detachNewThreadSelector:@selector(playSound) toTarget:self withObject:nil];
                    } else if(!CGRectIntersectsRect(tempRect, rectOfBrick)) {
                        randomBrickHitCounter=0;
                    }
                }
            } if (!CGRectIsNull(intersectRect)) {
                if (ballHitCounterScore<1)
                {
                    CGRect intersectRectSideRect1 = CGRectIntersection(tempRect, upperLeftRect);
                    CGRect intersectRectSideRect2 = CGRectIntersection(tempRect, upperRightRect);
                    CGRect intersectRectSideRect3 = CGRectIntersection(tempRect, lowerLeftRect);
                    CGRect intersectRectSideRect4 = CGRectIntersection(tempRect, lowerRightRect);
                    ballHitCounter = ballHitCounter+1;
                    if (((CGRectIntersectsRect(leftTopRect, tempRect))||((intersectRectSideRect1.size.height<intersectRectSideRect1.size.width)&&(!CGRectIsNull(intersectRectSideRect1)))))
                    {
                        if (bounce<FLT_MIN) {
                            goto END;
                        }
                        //xbounce=-ABS(xbounce);
                    }
                    else if(((CGRectIntersectsRect(rightTopRect, tempRect))||((intersectRectSideRect2.size.height<intersectRectSideRect2.size.width)&&(!CGRectIsNull(intersectRectSideRect2)))))
                    {
                        if (bounce<FLT_MIN) {
                            goto END;
                        }
                        //xbounce = ABS(xbounce);
                    }
                    /*if (CGRectIntersectsRect(lowerLeftRect, tempRect)&&CGRectIntersectsRect(upperLeftRect, tempRect)) {
                        goto SKIP;
                    }*/
                   else if (((CGRectIntersectsRect(upperLeftRect, tempRect))||((intersectRectSideRect1.size.height>intersectRectSideRect1.size.width)&&(!CGRectIsNull(intersectRectSideRect1)))))
                    {
                        if (xbounce<=-FLT_MIN) {
                            goto END;
                        }
                        //xbounce=-ABS(xbounce);
                    }
                    else if (((CGRectIntersectsRect(upperRightRect, tempRect)&&ballHitCounter>=1)||((intersectRectSideRect2.size.height>intersectRectSideRect2.size.width)&&(!CGRectIsNull(intersectRectSideRect2)))))
                    {
                        if (xbounce>=FLT_MIN) {
                            goto END;
                        }
                        //xbounce=-ABS(xbounce);
                    }
                    else if (((CGRectIntersectsRect(lowerLeftRect, tempRect)&&ballHitCounter>=1)||((intersectRectSideRect3.size.height>intersectRectSideRect3.size.width)&&(!CGRectIsNull(intersectRectSideRect3)))))
                    {
                        if (xbounce<=-FLT_MIN) {
                            goto END;
                        }
                        //xbounce=-ABS(xbounce);
                    }
                    else if (((CGRectIntersectsRect(lowerRightRect, tempRect)&&ballHitCounter>=1)||((intersectRectSideRect4.size.height>intersectRectSideRect4.size.width)&&(!CGRectIsNull(intersectRectSideRect4)))))
                    {
                        if (xbounce>=FLT_MIN) {
                            goto END;
                        }
                        //xbounce=-ABS(xbounce);
                    }
                    else if (((CGRectIntersectsRect(leftBottomRect, tempRect)&&ballHitCounter>=1)||((intersectRectSideRect3.size.height<intersectRectSideRect3.size.width)&&(!CGRectIsNull(intersectRectSideRect3)))))
                    {
                        if (bounce>=-FLT_MIN) {
                            goto END;
                        }
                        //xbounce=-ABS(xbounce);
                    }
                    else if(((CGRectIntersectsRect(rightBottomRect, tempRect)&&ballHitCounter>=1)||((intersectRectSideRect4.size.height<intersectRectSideRect4.size.width)&&(!CGRectIsNull(intersectRectSideRect4)))))
                    {
                        if (bounce>=-FLT_MIN) {
                            goto END;
                        }
                        //xbounce = ABS(xbounce);
                    }
                SKIP:
                    //xbounce=ballPointer.xBounce;
                    //bounce=ballPointer.bounce;
                    [NSThread detachNewThreadSelector:@selector(playSound) toTarget:self withObject:nil];
                    isPlaying = YES;
                    float whereBallHit = ((tempRect2.origin.x+(tempRect2.size.width/2))-(intersectRect.origin.x+(intersectRect.size.width/2)));
                    float whereBallHit2 = ((tempRect2.origin.y+(tempRect2.size.height/2))-(intersectRect.origin.y+(intersectRect.size.height/2)));
                    potentialScore += (20*scoreMultiplier);
                    if (whereBallHit==0.0f) {
                        whereBallHit=.2f;
                    }
                    if (whereBallHit2==0.0f) {
                        whereBallHit2=0.2f;
                    }
                    whereBallHit = whereBallHit + .2;
                    whereBallHit2 = whereBallHit2 + .2;
                    ballHitCounterScore = ballHitCounterScore + 1;
                    float temp1=(whereBallHit/(tempRect2.size.width/2));
                    float temp2=(whereBallHit2/(tempRect2.size.width/2));
                    BOOL temp1IsNegative=NO;
                    if (temp1<0) {
                        temp1IsNegative=YES;
                        temp1 = -temp1;
                    }
                    if (temp2<0) {
                        temp2=-temp2;
                    }
                    bounceAngle=((60.0f*(M_PI/180)));
                    bounceAngle = (bounceAngle*temp1);
                    float bounceAngle2=((60.0f*(M_PI/180)));
                    bounceAngle2= (bounceAngle2*temp2);
                    float oldXBounce;
                    float oldBounce;
                    intersectRectSideRect1 = CGRectIntersection(tempRect, upperLeftRect);
                    intersectRectSideRect2 = CGRectIntersection(tempRect, upperRightRect);
                    if (((CGRectIntersectsRect(upperLeftRect, tempRect)||CGRectIntersectsRect(lowerLeftRect, tempRect)||CGRectIntersectsRect(upperRightRect, tempRect)||CGRectIntersectsRect(lowerRightRect, tempRect))&&(!(CGRectIntersectsRect(leftBottomRect, tempRect)||CGRectIntersectsRect(leftTopRect, tempRect)||CGRectIntersectsRect(rightTopRect, tempRect)||CGRectIntersectsRect(rightBottomRect, tempRect))))||(intersectRectSideRect1.size.height>intersectRectSideRect1.size.width)||(intersectRectSideRect2.size.height>intersectRectSideRect2.size.width)) {
                        oldXBounce=xbounce;
                        oldBounce=bounce;
                        if (bounceAngle2>0&&(bounceAngle2*(180/M_PI))<30.0f) {
                            bounceAngle2=(30.0f*(M_PI/180));
                        }
                        if (bounceAngle2<0&&(bounceAngle2*(180/M_PI))>-30.0f) {
                            bounceAngle2=(-30.0f*(M_PI/180));
                        }
                        xbounce = cosf(bounceAngle2);
                        bounce = sinf(bounceAngle2);
                    } else {
                        oldXBounce=xbounce;
                        oldBounce=bounce;
                        xbounce = sinf(bounceAngle);
                        bounce = cosf(bounceAngle);
                    }
                    if(bounce>0)
                    {
                        bounce=-bounce;
                    }
                    if (CGRectIntersectsRect(leftTopRect, tempRect)||((intersectRectSideRect1.size.height<intersectRectSideRect1.size.width)&&!CGRectIsNull(intersectRectSideRect2)))
                    {
                        xbounce=-ABS(xbounce);
                    }
                    else if(CGRectIntersectsRect(rightTopRect, tempRect)||((intersectRectSideRect2.size.height<intersectRectSideRect2.size.width)&&!CGRectIsNull(intersectRectSideRect2)))
                    {
                        xbounce = ABS(xbounce);
                    }
                    else if(CGRectIntersectsRect(tempRect, upperLeftRect)||((intersectRectSideRect1.size.height>intersectRectSideRect1.size.width)&&!CGRectIsNull(intersectRectSideRect1)))
                    {
                        if (CGRectIntersectsRect(leftTopRect, tempRect))
                        {
                            xbounce=-xbounce;
                        }
                        xbounce=-xbounce;
                    }
                    else if (CGRectIntersectsRect(tempRect, lowerLeftRect))
                    {
                        xbounce=-xbounce;
                        bounce=-bounce;
                    }
                    else if (CGRectIntersectsRect(tempRect, upperRightRect)||((intersectRectSideRect2.size.height>intersectRectSideRect2.size.width)&&!CGRectIsNull(intersectRectSideRect2)))
                    {
                    }
                    else if (CGRectIntersectsRect(tempRect, lowerRightRect))
                    {
                        bounce=-bounce;
                    }
                    else if (CGRectIntersectsRect(tempRect, leftBottomRect))
                    {
                        bounce=-bounce;
                        xbounce=-ABS(xbounce);
                        CGRect temptemptempRect = tempRect;
                        temptemptempRect.origin.y=tempRect.origin.y+bounce;
                        temptemptempRect.origin.x=tempRect.origin.x+xbounce;
                        if (CGRectIntersectsRect(tempRect2, temptemptempRect)) {
                            bounce=-bounce;
                            tempRect.origin.y=tempRect.origin.y+bounce;
                        }
                    }
                    else if (CGRectIntersectsRect(tempRect, rightBottomRect))
                    {
                        bounce=-bounce;
                        xbounce=ABS(xbounce);
                        CGRect temptemptempRect = tempRect;
                        temptemptempRect.origin.y=tempRect.origin.y+bounce;
                        temptemptempRect.origin.x=tempRect.origin.x+xbounce;
                        if (CGRectIntersectsRect(tempRect2, temptemptempRect)) {
                            bounce=-bounce;
                            tempRect.origin.y=tempRect.origin.y+bounce;
                        }
                    } 
                    if((CGRectIntersectsRect(rightBottomRect, tempRect)&&CGRectIntersectsRect(lowerRightRect, tempRect))||(CGRectIntersectsRect(leftBottomRect, tempRect)&&CGRectIntersectsRect(lowerLeftRect, tempRect)))
                    {
                        bounce=-bounce;
                    }
                    /*xbounce=xbounce*2;
                    bounce=bounce*2;*/
                    //[xBounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:xbounce]];
                    //[bounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:bounce]];
                    if (CGRectIntersectsRect(tempRect2, tempRect) && CGRectIntersectsRect(tempRect, topOfScreen)) {
                        xbounce=-2.0f;
                        bounce=.1f;
                        //[xBounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:xbounce]];
                        //[bounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:bounce]];
                    } else if (CGRectIntersectsRect(tempRect2, tempRect) && CGRectIntersectsRect(tempRect, leftOfScreen)) {
                        bounce=-2.0f;
                        xbounce=-.1f;
                        //[xBounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:xbounce]];
                        //[bounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:bounce]];
                    } else if (CGRectIntersectsRect(tempRect2, tempRect) && CGRectIntersectsRect(tempRect, rightOfScreen)) {
                        bounce=-2.0f;
                        xbounce=.1f;
                        //[xBounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:xbounce]];
                        //[bounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:bounce]];
                    }
                    CGRect temptemptempRect = tempRect;
                    temptemptempRect.origin.y=tempRect.origin.y+bounce;
                    temptemptempRect.origin.x=tempRect.origin.x+xbounce;
                    bounce *=ballPointer.speedMultiplier;
                    xbounce *=ballPointer.speedMultiplier;
                    if (CGRectIntersectsRect(tempRect2, temptemptempRect)&&(intersectRect.origin.y-tempRect2.origin.y)>=56) {
                        bounce=-bounce;
                        //[xBounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:xbounce]];
                        //[bounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:bounce]];
                    }
                }
            } 
            else if (!CGRectIntersectsRect(tempRect2, tempRect)){
                ballHitCounter=0;
            }
        /*for (int j=i; j<[ballViewArray count]; j++) {
            RPBBall *ballPointer1 = [ballViewArray objectAtIndex:j];
            RPBBall *ballPointer2 = [ballViewArray objectAtIndex:i];
            if (CGRectIntersectsRect(ballPointer1.ballRect, ballPointer2.ballRect)&&!CGRectEqualToRect(ballPointer1.ballRect, ballPointer2.ballRect)) {
                if (CGRectIntersection(ballPointer1.ballRect, ballPointer2.ballRect).size.width<CGRectIntersection(ballPointer1.ballRect, ballPointer2.ballRect).size.height) {
                    xbounce=-xbounce;
                    ballPointer1.xBounce=-(ballPointer1.oldxBounce);
                } else {
                    bounce=-bounce;
                    ballPointer1.bounce=-(ballPointer1.oldbounce);
                }
            }
        }*/
            /*if (!CGRectIntersectsRect(CGRectMake(0, 0, 320, 480), tempRect)){
             [self performSelectorOnMainThread:@selector(theEnd) withObject:nil waitUntilDone:YES];
             continue;
             }*/ 
            //[xBounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:xbounce]];
            //[bounceArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:bounce]];
        END:
        //speedMultiplier=(1+speedBounce);
        if((!(CGRectIntersectsRect(noScoreZone, tempRect2) && CGRectIntersectsRect(noScoreZone, tempRect))&&!(CGRectIntersectsRect(noScoreZone2, tempRect2) && CGRectIntersectsRect(noScoreZone2, tempRect))&&!(CGRectIntersectsRect(noScoreZone3, tempRect2) && CGRectIntersectsRect(noScoreZone3, tempRect))&&!(CGRectIntersectsRect(noScoreZone4, tempRect2) && CGRectIntersectsRect(noScoreZone4, tempRect))))
        {
            score += potentialScore;
        
        }
        /*if (![ballViewArray containsObject:ballPointer]) {
            return;
        }*/
        //ballPointer.speedMultiplier=speedMultiplier;
        ballPointer.xBounce=xbounce;
        ballPointer.bounce=bounce;
        ballPointer.ballHitCounter=ballHitCounter;
        ballPointer.ballHitCounterTop=ballHitCounterTop;
        ballPointer.ballHitCounterLeft=ballHitCounterLeft;
        ballPointer.ballHitCounterRight=ballHitCounterRight;
            //ballRect=[[ballViewArray objectAtIndex:i] frame];
        [ballViewArray replaceObjectAtIndex:i withObject:ballPointer];
        [self unlockPaddle];
        tempRect.origin.y=tempRect.origin.y+ballPointer.bounce;
        tempRect.origin.x=tempRect.origin.x+ballPointer.xBounce;
        ballPointer.ballRect=tempRect;
        if (!(CGRectIntersectsRect(tempRect3, tempRect)||CGRectIntersectsRect(tempRect, topOfScreen)||CGRectIntersectsRect(tempRect, leftOfScreen)||CGRectIntersectsRect(tempRect, rightOfScreen))) {
            ballHitCounterScore=0;
        }
        
        //[NSThread detachNewThreadSelector:@selector(calculateBallPosition) toTarget:self withObject:nil];
        scoreField.text=[NSString localizedStringWithFormat:NSLocalizedString(@"SCORE:", nil), score];
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{ballPointer.ballView.center=CGPointMake(CGRectGetMidX(tempRect),CGRectGetMidY(tempRect));} completion:NULL];
        [ballViewArray replaceObjectAtIndex:i withObject:ballPointer];
    }
}
/*-(void)calculateBallPosition:(NSArray *)ballPointerArray
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int i;
    //int j=[ballViewArray count];
    for (i=0; i<[ballViewArray count]; i++) {
    }
    [pool release];
}*/
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
            if (powerUpAbsorbed!=0) {
                [[[randomBrickArray objectAtIndex:i] rectView] setBackgroundColor:[UIColor redColor]];
                if (powerUpAbsorbed==1) {
                    [powerUpImage removeFromSuperview];
                }
                if (powerUpAbsorbed==2) {
                    [powerUpImage2 removeFromSuperview];
                }
                if (powerUpAbsorbed==3) {
                    [powerUpImage3 removeFromSuperview];
                }
                if (powerUpAbsorbed==4) {
                    [powerUpImage4 removeFromSuperview];
                }
                powerUpEnabled=1;
                [(RPBRandomRect *)[randomBrickArray objectAtIndex:i] setPowerUpAbsorbed:powerUpAbsorbed];
            } else {
                [[[randomBrickArray objectAtIndex:i] rectView] setBackgroundColor:[UIColor greenColor]];
            }
            [[randomBrickArray objectAtIndex:i] setRectOfView:randomRect];
            [mainView addSubview:[[randomBrickArray objectAtIndex:i] rectView]];
            [mainView sendSubviewToBack:[[randomBrickArray objectAtIndex:i] rectView]];
            if(i==1) {
                randomRect1=[randomBrickArray objectAtIndex:i];
            } else if(i==2) {
                randomRect2=[randomBrickArray objectAtIndex:i];
            } else if(i==3) {
                randomRect3=[randomBrickArray objectAtIndex:i];
            }
        }
        randomBrickIsEnabled=YES;
        return;
    }
    if(randomBrickIsEnabled==YES) {
        int i;
        for (i=0;i<3;i++) {
            [[[randomBrickArray objectAtIndex:0] rectView] removeFromSuperview];
            [randomBrickArray removeObjectAtIndex:0];
        }
        randomBrickIsEnabled=NO;
        powerUpAbsorbed=0;
        whichBrick=4;
    }
}
-(void)theEnd
{
    [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] endGame];
}
-(void)ballEmergencyRescue:(NSArray *)ballAndSideToFix
{
    int ballSide=[[ballAndSideToFix objectAtIndex:1] intValue];
    RPBBall *ballPointer = [ballAndSideToFix objectAtIndex:0];
    if (ballSide==1) {
        ballPointer.ballRect=CGRectMake(ballPointer.ballRect.origin.x+30, ballPointer.ballRect.origin.y, 10, 10);
        ballPointer.ballView.frame=ballPointer.ballRect;
        if (ballPointer.xBounce<0) {
            ballPointer.xBounce=-(ballPointer.oldxBounce);
        }
    } else if (ballSide==2) {
        ballPointer.ballRect=CGRectMake(ballPointer.ballRect.origin.x, ballPointer.ballRect.origin.y+30, 10, 10);
        ballPointer.ballView.frame=ballPointer.ballRect;
        if (ballPointer.bounce<0) {
            ballPointer.bounce=-(ballPointer.oldbounce);
        }
    } else if (ballSide==3) {
        ballPointer.ballRect=CGRectMake(ballPointer.ballRect.origin.x-30, ballPointer.ballRect.origin.y, 10, 10);
        ballPointer.ballView.frame=ballPointer.ballRect;
        if (ballPointer.xBounce>0) {
            ballPointer.xBounce=-(ballPointer.oldxBounce);
        }
    }
}
-(void)playSound
{
    NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBSound"]== NO) {
        [autoPool release];
        return;
    }
    if(isPlaying==YES&&playcount>=10)
    {
        [autoPool release];
        return;
    }
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:audioFile1  error:nil];
    audioPlayer.volume=.0625f;
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];
    isPlaying=YES;
    playcount=playcount+1;
    [audioPlayer play];
    [autoPool release];
}
-(void)playSound2
{
    NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBSound"]== NO)
        return;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:audioFile2  error:nil];
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    //[audioPlayer autorelease];
    //AudioServicesPlaySystemSound(soundID2);
    [autoPool release];
}
-(void)playSound3
{
    NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBSound"]== NO)
        return;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:audioFile3  error:nil];
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    //[audioPlayer autorelease];
    //AudioServicesPlaySystemSound(soundID3);
    [autoPool release];
}
-(void)playSound4
{
    NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBSound"]== NO)
        return;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:audioFile4  error:nil];
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    //[audioPlayer autorelease];
    //AudioServicesPlaySystemSound(soundID3);
    [autoPool release];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    isPlaying=NO;
    [player release];
    playcount=playcount-1;
}
-(void)wallScoreBoostEnableOrDisable:(NSTimer *)theTimer
{
    if (justStartedWallTimer == YES) {
        justStartedWallTimer = NO;
        return;
    }
    if(wallEnabled == NO)
    {
        srand(time(NULL));
        wallToEnable = (rand() % 3) + 1;
        mainView.wallEnabled = wallToEnable;
        [mainView setNeedsDisplay];
        [wallScoreBoostTimer invalidate];
        [wallScoreBoostTimer release];
        self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
        justStartedWallTimer = YES;
        [wallScoreBoostTimer fire];
        [wallScoreBoostTimer retain];
        wallEnabled = YES;
    } else if (wallEnabled == YES) {
        wallToEnable = 0;
        mainView.wallEnabled = wallToEnable;
        [mainView setNeedsDisplay];
        [wallScoreBoostTimer invalidate];
        [wallScoreBoostTimer release];
        self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:[self randomTimerTime] target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
        justStartedWallTimer = YES;
        [wallScoreBoostTimer fire];
        [wallScoreBoostTimer retain];
        wallEnabled = NO;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBAccelerometerEnabled"]== YES)
    {
        return;
    }
    if(paddleLocked == 1)
        return;
    //RPBLOG(@"Method Called!");
    //CGRect backRect = self.ballRect2;
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
    for (i=0; (i<[randomBrickArray count]&&(stillIntersecting==YES)); i++) {
        RPBRandomRect *brickPointer = [randomBrickArray objectAtIndex:i];
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
                    NSLog(@"Condition Met");
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
                    NSLog(@"Condition Met");
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
                    NSLog(@"Condition Met");
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
                    NSLog(@"Condition Met");
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
            if (!CGRectIntersectsRect(randomRect1.rectOfView, tempRect2)&&!CGRectIntersectsRect(randomRect2.rectOfView, tempRect2)&&!CGRectIntersectsRect(randomRect3.rectOfView, tempRect2)) {
                //goto SKIP4;
                //i=0;
            } else if ((CGRectIntersectsRect(randomRect1.rectOfView, tempRect2)||CGRectIntersectsRect(randomRect2.rectOfView, tempRect2)||CGRectIntersectsRect(randomRect3.rectOfView, tempRect2))&&i==2){
                //return;
            }
            /*if (dontsety==YES&&dontsetx==YES) {
                continue;
            }*/
            /*if (CGRectIntersectsRect(brickPointer.rectOfView, tempRect)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect1.rectOfView)&&CGRectIntersectsRect(randomRect2.rectOfView, tempRect)) {
             return;
             }
             if (CGRectIntersectsRect(brickPointer.rectOfView, tempRect)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect2.rectOfView)&&CGRectIntersectsRect(randomRect2.rectOfView, tempRect)) {
             return;
             }
             if (CGRectIntersectsRect(brickPointer.rectOfView, tempRect)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect3.rectOfView)&&CGRectIntersectsRect(randomRect3.rectOfView, tempRect)) {
             return;
             }*/
            /*if ((CGRectIntersectsRect(brickPointer.topRect, tempRect)&&(intersectRect.size.width>intersectRect.size.height))&&CGRectIntersectsRect(leftOfScreenBall, tempRect))
            {
                paddleImagePointTemp.y=brickPointer.topRect.origin.y-40;
                paddleImagePointTemp.x = leftOfScreenBall.size.width+40;
                //goto SKIP2;
            }
            if ((CGRectIntersectsRect(brickPointer.topRect, tempRect)&&(intersectRect.size.width>intersectRect.size.height))&&CGRectIntersectsRect(rightOfScreenBall, tempRect))
            {
                paddleImagePointTemp.y=brickPointer.topRect.origin.y-40;
                paddleImagePointTemp.x = rightOfScreenBall.origin.x-40;
                //goto SKIP2;
            }
            if((CGRectIntersectsRect(brickPointer.bottomRect, tempRect)&&(intersectRect.size.width>intersectRect.size.height))&&CGRectIntersectsRect(rightOfScreenBall, tempRect))
            {
                paddleImagePointTemp.y=brickPointer.bottomRect.origin.y+40;
                paddleImagePointTemp.x = rightOfScreenBall.origin.x-40;
                //goto SKIP2;
            }
            if((CGRectIntersectsRect(brickPointer.bottomRect, tempRect)&&(intersectRect.size.width>intersectRect.size.height))&&CGRectIntersectsRect(leftOfScreenBall, tempRect))
            {
                paddleImagePointTemp.y=brickPointer.bottomRect.origin.y+40;
                paddleImagePointTemp.x = leftOfScreenBall.size.width+40;
                //goto SKIP2;
            }
            if ((CGRectIntersectsRect(brickPointer.leftRect, tempRect)&&(intersectRect.size.width<intersectRect.size.height))&&CGRectIntersectsRect(topOfScreenBall, tempRect))
            {
                paddleImagePointTemp.x=brickPointer.leftRect.origin.x-40;
                paddleImagePointTemp.y = topOfScreenBall.size.height+40;
                //goto SKIP2;
            }
            if ((CGRectIntersectsRect(brickPointer.leftRect, tempRect)&&(intersectRect.size.width<intersectRect.size.height))&&CGRectIntersectsRect(bottomOfScreenBall, tempRect))
            {
                paddleImagePointTemp.x=brickPointer.leftRect.origin.x-40;
                paddleImagePointTemp.y = bottomOfScreenBall.origin.y-40;
                //goto SKIP2;
            }
            if ((CGRectIntersectsRect(brickPointer.rightRect, tempRect)&&(intersectRect.size.width<intersectRect.size.height))&&CGRectIntersectsRect(topOfScreenBall, tempRect))
            {
                paddleImagePointTemp.x=brickPointer.rightRect.origin.x+40;
                paddleImagePointTemp.y = topOfScreenBall.size.height+40;
                //goto SKIP2;
            }
            if ((CGRectIntersectsRect(brickPointer.rightRect, tempRect)&&(intersectRect.size.width<intersectRect.size.height))&&CGRectIntersectsRect(bottomOfScreenBall, tempRect))
            {
                paddleImagePointTemp.x=brickPointer.rightRect.origin.x+40;
                paddleImagePointTemp.y = bottomOfScreenBall.origin.y-40;
                //goto SKIP2;
            }*/
        }
    }
    if (goThroughAgain==YES&&goThroughAgain2==YES) {
        skip4jump=YES;
        //goto SKIP3;
    }
    /*tempRect.origin.x=location.x-40;
    tempRect.origin.y=location.y-40;
    tempRect.size=CGSizeMake(80, 80);*/
SKIP4:
    for (i=0; i<[ballViewArray count]; i++) {
        RPBBall *ballPointer = [ballViewArray objectAtIndex:i];
        if (CGRectIntersectsRect(tempRect, ballPointer.ballRect)) {
            CGRect intersectRect = CGRectIntersection(tempRect, ballPointer.ballRect);
            CGRect theBallRect = ballPointer.ballRect;
            if (intersectRect.size.width==theBallRect.size.width&&intersectRect.size.height==theBallRect.size.height) {
                //CGRect unionRect = CGRectUnion(tempRect, ballPointer.ballRect);
                /*float tempY=tempRect.origin.y;
                float tempX=tempRect.origin.x;
                float differenceY=ballPointer.ballRect.origin.y-tempY;
                float differenceX=ballPointer.ballRect.origin.x-tempX;*/
                /*if (unionRect.size.width<unionRect.size.height) {
                    float differenceY=tempRect.origin.y-unionRect.size.height;
                    paddleImagePointTemp.y-=differenceY+1;
                } else {
                    float differenceX=tempRect.origin.x-unionRect.size.width;
                    paddleImagePointTemp.x-=differenceX+1;
                }*/
                /*paddleImagePointTemp.x-=differenceX;
                paddleImagePointTemp.y-=differenceY;*/
                return;
            }
            if(CGRectIntersectsRect(CGRectMake(ballPointer.ballRect.origin.x, ballPointer.ballRect.origin.y+1, theBallRect.size.width, 1), tempRect)&&intersectRect.size.width==theBallRect.size.width){
                paddleImagePointTemp.y=paddleImagePointTemp.y-intersectRect.size.height;
                paddleImagePointTemp.x=paddleImagePointTemp.x;
            }
            if(CGRectIntersectsRect(CGRectMake(ballPointer.ballRect.origin.x, ballPointer.ballRect.origin.y+theBallRect.size.height, theBallRect.size.width, 1), tempRect)&&intersectRect.size.width==theBallRect.size.width){
                paddleImagePointTemp.y=paddleImagePointTemp.y+intersectRect.size.height;
                paddleImagePointTemp.x=paddleImagePointTemp.x;
            }
            if(CGRectIntersectsRect(CGRectMake(ballPointer.ballRect.origin.x, ballPointer.ballRect.origin.y, 1, theBallRect.size.height), tempRect)&&intersectRect.size.height==theBallRect.size.height){
                paddleImagePointTemp.x=paddleImagePointTemp.x-intersectRect.size.width;
                paddleImagePointTemp.y=paddleImagePointTemp.y;
            }
            if(CGRectIntersectsRect(CGRectMake(ballPointer.ballRect.origin.x, ballPointer.ballRect.origin.y, 1, theBallRect.size.height), tempRect)&&intersectRect.size.height==theBallRect.size.height){
                paddleImagePointTemp.x=paddleImagePointTemp.x+intersectRect.size.width;
                paddleImagePointTemp.y=paddleImagePointTemp.y;
            }
        }
    }
    /*tempRect.origin.x=location.x-40;
    tempRect.origin.y=location.y-40;
    tempRect.size=CGSizeMake(80, 80);*/
SKIP2:
    /*if (dontsetx) {
        paddleImagePointTemp.x=paddleImage.center.x;
    }
    if (dontsety) {
        paddleImagePointTemp.y=paddleImage.center.y;
    }*/
    paddleImage.center=paddleImagePointTemp;
    tempRect = paddleImage.frame;
    leftTopRect = CGRectMake(tempRect.origin.x, tempRect.origin.y-4, (paddleSize/2), 4);
    rightTopRect = CGRectMake(tempRect.origin.x+(paddleSize/2), tempRect.origin.y-4, (paddleSize/2), 4);
    leftBottomRect = CGRectMake(leftTopRect.origin.x, leftTopRect.origin.y+(paddleSize/2), (paddleSize/2), 4);
    rightBottomRect = CGRectMake(rightTopRect.origin.x, rightTopRect.origin.y+paddleSize, (paddleSize/2), 4);
    upperLeftRect = CGRectMake(tempRect.origin.x-4, tempRect.origin.y, 4, (paddleSize/2));
    lowerLeftRect = CGRectMake(tempRect.origin.x-4, tempRect.origin.y+(paddleSize/2), 4, (paddleSize/2));
    upperRightRect = CGRectMake(tempRect.origin.x+paddleSize, tempRect.origin.y, 4, (paddleSize/2));
    lowerRightRect = CGRectMake(tempRect.origin.x+paddleSize, tempRect.origin.y+(paddleSize/2), 4, (paddleSize/2));
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesBegan:touches withEvent:event];
}
- (void)accelerometerDidAccelerate:(UIAccelerationValue)theX y:(UIAccelerationValue)theY
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBAccelerometerEnabled"]== NO)
    {
        return;
    }
    if(paddleLocked == 1)
        return;
    if(lastTimeUpdate == 0)
    {
        UIAccelerationValue x,y;
        x = theX;
        y = theY;
        xAccel = x;
        yAccel = y;
        xAccelCali = x;
        yAccelCali = y;
        //RPBLOG(@"Calibration: (%f,%f)", xAccelCali, yAccelCali);
        lastTimeUpdate = [[NSDate date] timeIntervalSince1970];
        return;
    }
    UIAccelerationValue x,y;
    x = theX;
    y = theY;
    xAccel = x-xAccelCali;
    yAccel = y-yAccelCali;
    double xPercent = ABS(xAccel/0.125);
    double yPercent = ABS(yAccel/0.125);
    if (xAccel<-0.05) {
        velocityX=-5*xPercent;
    } else if (xAccel>0.05){
        velocityX=5*xPercent;
    } else {
        velocityX=0;
    }
    if (yAccel<-0.05) {
        velocityY=5*yPercent;
    } else if (yAccel>0.05){
        velocityY=-5*yPercent;
    } else {
        velocityY=0;
    }
    CGRect tempRect= paddleImage.frame;
    tempRect.origin.x=(tempRect.origin.x+velocityX);
    tempRect.origin.y=(tempRect.origin.y+velocityY);
    tempRect.size=CGSizeMake(paddleSize, paddleSize);
    CGPoint paddleImagePointTemp = CGPointMake(CGRectGetMidX(tempRect), CGRectGetMidY(tempRect));
    BOOL dontsetx;
    BOOL dontsety;
    int i;
    if (CGRectIntersectsRect(tempRect, topOfScreenBall)) {
        paddleImagePointTemp.y = topOfScreenBall.size.height+((paddleSize/2)+wallSize);
        //dontsety=YES;
        //paddleImagePointTemp.x = location.x;
    }
    if (CGRectIntersectsRect(tempRect, bottomOfScreenBall)) {
        paddleImagePointTemp.y = bottomOfScreenBall.origin.y-(paddleSize/2);
        //dontsety=YES;
        //paddleImagePointTemp.x = location.x;
    } if (CGRectIntersectsRect(tempRect, leftOfScreenBall)) {
        paddleImagePointTemp.x = leftOfScreenBall.size.width+((paddleSize/2)+wallSize);
        //dontsetx=YES;
        //paddleImagePointTemp.y = location.y;
    } if(CGRectIntersectsRect(tempRect, rightOfScreenBall)){
        paddleImagePointTemp.x = rightOfScreenBall.origin.x-(paddleSize/2);
        //dontsetx=YES;
        //paddleImagePointTemp.y = location.y;
    }
    /*if (CGRectIntersectsRect(tempRect, topOfScreenBall)&&CGRectIntersectsRect(tempRect, rightOfScreenBall)) {
     paddleImagePointTemp.y=topOfScreenBall.size.height+44;
     paddleImagePointTemp.x=rightOfScreenBall.origin.x-40;
     }
     if (CGRectIntersectsRect(tempRect, topOfScreenBall)&&CGRectIntersectsRect(tempRect, leftOfScreenBall)) {
     paddleImagePointTemp.y=topOfScreenBall.size.height+44;
     paddleImagePointTemp.x=leftOfScreenBall.size.width+44;
     }
     if (CGRectIntersectsRect(tempRect, bottomOfScreenBall)&&CGRectIntersectsRect(tempRect, rightOfScreenBall)) {
     paddleImagePointTemp.y=bottomOfScreenBall.origin.y-40;
     paddleImagePointTemp.x=rightOfScreenBall.origin.x-40;
     }
     if (CGRectIntersectsRect(tempRect, bottomOfScreenBall)&&CGRectIntersectsRect(tempRect, leftOfScreenBall)) {
     paddleImagePointTemp.y=bottomOfScreenBall.origin.y-40;
     paddleImagePointTemp.x=leftOfScreenBall.size.width+44;
     }*/
    /*if (!(CGRectIntersectsRect(tempRect, rightOfScreenBall)||CGRectIntersectsRect(tempRect, leftOfScreenBall)||CGRectIntersectsRect(tempRect, bottomOfScreenBall)||CGRectIntersectsRect(tempRect, topOfScreenBall))) {
     paddleImagePointTemp = location;
     }*/
    BOOL goThroughAgain, goThroughAgain2;
    goThroughAgain=NO;
    goThroughAgain2=NO;
    BOOL skip4jump=NO;
    /*CGRect intersectRect2 = CGRectIntersection(randomRect2.rectOfView, tempRect);
     if (CGRectIntersectsRect(randomRect2.leftRect, tempRect)&&(intersectRect2.size.height>intersectRect2.size.width)) {
     //paddleImagePointTemp.y=paddleImagePointTemp.y;
     paddleImagePointTemp.x=randomRect2.leftRect.origin.x-40;
     }
     if (CGRectIntersectsRect(randomRect2.rightRect, tempRect)&&(intersectRect2.size.height>intersectRect2.size.width)) {
     //paddleImagePointTemp.y=paddleImagePointTemp.y;
     paddleImagePointTemp.x=randomRect2.rightRect.origin.x+40;
     }
     if (CGRectIntersectsRect(randomRect2.topRect, tempRect)&&(intersectRect2.size.width>intersectRect2.size.height)) {
     //paddleImagePointTemp.x=paddleImagePointTemp.x;
     paddleImagePointTemp.y=randomRect2.topRect.origin.y-40;
     }
     if(CGRectIntersectsRect(randomRect2.bottomRect, tempRect)&&(intersectRect2.size.width>intersectRect2.size.height)) {
     //paddleImagePointTemp.x=paddleImagePointTemp.x;
     paddleImagePointTemp.y=randomRect2.bottomRect.origin.y+40;
     }
     if ((CGRectIntersectsRect(randomRect2.topRect, tempRect))&&CGRectIntersectsRect(topOfScreenBall, tempRect)) {
     return;
     }
     if ((CGRectIntersectsRect(randomRect2.bottomRect, tempRect))&&CGRectIntersectsRect(bottomOfScreenBall, tempRect)) {
     return;
     }
     if ((CGRectIntersectsRect(randomRect2.leftRect, tempRect))&&CGRectIntersectsRect(leftOfScreenBall, tempRect)) {
     return;
     }
     if ((CGRectIntersectsRect(randomRect2.rightRect, tempRect))&&CGRectIntersectsRect(rightOfScreenBall, tempRect)) {
     return;
     }
     CGRect intersectRect3 = CGRectIntersection(randomRect3.rectOfView, tempRect);
     if ((CGRectIntersectsRect(randomRect3.topRect, tempRect))&&CGRectIntersectsRect(topOfScreenBall, tempRect)) {
     return;
     }
     if ((CGRectIntersectsRect(randomRect3.bottomRect, tempRect))&&CGRectIntersectsRect(bottomOfScreenBall, tempRect)) {
     return;
     }
     if ((CGRectIntersectsRect(randomRect3.leftRect, tempRect))&&CGRectIntersectsRect(leftOfScreenBall, tempRect)) {
     return;
     }
     if ((CGRectIntersectsRect(randomRect3.rightRect, tempRect))&&CGRectIntersectsRect(rightOfScreenBall, tempRect)) {
     return;
     }
     if (CGRectIntersectsRect(randomRect3.leftRect, tempRect)&&(intersectRect3.size.height>intersectRect3.size.width)) {
     //paddleImagePointTemp.y=paddleImagePointTemp.y;
     paddleImagePointTemp.x=randomRect3.leftRect.origin.x-40;
     }
     if (CGRectIntersectsRect(randomRect3.rightRect, tempRect)&&(intersectRect3.size.height>intersectRect3.size.width)) {
     //paddleImagePointTemp.y=paddleImagePointTemp.y;
     paddleImagePointTemp.x=randomRect3.rightRect.origin.x+40;
     }
     if (CGRectIntersectsRect(randomRect3.topRect, tempRect)&&(intersectRect3.size.width>intersectRect3.size.height)) {
     //paddleImagePointTemp.x=paddleImagePointTemp.x;
     paddleImagePointTemp.y=randomRect3.topRect.origin.y-40;
     }
     if(CGRectIntersectsRect(randomRect3.bottomRect, tempRect)&&(intersectRect3.size.width>intersectRect3.size.height)) {
     //paddleImagePointTemp.x=paddleImagePointTemp.x;
     paddleImagePointTemp.y=randomRect3.bottomRect.origin.y+40;
     }
     if ((CGRectIntersectsRect(randomRect3.rightRect, tempRect)&&(intersectRect3.size.width>intersectRect3.size.height))&&(CGRectIntersectsRect(randomRect2.bottomRect, tempRect)&&(intersectRect2.size.width>intersectRect2.size.height))) {
     paddleImagePointTemp.x=randomRect3.rightRect.origin.x+40;
     paddleImagePointTemp.y=randomRect2.bottomRect.origin.y+40;
     }
     if ((CGRectIntersectsRect(randomRect3.rightRect, tempRect)&&(intersectRect3.size.width>intersectRect3.size.height))&&(CGRectIntersectsRect(randomRect1.bottomRect, tempRect)&&(intersectRect.size.width>intersectRect.size.height))) {
     paddleImagePointTemp.x=randomRect3.rightRect.origin.x+40;
     paddleImagePointTemp.y=randomRect1.bottomRect.origin.y+40;
     }
     if ((CGRectIntersectsRect(randomRect2.rightRect, tempRect)&&(intersectRect2.size.width>intersectRect2.size.height))&&(CGRectIntersectsRect(randomRect1.bottomRect, tempRect)&&(intersectRect.size.width>intersectRect.size.height))) {
     paddleImagePointTemp.x=randomRect3.rightRect.origin.x+40;
     paddleImagePointTemp.y=randomRect1.bottomRect.origin.y+40;
     }*/
    CGRect tempRect2;
    tempRect2.origin.x=paddleImagePointTemp.x-(paddleSize/2);
    tempRect2.origin.y=paddleImagePointTemp.y-(paddleSize/2);
    tempRect2.size=CGSizeMake(paddleSize, paddleSize);
    BOOL stillIntersecting=YES;
    for (i=0; (i<[randomBrickArray count]&&(stillIntersecting==YES)); i++) {
        RPBRandomRect *brickPointer = [randomBrickArray objectAtIndex:i];
        //CGPoint centerPoint = CGPointMake(CGRectGetMidX(brickPointer.rectOfView), CGRectGetMidY(brickPointer.rectOfView));
        /*if (CGRectContainsPoint(tempRect2, centerPoint)) {
         return;
         }*/
        if (CGRectIntersectsRect(brickPointer.rectOfView, tempRect2)) {
            //return;
            /*if ((intersectRect.origin.y>=brickPointer.rectOfView.origin.y)) {
             return;
             }*/
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
                    NSLog(@"Condition Met");
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
                    NSLog(@"Condition Met");
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
                    NSLog(@"Condition Met");
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
                    NSLog(@"Condition Met");
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
            if (!CGRectIntersectsRect(randomRect1.rectOfView, tempRect2)&&!CGRectIntersectsRect(randomRect2.rectOfView, tempRect2)&&!CGRectIntersectsRect(randomRect3.rectOfView, tempRect2)) {
                //goto SKIP4;
                //i=0;
            } else if ((CGRectIntersectsRect(randomRect1.rectOfView, tempRect2)||CGRectIntersectsRect(randomRect2.rectOfView, tempRect2)||CGRectIntersectsRect(randomRect3.rectOfView, tempRect2))&&i==2){
                //return;
            }
            /*if (dontsety==YES&&dontsetx==YES) {
             continue;
             }*/
            /*if (CGRectIntersectsRect(brickPointer.rectOfView, tempRect)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect1.rectOfView)&&CGRectIntersectsRect(randomRect2.rectOfView, tempRect)) {
             return;
             }
             if (CGRectIntersectsRect(brickPointer.rectOfView, tempRect)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect2.rectOfView)&&CGRectIntersectsRect(randomRect2.rectOfView, tempRect)) {
             return;
             }
             if (CGRectIntersectsRect(brickPointer.rectOfView, tempRect)&&!CGRectEqualToRect(brickPointer.rectOfView, randomRect3.rectOfView)&&CGRectIntersectsRect(randomRect3.rectOfView, tempRect)) {
             return;
             }*/
            /*if ((CGRectIntersectsRect(brickPointer.topRect, tempRect)&&(intersectRect.size.width>intersectRect.size.height))&&CGRectIntersectsRect(leftOfScreenBall, tempRect))
             {
             paddleImagePointTemp.y=brickPointer.topRect.origin.y-40;
             paddleImagePointTemp.x = leftOfScreenBall.size.width+40;
             //goto SKIP2;
             }
             if ((CGRectIntersectsRect(brickPointer.topRect, tempRect)&&(intersectRect.size.width>intersectRect.size.height))&&CGRectIntersectsRect(rightOfScreenBall, tempRect))
             {
             paddleImagePointTemp.y=brickPointer.topRect.origin.y-40;
             paddleImagePointTemp.x = rightOfScreenBall.origin.x-40;
             //goto SKIP2;
             }
             if((CGRectIntersectsRect(brickPointer.bottomRect, tempRect)&&(intersectRect.size.width>intersectRect.size.height))&&CGRectIntersectsRect(rightOfScreenBall, tempRect))
             {
             paddleImagePointTemp.y=brickPointer.bottomRect.origin.y+40;
             paddleImagePointTemp.x = rightOfScreenBall.origin.x-40;
             //goto SKIP2;
             }
             if((CGRectIntersectsRect(brickPointer.bottomRect, tempRect)&&(intersectRect.size.width>intersectRect.size.height))&&CGRectIntersectsRect(leftOfScreenBall, tempRect))
             {
             paddleImagePointTemp.y=brickPointer.bottomRect.origin.y+40;
             paddleImagePointTemp.x = leftOfScreenBall.size.width+40;
             //goto SKIP2;
             }
             if ((CGRectIntersectsRect(brickPointer.leftRect, tempRect)&&(intersectRect.size.width<intersectRect.size.height))&&CGRectIntersectsRect(topOfScreenBall, tempRect))
             {
             paddleImagePointTemp.x=brickPointer.leftRect.origin.x-40;
             paddleImagePointTemp.y = topOfScreenBall.size.height+40;
             //goto SKIP2;
             }
             if ((CGRectIntersectsRect(brickPointer.leftRect, tempRect)&&(intersectRect.size.width<intersectRect.size.height))&&CGRectIntersectsRect(bottomOfScreenBall, tempRect))
             {
             paddleImagePointTemp.x=brickPointer.leftRect.origin.x-40;
             paddleImagePointTemp.y = bottomOfScreenBall.origin.y-40;
             //goto SKIP2;
             }
             if ((CGRectIntersectsRect(brickPointer.rightRect, tempRect)&&(intersectRect.size.width<intersectRect.size.height))&&CGRectIntersectsRect(topOfScreenBall, tempRect))
             {
             paddleImagePointTemp.x=brickPointer.rightRect.origin.x+40;
             paddleImagePointTemp.y = topOfScreenBall.size.height+40;
             //goto SKIP2;
             }
             if ((CGRectIntersectsRect(brickPointer.rightRect, tempRect)&&(intersectRect.size.width<intersectRect.size.height))&&CGRectIntersectsRect(bottomOfScreenBall, tempRect))
             {
             paddleImagePointTemp.x=brickPointer.rightRect.origin.x+40;
             paddleImagePointTemp.y = bottomOfScreenBall.origin.y-40;
             //goto SKIP2;
             }*/
        }
    }
    if (goThroughAgain==YES&&goThroughAgain2==YES) {
        skip4jump=YES;
        //goto SKIP3;
    }
    /*tempRect.origin.x=location.x-40;
     tempRect.origin.y=location.y-40;
     tempRect.size=CGSizeMake(80, 80);*/
SKIP4:
    for (i=0; i<[ballViewArray count]; i++) {
        RPBBall *ballPointer = [ballViewArray objectAtIndex:i];
        if (CGRectIntersectsRect(tempRect, ballPointer.ballRect)) {
            CGRect intersectRect = CGRectIntersection(tempRect, ballPointer.ballRect);
            CGRect tempBallRect = ballPointer.ballRect;
            if (intersectRect.size.width==tempBallRect.size.width&&intersectRect.size.height==tempBallRect.size.height) {
                //CGRect unionRect = CGRectUnion(tempRect, ballPointer.ballRect);
                /*float tempY=tempRect.origin.y;
                 float tempX=tempRect.origin.x;
                 float differenceY=ballPointer.ballRect.origin.y-tempY;
                 float differenceX=ballPointer.ballRect.origin.x-tempX;*/
                /*if (unionRect.size.width<unionRect.size.height) {
                 float differenceY=tempRect.origin.y-unionRect.size.height;
                 paddleImagePointTemp.y-=differenceY+1;
                 } else {
                 float differenceX=tempRect.origin.x-unionRect.size.width;
                 paddleImagePointTemp.x-=differenceX+1;
                 }*/
                /*paddleImagePointTemp.x-=differenceX;
                 paddleImagePointTemp.y-=differenceY;*/
                return;
            }
            if(CGRectIntersectsRect(CGRectMake(ballPointer.ballRect.origin.x, ballPointer.ballRect.origin.y+1, tempBallRect.size.width, 1), tempRect)&&intersectRect.size.width==tempBallRect.size.width){
                paddleImagePointTemp.y=paddleImagePointTemp.y-intersectRect.size.height;
                paddleImagePointTemp.x=paddleImagePointTemp.x;
            }
            if(CGRectIntersectsRect(CGRectMake(ballPointer.ballRect.origin.x, ballPointer.ballRect.origin.y+tempBallRect.size.height, tempBallRect.size.width, 1), tempRect)&&intersectRect.size.width==tempBallRect.size.width){
                paddleImagePointTemp.y=paddleImagePointTemp.y+intersectRect.size.height;
                paddleImagePointTemp.x=paddleImagePointTemp.x;
            }
            if(CGRectIntersectsRect(CGRectMake(ballPointer.ballRect.origin.x, ballPointer.ballRect.origin.y, 1, tempBallRect.size.height), tempRect)&&intersectRect.size.height==tempBallRect.size.height){
                paddleImagePointTemp.x=paddleImagePointTemp.x-intersectRect.size.width;
                paddleImagePointTemp.y=paddleImagePointTemp.y;
            }
            if(CGRectIntersectsRect(CGRectMake(ballPointer.ballRect.origin.x, ballPointer.ballRect.origin.y, 1, tempBallRect.size.height), tempRect)&&intersectRect.size.height==tempBallRect.size.height){
                paddleImagePointTemp.x=paddleImagePointTemp.x+intersectRect.size.width;
                paddleImagePointTemp.y=paddleImagePointTemp.y;
            }
        }
    }
    leftTopRect = CGRectMake(tempRect.origin.x, tempRect.origin.y-4, paddleSize/2, 4);
    rightTopRect = CGRectMake(tempRect.origin.x+(paddleSize/2), tempRect.origin.y-4, (paddleSize/2), 4);
    leftBottomRect = CGRectMake(leftTopRect.origin.x, leftTopRect.origin.y+(paddleSize/2), (paddleSize/2), 4);
    rightBottomRect = CGRectMake(rightTopRect.origin.x, rightTopRect.origin.y+paddleSize, (paddleSize/2), 4);
    upperLeftRect = CGRectMake(tempRect.origin.x-4, tempRect.origin.y, 4, (paddleSize/2));
    lowerLeftRect = CGRectMake(tempRect.origin.x-4, tempRect.origin.y+(paddleSize/2), 4, (paddleSize/2));
    upperRightRect = CGRectMake(tempRect.origin.x+paddleSize, tempRect.origin.y, 4, (paddleSize/2));
    lowerRightRect = CGRectMake(tempRect.origin.x+paddleSize, tempRect.origin.y+(paddleSize/2), 4, (paddleSize/2));
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{paddleImage.center = paddleImagePointTemp;} completion:NULL];
    lastTimeUpdate = [[NSDate date] timeIntervalSince1970];
}
-(void)releaseBallTimer
{
	[timerToRelease invalidate];
	[timerToRelease release];
}
-(void)powerUpCreate:(NSTimer *)theTimer
{
	if(didStartPowerUp == 1)
	{
		didStartPowerUp = 0;
		return;
	}
	if (powerUpEnabledEnabled ==1) {
		return;
	}
	if(powerUpEnabled == 0)
	{
		whichPowerUp = (rand() % 4) +1;
		if(whichPowerUp == 1){
			powerUpEnabled = 1;
			powerUpImage.frame = [self randomRectangle];
			[mainView addSubview:powerUpImage];
            [mainView sendSubviewToBack:powerUpImage];
			return;
		} else if (whichPowerUp == 2) {
			powerUpEnabled = 1;
			powerUpImage2.frame = [self randomRectangle];
			[mainView addSubview:powerUpImage2];
            [mainView sendSubviewToBack:powerUpImage2];
			return;
		} else if (whichPowerUp == 3) {
            powerUpEnabled = 1;
            powerUpImage3.frame = [self randomRectangle];
            [mainView addSubview:powerUpImage3];
            [mainView sendSubviewToBack:powerUpImage3];
            return;
        } else if (whichPowerUp == 4) {
            powerUpEnabled = 1;
            powerUpImage4.frame = [self randomRectangle];
            [mainView addSubview:powerUpImage4];
            [mainView sendSubviewToBack:powerUpImage4];
            return;
        }
	}
	if (powerUpEnabled == 1) {
		if(whichPowerUp == 1) {
			powerUpEnabled = 0;
			[powerUpImage removeFromSuperview];
			return;
		} else if (whichPowerUp == 2) {
			powerUpEnabled = 0;
			[powerUpImage2 removeFromSuperview];
			return;
		} else if (whichPowerUp == 3) {
            powerUpEnabled = 0;
            [powerUpImage3 removeFromSuperview];
            return;
        } else if (whichPowerUp == 4) {
            powerUpEnabled = 0;
            [powerUpImage4 removeFromSuperview];
            return;
        }
	}
}
-(IBAction)pauseGame:(id)sender
{
    if(isPaused == 1)
    {
        return;
    }
	[ballTimer invalidate];
	[ballTimer release];
	[speedTimer invalidate];
	[speedTimer release];
	[powerUpTimer invalidate];
	[powerUpTimer release];
    if ([loseWallChangeTimer isValid]) {
        [loseWallChangeTimer invalidate];
        [loseWallChangeTimer release];
    }
    lastTimeUpdate=0;
    /*[cheatCheckTimer invalidate];
    [cheatCheckTimer release];*/
	if ([powerUpStartedTimer isValid]) {
		NSDate *fireTime = [powerUpStartedTimer fireDate];
		fireTimeInterval = [fireTime timeIntervalSinceNow];
		[powerUpStartedTimer invalidate];
		[powerUpStartedTimer release];
	}
    [wallScoreBoostTimer invalidate];
    [wallScoreBoostTimer release];
    [randomBrickTimer invalidate];
    [randomBrickTimer release];
    randomBrickDidStart = YES;
	[self lockPaddle];
	didStartStartPowerUp = 1;
	didInvalidate = 1;
	isPaused = 1;
    pauseButton.enabled=NO;
	[self.mainView addSubview:pauseView];
}
-(void)loseTimeChangeWall:(NSTimer *)theTimer
{
    if (didStartLoseWall==YES) {
        didStartLoseWall=NO;
        return;
    }
    //RPBLOG(@"wallToLose:%i", wallToLose);
    wallToLose=4;
    scoreMultiplier=1.0f;
    mainView.wallToLose=wallToLose;
    [mainView setNeedsDisplay];
    [theTimer invalidate];
    //[theTimer release];
    powerUpEnabledEnabled=0;
}
-(IBAction)endGame:(id)sender
{
	//[pauseView removeFromSuperview];
    [pauseView removeFromSuperview];
    [mainView addSubview:areYouSureView];
	
}
-(IBAction)yesClicked:(id)sender
{
    [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] endGame];
}
-(IBAction)noClicked:(id)sender
{
    [areYouSureView removeFromSuperview];
    [mainView addSubview:pauseView];
}
-(IBAction)resumeGame:(id)sender
{	
	self.ballTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveBall:) userInfo:nil repeats:YES];
	[ballTimer fire];
	[ballTimer retain];
	didStart = 1;
	didStartPowerUp = 1;
	self.speedTimer = [NSTimer scheduledTimerWithTimeInterval:10.00 target:self selector:@selector(speedUp:) userInfo:nil repeats:YES];
	[speedTimer fire];
	[speedTimer retain];
	powerUpTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpCreate:) userInfo:nil repeats:YES];
	[powerUpTimer fire];
	[powerUpTimer retain];
    randomBrickTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(randomBrickTimerFire:) userInfo:nil repeats:YES];
    [randomBrickTimer fire];
    [randomBrickTimer retain];
    if (powerUpEnabledEnabled==1 && whichPowerUp==4) {
        didStartLoseWall=YES;
        self.loseWallChangeTimer=[NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(loseTimeChangeWall:) userInfo:nil repeats:YES];
        [loseWallChangeTimer fire];
    }
    /*self.cheatCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1.00 target:self selector:@selector(cheatCheck:) userInfo:nil repeats:YES];
    [cheatCheckTimer retain];
    [cheatCheckTimer fire];*/
    if (wallEnabled == YES) {
        self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
    } else {
        self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:[self randomTimerTime] target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
    }
    justStartedWallTimer = YES;
    [wallScoreBoostTimer fire];
    [wallScoreBoostTimer retain];
    [self unlockPaddle];
	if (powerUpEnabledEnabled == 1) {
		self.powerUpStartedTimer = [NSTimer scheduledTimerWithTimeInterval:fireTimeInterval target:self selector:@selector(powerUpEndPowerUp:) userInfo:nil repeats:YES];
		[powerUpStartedTimer fire];
		[powerUpStartedTimer retain];
	}
	didInvalidate = 0;
	isPaused = 0;
    pauseButton.enabled=YES;
	[pauseView removeFromSuperview];
}
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
    for(i=0; i<[ballViewArray count]; i++)
    {
        RPBBall *ballPointer=[ballViewArray objectAtIndex:i];
        ballPointer.xBounce=ballPointer.xBounce/ballPointer.speedMultiplier;
        ballPointer.bounce=ballPointer.bounce/ballPointer.speedMultiplier;
        ballPointer.speedMultiplier=ballPointer.speedMultiplier+.75f;
        ballPointer.xBounce=ballPointer.xBounce*ballPointer.speedMultiplier;
        ballPointer.bounce=ballPointer.bounce*ballPointer.speedMultiplier;
        //[ballViewArray replaceObjectAtIndex:i withObject:ballPointer];
    }
	speedBounce = speedBounce + .5;
	//RPBLOG(@"speedBounce: %lf", speedBounce);
	/*[ballTimer invalidate];
	[ballTimer release];
	self.ballTimer = [NSTimer scheduledTimerWithTimeInterval:speedBounce target:self selector:@selector(moveBall:) userInfo:nil repeats:YES];
	[ballTimer fire];
	[ballTimer retain];*/
	//RPBLOG(@"speedUp: Called");
}
-(void)powerUpEndPowerUp:(NSTimer *)theTimer
{
	if (didStartStartPowerUp == 1) {
		didStartStartPowerUp = 0;
		return;
	}
    int k;
    for (k=0; k<[ballViewArray count]; k++) {
        RPBBall *ballPointer=[ballViewArray objectAtIndex:k];
        if (whichPowerUp == 1) {
            [ballPointer undoSpeedUp];
        } else if (whichPowerUp == 2) {
            [ballPointer undoSlowDown];
        }
    }
	powerUpEnabledEnabled = 0;
	scoreMultiplier = 1.0f;
	[theTimer invalidate];
	[theTimer release];
	//RPBLOG(@"Method Called!");
}
/*-(void)cheatCheck:(NSTimer *)theTimer
{
    
    if (ballHitCounterScore >7) {
        //[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] endGame];
        doAddOnToScore = NO;
        [cheatCheckTimer invalidate];
        [cheatCheckTimer release];
        self.cheatCheckTimer = [NSTimer scheduledTimerWithTimeInterval:10.00 target:self selector:@selector(cheatCheck:) userInfo:nil repeats:YES];
    } else {
        ballHitCounterScore = 0;
        doAddOnToScore = YES;
    }
}*/
-(void)lostGame
{
	if (didInvalidate == 1) {
		mainView.ballRect = mainView.oldBallRect;
		mainView.ballRect2 = mainView.oldPaddleRect;
		isPaused = 1;
		[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] setScore:score];
		return;
	}
	[ballTimer invalidate];
	[speedTimer invalidate];
	[powerUpTimer invalidate];
	if ([powerUpStartedTimer isValid]) {
		[powerUpStartedTimer invalidate];
	}
	
	[ballTimer release];
    [randomBrickTimer invalidate];
    [randomBrickTimer release];
	//[ballTimer release];
 	//RPBLOG(@"ballTimer releasecount: %i", [ballTimer retainCount]);
	[speedTimer release];
	[powerUpTimer release];
	[powerUpStartedTimer release];
    /*[cheatCheckTimer invalidate];
    [cheatCheckTimer release];*/
    [wallScoreBoostTimer invalidate];
    [wallScoreBoostTimer release];
	didInvalidate = 1;
	isPaused = 1;
	mainView.ballRect = mainView.oldBallRect;
	mainView.ballRect2 = mainView.oldPaddleRect;
    //accelerometerDelegate.delegate = nil;
    accelerometerDelegate = nil;
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] setScore:score];
}
-(void)newGame
{
	//bounce = 1.0f;
	//xbounce = 0.0f;
    [bounceArray addObject:[NSNumber numberWithFloat:1.0f]];
    [xBounceArray addObject:[NSNumber numberWithFloat:0.0f]];
    powerUpImage4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    powerUpImage4.backgroundColor=[UIColor redColor];
    doSlowDown=NO;
    score=0;
	didStart = 1;
	didStartPowerUp = 1;
	difficultyMultiplier = [[NSUserDefaults standardUserDefaults] doubleForKey:@"RPBDifficultyMultiplier"];
	didInvalidate = 0;
	isPaused = 0;
	speedBounce = 1.0;
    speedMultiplier=(1);
	/*ballHitCounter = 0;
    ballHitCounterTop = 0;
    ballHitCounterRight = 0;
    ballHitCounterLeft = 0;*/
    //ballHitCounterScore = 0;
	scoreMultiplier = 1.0f;
    doAddOnToScore = YES;
    wallEnabled = NO;
    justStartedWallTimer = YES;
	/*topOfScreen = CGRectMake(0, -1, 320, 5);
	leftOfScreen = CGRectMake(1, 0, 5, 480);
	rightOfScreen = CGRectMake(316, 1, 5, 480);
	bottomOfScreen = CGRectMake(0, 476, 320, 5);
    topOfScreenBall = CGRectMake(0, 0, 320, 19);
    leftOfScreenBall = CGRectMake(0, 0, 19, 480);
    rightOfScreenBall = CGRectMake(301, 0, 19, 480);
    bottomOfScreenBall = CGRectMake(0, 461, 312, 19);*/
    //CGRect screenSize = [[UIScreen mainScreen] bounds];
    self.ballTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveBall:) userInfo:nil repeats:YES];
	[ballTimer retain];
	self.speedTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(speedUp:) userInfo:nil repeats:YES];
	[speedTimer retain];
    /*self.cheatCheckTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(cheatCheck:) userInfo:nil repeats:YES];
    [cheatCheckTimer retain];*/
	self.powerUpTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpCreate:) userInfo:nil repeats:YES];
    double time = [self randomTimerTime];
    self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
    [wallScoreBoostTimer retain];
    /*self.loseWallChangeTimer = [NSTimer scheduledTimerWithTimeInterval:60.00 target:self selector:@selector(loseTimeChangeWall:) userInfo:nil repeats:YES];
    [loseWallChangeTimer fire];*/
    paddleImage.backgroundColor = [UIColor colorWithRed:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"] green:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"] blue:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"] alpha:100.0f];
    RPBBall *ballPointer = [ballViewArray objectAtIndex:0];
    UIView *ballView = ballPointer.ballView;
    ballView.backgroundColor = [UIColor colorWithRed:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"] green:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"] blue:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"] alpha:100.0f];
    ball3.backgroundColor=[UIColor colorWithRed:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"] green:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"] blue:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"] alpha:100.0f];
    ball2.backgroundColor=[UIColor colorWithRed:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"] green:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"] blue:[[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"] alpha:100.0f];
    ballPointer.ballView=ballView;
    [ballViewArray replaceObjectAtIndex:0 withObject:ballPointer];
	[powerUpTimer retain];
	[ballTimer fire];
	[speedTimer fire];
	[powerUpTimer fire];
    //[cheatCheckTimer fire];
    [wallScoreBoostTimer fire];
	[mainView setNeedsDisplay];
}
-(void)lockPaddle
{
	paddleLocked=1;
}
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
	[ballTimer invalidate];
	[ballTimer release];
	[speedTimer invalidate];
	[speedTimer release];
	[powerUpTimer invalidate];
	[powerUpTimer release];
	[powerUpStartedTimer invalidate];
	[powerUpStartedTimer release];
    [randomBrickTimer invalidate];
    [randomBrickTimer release];
    /*[cheatCheckTimer invalidate];
    [cheatCheckTimer release];*/
    [wallScoreBoostTimer invalidate];
    [wallScoreBoostTimer release];
    [scoreField release];
    [pauseView release];
    [areYouSureView release];
    [powerUpImage release];
    [powerUpImage2 release];
    [powerUpImage3 release];
    [powerUpImage4 release];
    [ballImage release];
    [paddleImage release];
    [ballViewArray release];
    [mainView release];
    [audioFile1 release];
    [audioFile2 release];
    [audioFile3 release];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBAccelerometerEnabled"] == YES) {
        //accelerometerDelegate.delegate = nil;
        [accelerometerDelegate stopAccelerometerUpdates];
        accelerometerDelegate = nil;
    }
    [super dealloc];
}

@end
