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
//#import "RPBRandomRect.h"
#define PADDLESIZE 80
#define PADDLESIZEIPAD 160
#define NOSCOREZONE 30
#define NOSCOREZONEIPAD 60
#define WALLSIZE 4
#define WALLSIZEIPAD (WALLSIZE*2)
#define WALLBORDER 15
#define WALLBORDERIPAD (WALLBORDER*2)
typedef struct {
    float Position[3];
    float Color[4];
} Vertex;
Vertex PaddleVertices[4];
Vertex WallVertices[32];
Vertex BallVerticies[4];
Vertex RandomBrickVerticies[4];
Vertex RandomBrickRedVerticies[4];
Vertex PowerUpVerticies[4];
const GLfloat PowerUpVerticiesTexture[] = {
    1.0f, 1.0f,
    1.0f, 0.0f,
    0.0f, 1.0f,
    0.0f, 0.0f
};
const GLubyte PaddleIndicies[] = {
    0,1,2,
    1,3,2
};
const GLubyte BallIndicies[] = {
    0,1,2,
    1,3,2
};
const GLubyte RandomBrickIndicies[] = {
    0,1,2,
    1,3,2
};
const GLubyte WallIndicies[] = {
    0,1,2,
    2,3,0,

    4,5,6,
    6,7,4,
    
    8,9,10,
    10,11,8,
    
    12,13,14,
    14,15,12,
    
    16,17,18,
    18,19,16,
    
    20,21,22,
    21,22,23,
    
    24,25,26,
    26,27,24,
    
    28,29,30,
    29,30,31
};
const GLubyte powerUpIndicies[] = {
    0,1,2,
    1,3,2
};
@implementation CoreGraphicsDrawingViewController
@synthesize ballTimer, mainView, topOfScreen, rightOfScreen, leftOfScreen, bottomOfScreen, didStart, speedBounce, speedTimer, scoreField, score, oldBallRect, oldPaddleRect, pauseView, didInvalidate, isPaused, powerUpRect, powerUpEnabled, powerUpTimer, powerUpEnabledEnabled, didStartPowerUp, powerUpStartedTimer, didStartStartPowerUp, timerToRelease, scoreMultiplier, fireTimeInterval, whichPowerUp, difficultyMultiplier, ballRect, paddlelocation, paddleLocked, cheatCheckTimer, doAddOnToScore, noScoreZone,noScoreZone2,noScoreZone3,noScoreZone4, accelerometerDelegate, lastTimeUpdate, velocityX, velocityY, xAccel, yAccel, xAccelCali, yAccelCali, wallScoreBoostTimer, wallEnabled, wallToEnable, justStartedWallTimer,bottomOfScreenBall,topOfScreenBall,rightOfScreenBall,leftOfScreenBall, isPlaying, soundIsOn, leftTopRect, rightTopRect, leftBottomRect, rightBottomRect, upperLeftRect, lowerLeftRect, upperRightRect, lowerRightRect, areYouSureView, pauseButton, ballViewArray, audioFile1, audioFile2, audioFile3, playcount, audioFile4, speedMultiplier, doSlowDown, randomBrickArray, randomBrickTimer, wallToLose, highScoreField, didStartLoseWall, loseWallChangeTimer, dontmoveUp, dontmoveDown, randomBrickHitCounter, randomRect1, randomRect2, randomRect3, velocityLockEnabled,velocitySignX, velocitySignY, paddleSize, context, paddleEffect;



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
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (self.context == nil) {
        RPBLog(@"Failed to create context");
    }
    mainView.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    self.preferredFramesPerSecond = 60;
}
-(void)setupGL {
    self.paused = NO;
    [EAGLContext setCurrentContext:self.context];
    self.leftWallEffect = [[GLKBaseEffect alloc] init];
    self.rightWallEffect = [[GLKBaseEffect alloc] init];
    self.bottomWallEffect = [[GLKBaseEffect alloc] init];
    self.topWallEffect = [[GLKBaseEffect alloc] init];
    self.leftWallPaddleEffect = [[GLKBaseEffect alloc] init];
    self.rightWallPaddleEffect = [[GLKBaseEffect alloc] init];
    self.bottomWallPaddleEffect = [[GLKBaseEffect alloc] init];
    self.topWallPaddleEffect = [[GLKBaseEffect alloc] init];
    self.paddleEffect = [[GLKBaseEffect alloc] init];
    self.powerUpEffect = [[GLKBaseEffect alloc] init];
    glGenBuffers(1, &_paddleVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _paddleVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(PaddleVertices), PaddleVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_ballVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _ballVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(BallVerticies), BallVerticies, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_wallVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _wallVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(WallVertices), WallVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_paddleIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _paddleIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(PaddleIndicies), PaddleIndicies, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_ballIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ballIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(BallIndicies), BallIndicies, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_wallIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _wallIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6, WallIndicies, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_rightWallIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _rightWallIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6, WallIndicies+6, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_topWallIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _topWallIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6, WallIndicies+12, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_bottomWallIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bottomWallIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6, WallIndicies+18, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_leftWallIndexPaddleBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _leftWallIndexPaddleBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6, WallIndicies+24, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_rightWallIndexPaddleBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _rightWallIndexPaddleBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6, WallIndicies+30, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_topWallIndexPaddleBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _topWallIndexPaddleBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6, WallIndicies+36, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_bottomWallIndexPaddleBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bottomWallIndexPaddleBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6, WallIndicies+42, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_randomBrickVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _randomBrickVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(RandomBrickVerticies), RandomBrickVerticies, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_randomBrickIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _randomBrickIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(RandomBrickIndicies), RandomBrickIndicies, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_randomBrickRedVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _randomBrickRedVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(RandomBrickRedVerticies), RandomBrickRedVerticies, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_powerUpIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _powerUpIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(powerUpIndicies), powerUpIndicies, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_powerUpVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _powerUpVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(PowerUpVerticies), PowerUpVerticies, GL_STATIC_DRAW);
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, 0, self.view.frame.size.height, -1024, 1024);
    
    self.paddleEffect.transform.projectionMatrix = projectionMatrix;
    self.leftWallEffect.transform.projectionMatrix = projectionMatrix;
    self.rightWallEffect.transform.projectionMatrix = projectionMatrix;
    self.bottomWallEffect.transform.projectionMatrix = projectionMatrix;
    self.topWallEffect.transform.projectionMatrix = projectionMatrix;
    self.leftWallPaddleEffect.transform.projectionMatrix = projectionMatrix;
    self.rightWallPaddleEffect.transform.projectionMatrix = projectionMatrix;
    self.bottomWallPaddleEffect.transform.projectionMatrix = projectionMatrix;
    self.topWallPaddleEffect.transform.projectionMatrix = projectionMatrix;
    self.powerUpEffect.transform.projectionMatrix = projectionMatrix;
    
    self.leftWallEffect.colorMaterialEnabled=GL_TRUE;
    self.rightWallEffect.colorMaterialEnabled=GL_TRUE;
    self.topWallEffect.colorMaterialEnabled=GL_TRUE;
    self.bottomWallEffect.colorMaterialEnabled=GL_TRUE;
    self.leftWallPaddleEffect.colorMaterialEnabled=GL_TRUE;
    self.rightWallPaddleEffect.colorMaterialEnabled=GL_TRUE;
    self.topWallPaddleEffect.colorMaterialEnabled=GL_TRUE;
    self.bottomWallPaddleEffect.colorMaterialEnabled=GL_TRUE;
}
-(void)tearDownGL {
    self.paused = YES;
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_ballVertexBuffer);
    glDeleteBuffers(1, &_paddleVertexBuffer);
    glDeleteBuffers(1, &_wallVertexBuffer);
    glDeleteBuffers(1, &_paddleIndexBuffer);
    glDeleteBuffers(1, &_ballIndexBuffer);
    glDeleteBuffers(1, &_wallIndexBuffer);
    glDeleteBuffers(1, &_rightWallIndexBuffer);
    glDeleteBuffers(1, &_topWallIndexBuffer);
    glDeleteBuffers(1, &_bottomWallIndexBuffer);
    glDeleteBuffers(1, &_randomBrickIndexBuffer);
    glDeleteBuffers(1, &_randomBrickRedVertexBuffer);
    glDeleteBuffers(1, &_randomBrickVertexBuffer);
    glDeleteBuffers(1, &_powerUpTextureVertexBuffer);
    glDeleteBuffers(1, &_powerUpVertexBuffer);
    glDeleteBuffers(1, &_powerUpIndexBuffer);
    
    self.paddleEffect = nil;
    self.leftWallEffect = nil;
    self.rightWallEffect = nil;
    self.topWallEffect = nil;
    self.bottomWallEffect = nil;
    self.leftWallPaddleEffect = nil;
    self.rightWallPaddleEffect = nil;
    self.topWallPaddleEffect = nil;
    self.bottomWallPaddleEffect = nil;
    self.powerUpEffect = nil;
    for(RPBBall *ball in ballViewArray) {
        ball.ballEffect = nil;
    }
    if (randomBrickIsEnabled==YES) {
        for (RPBRandomRect *randomRect in randomBrickArray) {
            randomRect.brickBaseEffect = nil;
        }
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self newGame];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self theEnd];
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
	RPBLog(@"randomRectangle2: x: %f y: %f j: %i count:%i", randomNumberx, randomNumbery, j, k);
    int i;
    for (i=0;i<[randomBrickArray count];i++) {
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
    for (i=0; i<[ballViewArray count]; i++) {
        if (CGRectIntersectsRect([ballViewArray[i] ballRect], randomRect)) {
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
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    if (self.paddleEffect==nil || self.leftWallEffect==nil) {
        return;
    }
    if (powerUpEnabled == 1&& whichBrick==4 && powerUpAbsorbed==0) {
        [self.powerUpEffect prepareToDraw];
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _powerUpIndexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _powerUpVertexBuffer);
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribColor, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Color));
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        if (whichPowerUp!=4) {
            glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
            glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 8, PowerUpVerticiesTexture);
        }
        glDrawElements(GL_TRIANGLES, sizeof(powerUpIndicies)/sizeof(powerUpIndicies[0]), GL_UNSIGNED_BYTE, 0);
    }
    [self.paddleEffect prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, _paddleVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _paddleIndexBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Color));
    glDrawElements(GL_TRIANGLES, sizeof(PaddleIndicies)/sizeof(PaddleIndicies[0]), GL_UNSIGNED_BYTE, 0);
    glEnable(GL_BLEND);
    glBindBuffer(GL_ARRAY_BUFFER, _wallVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(WallVertices), WallVertices, GL_STATIC_DRAW);
    [self.leftWallEffect prepareToDraw];
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _wallIndexBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Color));
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
    
    [self.rightWallEffect prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, _wallVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _rightWallIndexBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Color));
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
    
    [self.bottomWallEffect prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, _wallVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bottomWallIndexBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Color));
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
    
    [self.topWallEffect prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, _wallVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _topWallIndexBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Color));
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
    
    [self.leftWallPaddleEffect prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, _wallVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _leftWallIndexPaddleBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Color));
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
    
    [self.rightWallPaddleEffect prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, _wallVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _rightWallIndexPaddleBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Color));
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
    
    [self.bottomWallPaddleEffect prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, _wallVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bottomWallIndexPaddleBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Color));
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
    
    [self.topWallPaddleEffect prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, _wallVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _topWallIndexPaddleBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Color));
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
    
    for (RPBBall *ball in ballViewArray) {
        GLKBaseEffect *ballEffect = ball.ballEffect;
        [ballEffect prepareToDraw];
        glBindBuffer(GL_ARRAY_BUFFER, _ballVertexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ballIndexBuffer);
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Color));
        glDrawElements(GL_TRIANGLES, sizeof(BallIndicies)/sizeof(BallIndicies[0]), GL_UNSIGNED_BYTE, 0);
    }
    if (randomBrickIsEnabled == YES) {
        for (int i=0; i<3; i++) {
            RPBRandomRect *randomRectPointer = randomBrickArray[i];
            GLKBaseEffect *brickBaseEffect = randomRectPointer.brickBaseEffect;
            [brickBaseEffect prepareToDraw];
            if ([randomBrickArray[i] powerUpAbsorbed]!=0) {
                glBindBuffer(GL_ARRAY_BUFFER, _randomBrickRedVertexBuffer);
            } else {
                glBindBuffer(GL_ARRAY_BUFFER, _randomBrickVertexBuffer);
            }
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _randomBrickIndexBuffer);
            glEnableVertexAttribArray(GLKVertexAttribPosition);
            glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
            glEnableVertexAttribArray(GLKVertexAttribColor);
            glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Color));
            glDrawElements(GL_TRIANGLES, sizeof(RandomBrickIndicies)/sizeof(RandomBrickIndicies[0]), GL_UNSIGNED_BYTE, 0);
        }
    }
}
-(void)update {
    GLKMatrix4 modelViewMatrixPaddle = GLKMatrix4Translate(GLKMatrix4Identity, paddleCenter.x-(paddleSize/2), ((self.view.frame.size.height-(paddleCenter.y-(paddleSize/2)))-paddleSize), 0.0f);
    self.paddleEffect.transform.modelviewMatrix = modelViewMatrixPaddle;
    if (wallToLose == 1) {
        for (int i=0; i<4; i++) {
            WallVertices[i].Color[0] = 1.0f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 1.0f;
        }
        for (int i=16; i<20; i++) {
            WallVertices[i].Color[0] = 0.5f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 0.5f;
        }
    }
    else if (wallToEnable == 1) {
        for (int i=0; i<4; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 1.0f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 1.0f;
        }
        for (int i=16; i<20; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 0.5f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 0.5f;
        }
    } else {
        for (int i=0; i<4; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 1.0f;
            WallVertices[i].Color[3] = 1.0f;
        }
        for (int i=16; i<20; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 0.5f;
            WallVertices[i].Color[3] = 0.5f;
        }
    }
    if (wallToLose == 2) {
        for (int i=12; i<16; i++) {
            WallVertices[i].Color[0] = 1.0f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 1.0f;
        }
        for (int i=28; i<32; i++) {
            WallVertices[i].Color[0] = 0.5f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 0.5f;
        }
    } else if (wallToEnable == 2) {
        for (int i=12; i<16; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 1.0f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 1.0f;
        }
        for (int i=28; i<32; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 0.5f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 0.5f;
        }
    } else {
        for (int i=12; i<16; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 1.0f;
            WallVertices[i].Color[3] = 1.0f;
        }
        for (int i=28; i<32; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 0.5f;
            WallVertices[i].Color[3] = 0.5f;
        }
    }
    if (wallToLose == 3) {
        for (int i=4; i<8; i++) {
            WallVertices[i].Color[0] = 1.0f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 1.0f;
        }
        for (int i=20; i<24; i++) {
            WallVertices[i].Color[0] = 0.5f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 0.5f;
        }
    } else if (wallToEnable == 3) {
        for (int i=4; i<8; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 1.0f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 1.0f;
        }
        for (int i=20; i<24; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 0.5f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 0.5f;
        }
    } else {
        for (int i=4; i<8; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 1.0f;
            WallVertices[i].Color[3] = 1.0f;
        }
        for (int i=20; i<24; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 0.5f;
            WallVertices[i].Color[3] = 0.5f;
        }
    }
    if (wallToLose == 4||wallToLose==0) {
        for (int i=8; i<12; i++) {
            WallVertices[i].Color[0] = 1.0f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 1.0f;
        }
        for (int i=24; i<28; i++) {
            WallVertices[i].Color[0] = 0.5f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 0.5f;
        }
    } else if (wallToEnable == 4) {
        for (int i=8; i<12; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 1.0f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 1.0f;
        }
        for (int i=24; i<28; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 0.5f;
            WallVertices[i].Color[2] = 0.0f;
            WallVertices[i].Color[3] = 0.5f;
        }
    } else {
        for (int i=8; i<12; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 1.0f;
            WallVertices[i].Color[3] = 1.0f;
        }
        for (int i=24; i<28; i++) {
            WallVertices[i].Color[0] = 0.0f;
            WallVertices[i].Color[1] = 0.0f;
            WallVertices[i].Color[2] = 0.5f;
            WallVertices[i].Color[3] = 1.0f;
        }
    }
    for (RPBBall *ball in ballViewArray) {
        GLKMatrix4 modelViewMatrixBall = GLKMatrix4Translate(GLKMatrix4Identity, ball.ballRect.origin.x, (self.view.frame.size.height-ball.ballRect.origin.y)-ball.ballRect.size.height, 0.0f);
        ball.ballEffect.transform.modelviewMatrix = modelViewMatrixBall;
    }
    if (randomBrickIsEnabled == YES) {
        for (int i=0; i<3; i++) {
            RPBRandomRect *randomRectPointer = randomBrickArray[i];
            GLKBaseEffect *brickBaseEffect = randomRectPointer.brickBaseEffect;
            brickBaseEffect.transform.modelviewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, randomRectPointer.rectOfView.origin.x, (self.view.frame.size.height-randomRectPointer.rectOfView.origin.y) - randomRectPointer.rectOfView.size.height, 0.0f);
        }
    }
    if (powerUpEnabled == 1&&whichBrick==4&&powerUpAbsorbed==0) {
        GLKMatrix4 modelViewMatrixPowerUp;
        if (whichPowerUp==1) {
            modelViewMatrixPowerUp = GLKMatrix4Translate(GLKMatrix4Identity, powerUpRect.origin.x, (self.view.frame.size.height-powerUpRect.origin.y)-powerUpRect.size.height, 0.0f);
        } else if (whichPowerUp==2) {
            modelViewMatrixPowerUp = GLKMatrix4Translate(GLKMatrix4Identity, powerUpRect2.origin.x, (self.view.frame.size.height-powerUpRect2.origin.y)-powerUpRect2.size.height, 0.0f);
        } else if (whichPowerUp==3) {
            modelViewMatrixPowerUp = GLKMatrix4Translate(GLKMatrix4Identity, powerUpRect3.origin.x, (self.view.frame.size.height-powerUpRect3.origin.y)-powerUpRect3.size.height, 0.0f);
        } else if (whichPowerUp==4) {
            modelViewMatrixPowerUp = GLKMatrix4Translate(GLKMatrix4Identity, powerUpRect4.origin.x, (self.view.frame.size.height-powerUpRect4.origin.y)-powerUpRect4.size.height, 0.0f);
        }
        self.powerUpEffect.transform.modelviewMatrix = modelViewMatrixPowerUp;
    }
}
-(void)moveBall:(NSTimer *)theTimer
{
    int i;
    for (i=0; i<[ballViewArray count]; i++) {
        RPBBall *ballPointer=ballViewArray[i];
        [self lockPaddle];
        float bounceAngle;
        int potentialScore=0;
        float xbounce=ballPointer.xBounce;
        float bounce=ballPointer.bounce;
        CGRect tempRect = ballPointer.ballRect;
        int ballHitCounter = ballPointer.ballHitCounter;
        int ballHitCounterTop = ballPointer.ballHitCounterTop;
        int ballHitCounterLeft = ballPointer.ballHitCounterLeft;
        int ballHitCounterRight = ballPointer.ballHitCounterRight;
        int ballHitCounterScore = ballPointer.ballHitCounterScore;
        CGRect tempRect2 = CGRectMake(paddleCenter.x-(paddleSize/2), paddleCenter.y-(paddleSize/2), paddleSize, paddleSize);
        CGRect tempRect3;
        tempRect3.origin.y=tempRect2.origin.y+5;
        tempRect3.origin.x=tempRect2.origin.x-5;
        tempRect3.size.width=tempRect2.size.width+tempRect.size.width;
        tempRect3.size.height=tempRect2.size.height+tempRect.size.height;
        CGRect temptempRect = tempRect;
        temptempRect.origin.y = tempRect.origin.y+bounce;
        CGRect paddleRect = CGRectMake(paddleCenter.x-paddleSize/2, paddleCenter.y-paddleSize/2, paddleSize, paddleSize);
        CGRect intersectRect = CGRectIntersection(paddleRect,tempRect);
        if ((CGRectIntersectsRect(powerUpRect, tempRect) && powerUpEnabled ==1 && whichPowerUp ==1) || (brickIntersectionEnablePowerUp==YES&&powerUpAbsorbedTemp==1)) {
            powerUpEnabledEnabled = 1;
            brickIntersectionEnablePowerUp=NO;
            if (whichBrick!=4) {
                //[[randomBrickArray[whichBrick] rectView] setBackgroundColor:[UIColor greenColor]];
                [randomBrickArray[whichBrick] setPowerUpAbsorbed:0];
            }
            whichBrick=4;
            powerUpAbsorbed=0;
            didStartStartPowerUp = 1;
            scoreMultiplier = 3.0f;
            powerUpEnabled = 0;
            speedBounce = speedBounce+2;
            int k;
            for (k=0; k<[ballViewArray count]; k++) {
                RPBBall *ballPointer2=ballViewArray[k];
                [ballPointer2 speedUpBall];
            }
            speedMultiplier=(1+speedBounce);
            self.powerUpStartedTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpEndPowerUp:) userInfo:nil repeats:YES];
            [powerUpStartedTimer fire];
            [NSThread detachNewThreadSelector:@selector(playSound2) toTarget:self withObject:nil];
            return;
        }
        if ((CGRectIntersectsRect(powerUpRect2, tempRect) && powerUpEnabled ==1 && whichPowerUp ==2) || (brickIntersectionEnablePowerUp==YES&&powerUpAbsorbedTemp==2)){
            powerUpEnabledEnabled = 1;
            brickIntersectionEnablePowerUp=NO;
            if (whichBrick!=4) {
                //[[randomBrickArray[whichBrick] rectView] setBackgroundColor:[UIColor greenColor]];
                [randomBrickArray[whichBrick] setPowerUpAbsorbed:0];
            }
            whichBrick=4;
            powerUpAbsorbed=0;
            didStartStartPowerUp = 1;
            scoreMultiplier = 2.0f;
            powerUpEnabled = 0;
            speedBounce = speedBounce-2;
            int k;
            for (k=0; k<[ballViewArray count]; k++) {
                RPBBall *ballPointer2=ballViewArray[k];
                [ballPointer2 slowDownBall];
            }
            speedMultiplier=(1+speedBounce);
            self.powerUpStartedTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpEndPowerUp:) userInfo:nil repeats:YES];
            [powerUpStartedTimer fire];
            [NSThread detachNewThreadSelector:@selector(playSound3) toTarget:self withObject:nil];
            return;
        }
        if ((CGRectIntersectsRect(powerUpRect3, tempRect) && powerUpEnabled ==1 && whichPowerUp == 3)||(brickIntersectionEnablePowerUp==YES&&powerUpAbsorbedTemp==3)){
            //powerUpEnabledEnabled = 1;
            //didStartStartPowerUp = 1;
            brickIntersectionEnablePowerUp=NO;
            if (whichBrick!=4) {
                //[[randomBrickArray[whichBrick] rectView] setBackgroundColor:[UIColor greenColor]];
                [randomBrickArray[whichBrick] setPowerUpAbsorbed:0];
            }
            whichBrick=4;
            powerUpAbsorbed=0;
            powerUpEnabled = 0;
            RPBBall *currentBall = ballViewArray[i];
            RPBBall *newBall=[[RPBBall alloc] init];
            newBall.ballRect=CGRectMake(tempRect.origin.x-(tempRect.size.width+1), tempRect.origin.y, tempRect.size.width, tempRect.size.height);
            //UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(ballRect.origin.x-1, ballRect.origin.y, 10, 10)];
            /*float tempNum = currentBall.xbounce;
             tempNum = -tempNum;*/
            newBall.bounce=currentBall.bounce;
            newBall.xBounce=-(currentBall.xBounce);
            newBall.speedMultiplier=currentBall.speedMultiplier;
            newBall.ballEffect = [[GLKBaseEffect alloc] init];
            newBall.ballEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, 0, self.view.frame.size.height, -1024, 1024);
            //tempNum = [[bounceArray objectAtIndex:i] floatValue];
            //[bounceArray addObject:[NSNumber numberWithFloat:tempNum]];
            [ballViewArray addObject:newBall];
            //[mainView addSubview:newBall.ballView];
            //[mainView sendSubviewToBack:newBall.ballView];
            [NSThread detachNewThreadSelector:@selector(playSound4) toTarget:self withObject:nil];
        }
        if ((CGRectIntersectsRect(powerUpRect4, tempRect) && powerUpEnabled ==1 && whichPowerUp == 4)||(brickIntersectionEnablePowerUp==YES&&powerUpAbsorbedTemp==4)){
            brickIntersectionEnablePowerUp=NO;
            if (whichBrick!=4) {
                //[[randomBrickArray[whichBrick] rectView] setBackgroundColor:[UIColor greenColor]];
                [randomBrickArray[whichBrick] setPowerUpAbsorbed:0];
            }
            whichBrick=4;
            powerUpAbsorbed=0;
            powerUpEnabled = 0;
            didStartStartPowerUp=1;
            powerUpEnabledEnabled=1;
            int oldWallToLose=wallToLose;
            while (oldWallToLose==wallToLose||wallToLose==wallEnabled) {
                wallToLose = (arc4random() % 4) +1;
            }
            //mainView.wallToLose=wallToLose;
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
                    [self performSelectorOnMainThread:@selector(ballEmergencyRescue:) withObject:@[ballPointer,@1] waitUntilDone:YES];
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
                        [self performSelectorOnMainThread:@selector(ballEmergencyRescue:) withObject:@[ballPointer,@3] waitUntilDone:YES];
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
                        //[ballPointer.ballView removeFromSuperview];
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
                    [self performSelectorOnMainThread:@selector(ballEmergencyRescue:) withObject:@[ballPointer,@2] waitUntilDone:YES];
                    return;
                }
            } else if (!CGRectIntersectsRect(topOfScreen, tempRect)){
                ballHitCounterTop=0;
            } if (randomBrickIsEnabled) {
                for (int i=0; i<[randomBrickArray count]; i++) {
                    RPBRandomRect *randomRect = randomBrickArray[i];
                    CGRect rectOfBrick = randomRect.rectOfView;
                    if (CGRectIntersectsRect(tempRect, rectOfBrick)) {
                        randomBrickHitCounter +=1;
                    }
                    if (CGRectIntersectsRect(tempRect, rectOfBrick)&&randomBrickHitCounter<=1) {
                        CGRect intersectRect = CGRectIntersection(rectOfBrick, tempRect);
                        if (CGRectIntersectsRect(randomRect.bottomRectBall, tempRect)&&CGRectIntersectsRect(randomRect.bottomRectBall, paddleRect)) {
                            dontmoveUp=YES;
                        } else {
                            dontmoveUp=NO;
                        }
                        if (CGRectIntersectsRect(randomRect.topRectBall, tempRect)&&CGRectIntersectsRect(randomRect.topRectBall, paddleRect)) {
                            dontmoveDown=YES;
                        } else {
                            dontmoveDown=NO;
                        }
                        if ((CGRectIntersectsRect(randomRect.topRectBall, tempRect)||CGRectIntersectsRect(randomRect.bottomRectBall, tempRect)||CGRectIntersectsRect(randomRect.leftRectBall, tempRect)||CGRectIntersectsRect(randomRect.rightRectBall, tempRect))&&(CGRectIntersectsRect(randomRect.topRectBall, paddleRect)||CGRectIntersectsRect(randomRect.bottomRectBall, paddleRect)||CGRectIntersectsRect(randomRect.leftRectBall, paddleRect)||CGRectIntersectsRect(randomRect.rightRectBall, paddleRect))) {
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
                    ballHitCounter = ballHitCounter+1;
                    [NSThread detachNewThreadSelector:@selector(playSound) toTarget:self withObject:nil];
                    isPlaying = YES;
                    float whereBallHit = ((intersectRect.origin.x+(intersectRect.size.width/2))-(tempRect2.origin.x+(tempRect2.size.width/2)));
                    float whereBallHit2 = ((intersectRect.origin.y+(intersectRect.size.height/2))-(tempRect2.origin.y+(tempRect2.size.height/2)));
                    potentialScore += (20*scoreMultiplier);
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
                    if (CGRectIntersectsRect(leftTopRect, tempRect)&&(intersectRect.size.height<intersectRect.size.width))
                    {
                        bounce=-ABS(bounce);
                        xbounce=-ABS(xbounce);
                    }
                    else if(CGRectIntersectsRect(rightTopRect, tempRect)&&(intersectRect.size.height<intersectRect.size.width))
                    {
                        bounce=-ABS(bounce);
                        xbounce=ABS(xbounce);
                    }
                    else if(CGRectIntersectsRect(tempRect, upperLeftRect)&&(intersectRect.size.height>intersectRect.size.width))
                    {
                        bounce=-ABS(bounce);
                        xbounce=-ABS(xbounce);
                    }
                    else if(CGRectIntersectsRect(tempRect, upperRightRect)&&(intersectRect.size.height>intersectRect.size.width))
                    {
                        bounce=-ABS(bounce);
                        xbounce=ABS(xbounce);
                    }
                    else if (CGRectIntersectsRect(tempRect, leftBottomRect)&&(intersectRect.size.height<intersectRect.size.width))
                    {
                        bounce=ABS(bounce);
                        xbounce=-ABS(xbounce);
                    }
                    else if (CGRectIntersectsRect(tempRect, rightBottomRect)&&(intersectRect.size.height<intersectRect.size.width))
                    {
                        bounce=ABS(bounce);
                        xbounce=ABS(xbounce);
                    }
                    else if (CGRectIntersectsRect(tempRect, lowerLeftRect)&&(intersectRect.size.height>intersectRect.size.width))
                    {
                        bounce=ABS(bounce);
                        xbounce=-ABS(xbounce);
                    }
                    else if (CGRectIntersectsRect(tempRect, lowerRightRect)&&(intersectRect.size.height>intersectRect.size.width))
                    {
                        bounce=ABS(bounce);
                        xbounce=ABS(xbounce);
                    }
                    bounce *=ballPointer.speedMultiplier;
                    xbounce *=ballPointer.speedMultiplier;
                    /*CGRect temptemptempRect = tempRect;
                    temptemptempRect.origin.y=tempRect.origin.y+bounce;
                    temptemptempRect.origin.x=tempRect.origin.x+xbounce;
                    if (CGRectIntersectsRect(tempRect2, temptemptempRect)&&(intersectRect.origin.y-tempRect2.origin.y)>=56) {
                        bounce=-bounce;
                    }*/
                }
            } 
            else if (!CGRectIntersectsRect(tempRect2, tempRect)){
                ballHitCounter=0;
            }
        END:
        if((!(CGRectIntersectsRect(noScoreZone, tempRect2) && CGRectIntersectsRect(noScoreZone, tempRect))&&!(CGRectIntersectsRect(noScoreZone2, tempRect2) && CGRectIntersectsRect(noScoreZone2, tempRect))&&!(CGRectIntersectsRect(noScoreZone3, tempRect2) && CGRectIntersectsRect(noScoreZone3, tempRect))&&!(CGRectIntersectsRect(noScoreZone4, tempRect2) && CGRectIntersectsRect(noScoreZone4, tempRect))))
        {
            score += potentialScore;
        
        }
        ballPointer.xBounce=xbounce;
        ballPointer.bounce=bounce;
        ballPointer.ballHitCounter=ballHitCounter;
        ballPointer.ballHitCounterTop=ballHitCounterTop;
        ballPointer.ballHitCounterLeft=ballHitCounterLeft;
        ballPointer.ballHitCounterRight=ballHitCounterRight;
        ballViewArray[i] = ballPointer;
        [self unlockPaddle];
        tempRect.origin.y=tempRect.origin.y+ballPointer.bounce;
        tempRect.origin.x=tempRect.origin.x+ballPointer.xBounce;
        ballPointer.ballRect=tempRect;
        if (!(CGRectIntersectsRect(tempRect3, tempRect)||CGRectIntersectsRect(tempRect, topOfScreen)||CGRectIntersectsRect(tempRect, leftOfScreen)||CGRectIntersectsRect(tempRect, rightOfScreen))) {
            ballHitCounterScore=0;
        }
        scoreField.text=[NSString localizedStringWithFormat:NSLocalizedString(@"SCORE:", nil), score];
        ballViewArray[i] = ballPointer;
    }
}
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
            [randomBrickArray[i] setBrickBaseEffect:[[GLKBaseEffect alloc] init]];
            [randomBrickArray[i] brickBaseEffect].transform.projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, 0, self.view.frame.size.height, -1024, 1024);
            if (powerUpAbsorbed!=0) {
                //[[randomBrickArray[i] rectView] setBackgroundColor:[UIColor redColor]];
                [randomBrickArray[i] brickBaseEffect].constantColor = GLKVector4Make(1.0, 0.0, 0.0, 1.0);
                [randomBrickArray[i] brickBaseEffect].useConstantColor = GL_TRUE;
                /*if (powerUpAbsorbed==1) {
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
                }*/
                powerUpEnabled=1;
                [(RPBRandomRect *)randomBrickArray[i] setPowerUpAbsorbed:powerUpAbsorbed];
            } else {
                [randomBrickArray[i] brickBaseEffect].constantColor = GLKVector4Make(0.0, 0.0, 1.0, 1.0);
                [randomBrickArray[i] brickBaseEffect].useConstantColor = GL_TRUE;
                //[[randomBrickArray[i] rectView] setBackgroundColor:[UIColor greenColor]];
            }
            [randomBrickArray[i] setRectOfView:randomRect];
            //[mainView addSubview:[randomBrickArray[i] rectView]];
            //[mainView sendSubviewToBack:[randomBrickArray[i] rectView]];
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
            //[[randomBrickArray[0] rectView] removeFromSuperview];
            [randomBrickArray removeObjectAtIndex:0];
        }
        randomBrickIsEnabled=NO;
        powerUpAbsorbed=0;
        whichBrick=4;
    }
}
-(void)theEnd
{
    [self lostGame];
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] setScore:score];
    [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] endGame];
    UIStoryboard *theStoryboard;
    if([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        theStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPad" bundle:nil];
    } else {
        theStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPhone" bundle:nil];
    }
    GameOverViewController *gameOver = [theStoryboard instantiateViewControllerWithIdentifier:@"GameOverScene"];
    UINavigationController *naviControl = [self navigationController];
    [naviControl presentViewController:gameOver animated:YES completion:NULL];
    
}
-(IBAction)createNewGame:(UIStoryboardSegue *)sender {
    
}
-(void)playSound
{
    @autoreleasepool {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBSound"]== NO) {
            return;
        }
        if(isPlaying==YES&&playcount>=10)
        {
            return;
        }
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:audioFile1  error:nil];
        audioPlayer.volume=.0625f;
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
        isPlaying=YES;
        playcount=playcount+1;
        [audioPlayer play];
    }
}
-(void)playSound2
{
    @autoreleasepool {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBSound"]== NO)
            return;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:audioFile2  error:nil];
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    //[audioPlayer autorelease];
    //AudioServicesPlaySystemSound(soundID2);
    }
}
-(void)playSound3
{
    @autoreleasepool {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBSound"]== NO)
            return;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:audioFile3  error:nil];
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    //[audioPlayer autorelease];
    //AudioServicesPlaySystemSound(soundID3);
    }
}
-(void)playSound4
{
    @autoreleasepool {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBSound"]== NO)
            return;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:audioFile4  error:nil];
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    //[audioPlayer autorelease];
    //AudioServicesPlaySystemSound(soundID3);
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    isPlaying=NO;
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
        //mainView.wallEnabled = wallToEnable;
        [mainView setNeedsDisplay];
        [wallScoreBoostTimer invalidate];
        self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
        justStartedWallTimer = YES;
        [wallScoreBoostTimer fire];
        wallEnabled = YES;
    } else if (wallEnabled == YES) {
        wallToEnable = 0;
        //mainView.wallEnabled = wallToEnable;
        [mainView setNeedsDisplay];
        [wallScoreBoostTimer invalidate];
        self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:[self randomTimerTime] target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
        justStartedWallTimer = YES;
        [wallScoreBoostTimer fire];
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
            if (!CGRectIntersectsRect(randomRect1.rectOfView, tempRect2)&&!CGRectIntersectsRect(randomRect2.rectOfView, tempRect2)&&!CGRectIntersectsRect(randomRect3.rectOfView, tempRect2)) {
                //goto SKIP4;
                //i=0;
            } else if ((CGRectIntersectsRect(randomRect1.rectOfView, tempRect2)||CGRectIntersectsRect(randomRect2.rectOfView, tempRect2)||CGRectIntersectsRect(randomRect3.rectOfView, tempRect2))&&i==2){
                //return;
            }
        }
    }
    if (goThroughAgain==YES&&goThroughAgain2==YES) {
        skip4jump=YES;
        //goto SKIP3;
    }
SKIP4:
    for (i=0; i<[ballViewArray count]; i++) {
        RPBBall *ballPointer = ballViewArray[i];
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
        paddleImagePointTemp.x=paddleCenter.x;
    }
    if (dontsety) {
        paddleImagePointTemp.y=paddleCenter.y;
    }*/
    paddleCenter=paddleImagePointTemp;
    tempRect = CGRectMake(paddleCenter.x-(paddleSize/2), paddleCenter.y-(paddleSize/2), paddleSize, paddleSize);
    
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
    CGRect tempRect= CGRectMake(paddleCenter.x-(paddleSize/2), paddleCenter.y-(paddleSize/2), paddleSize, paddleSize);
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
        RPBRandomRect *brickPointer = randomBrickArray[i];
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
            if (!CGRectIntersectsRect(randomRect1.rectOfView, tempRect2)&&!CGRectIntersectsRect(randomRect2.rectOfView, tempRect2)&&!CGRectIntersectsRect(randomRect3.rectOfView, tempRect2)) {
                //goto SKIP4;
                //i=0;
            } else if ((CGRectIntersectsRect(randomRect1.rectOfView, tempRect2)||CGRectIntersectsRect(randomRect2.rectOfView, tempRect2)||CGRectIntersectsRect(randomRect3.rectOfView, tempRect2))&&i==2){
                //return;
            }
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
        RPBBall *ballPointer = ballViewArray[i];
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
    //[UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{paddleCenter = paddleImagePointTemp;} completion:NULL];
    lastTimeUpdate = [[NSDate date] timeIntervalSince1970];
}
-(void)releaseBallTimer
{
	[timerToRelease invalidate];
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
			powerUpRect = [self randomRectangle];
            for (int i=0; i<4; i++) {
                PowerUpVerticies[i].Color[0] = 1.0f;
                PowerUpVerticies[i].Color[1] = 1.0f;
                PowerUpVerticies[i].Color[2] = 1.0f;
                PowerUpVerticies[i].Color[3] = 1.0f;
            }
            glBindBuffer(GL_ARRAY_BUFFER, _powerUpVertexBuffer);
            glBufferData(GL_ARRAY_BUFFER, sizeof(PowerUpVerticies), PowerUpVerticies, GL_STATIC_DRAW);
            self.powerUpEffect.texture2d0.name = self.powerUpTexture1.name;
            self.powerUpEffect.texture2d0.enabled = GL_TRUE;
            self.powerUpEffect.texture2d0.envMode = GLKTextureEnvModeDecal;
			return;
		} else if (whichPowerUp == 2) {
			powerUpEnabled = 1;
			powerUpRect2 = [self randomRectangle];
            for (int i=0; i<4; i++) {
                PowerUpVerticies[i].Color[0] = 1.0f;
                PowerUpVerticies[i].Color[1] = 1.0f;
                PowerUpVerticies[i].Color[2] = 1.0f;
                PowerUpVerticies[i].Color[3] = 1.0f;
            }
            glBindBuffer(GL_ARRAY_BUFFER, _powerUpVertexBuffer);
            glBufferData(GL_ARRAY_BUFFER, sizeof(PowerUpVerticies), PowerUpVerticies, GL_STATIC_DRAW);
            self.powerUpEffect.texture2d0.name = self.powerUpTexture2.name;
            self.powerUpEffect.texture2d0.enabled = GL_TRUE;
            self.powerUpEffect.texture2d0.envMode = GLKTextureEnvModeDecal;
			return;
		} else if (whichPowerUp == 3) {
            powerUpEnabled = 1;
            powerUpRect3 = [self randomRectangle];
            for (int i=0; i<4; i++) {
                PowerUpVerticies[i].Color[0] = BallVerticies[i].Color[0];
                PowerUpVerticies[i].Color[1] = BallVerticies[i].Color[1];
                PowerUpVerticies[i].Color[2] = BallVerticies[i].Color[2];
                PowerUpVerticies[i].Color[3] = 1.0f;
            }
            glBindBuffer(GL_ARRAY_BUFFER, _powerUpVertexBuffer);
            glBufferData(GL_ARRAY_BUFFER, sizeof(PowerUpVerticies), PowerUpVerticies, GL_STATIC_DRAW);
            self.powerUpEffect.texture2d0.name = self.powerUpTexture3.name;
            self.powerUpEffect.texture2d0.enabled = GL_TRUE;
            self.powerUpEffect.texture2d0.envMode = GLKTextureEnvModeDecal;
            return;
        } else if (whichPowerUp == 4) {
            powerUpEnabled = 1;
            powerUpRect4 = [self randomRectangle];
            for (int i=0; i<4; i++) {
                PowerUpVerticies[i].Color[0] = 1.0f;
                PowerUpVerticies[i].Color[1] = 0.0f;
                PowerUpVerticies[i].Color[2] = 0.0f;
                PowerUpVerticies[i].Color[3] = 1.0f;
            }
            glBindBuffer(GL_ARRAY_BUFFER, _powerUpVertexBuffer);
            glBufferData(GL_ARRAY_BUFFER, sizeof(PowerUpVerticies), PowerUpVerticies, GL_STATIC_DRAW);
            self.powerUpEffect.texture2d0.enabled = GL_FALSE;
            return;
        }
	}
	if (powerUpEnabled == 1) {
		powerUpEnabled=0;
	}
}
-(IBAction)pauseGame:(id)sender
{
    if(isPaused == 1)
    {
        return;
    }
	[ballTimer invalidate];
	[speedTimer invalidate];
	[powerUpTimer invalidate];
    if ([loseWallChangeTimer isValid]) {
        [loseWallChangeTimer invalidate];
    }
    lastTimeUpdate=0;
    /*[cheatCheckTimer invalidate];
    [cheatCheckTimer release];*/
	if ([powerUpStartedTimer isValid]) {
		NSDate *fireTime = [powerUpStartedTimer fireDate];
		fireTimeInterval = [fireTime timeIntervalSinceNow];
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
    //RPBLOG(@"wallToLose:%i", wallToLose);
    wallToLose=4;
    scoreMultiplier=1.0f;
    //mainView.wallToLose=wallToLose;
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
	self.ballTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveBall:) userInfo:nil repeats:YES];
	[ballTimer fire];
	didStart = 1;
	didStartPowerUp = 1;
	self.speedTimer = [NSTimer scheduledTimerWithTimeInterval:10.00 target:self selector:@selector(speedUp:) userInfo:nil repeats:YES];
	[speedTimer fire];
	powerUpTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpCreate:) userInfo:nil repeats:YES];
	[powerUpTimer fire];
    randomBrickTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(randomBrickTimerFire:) userInfo:nil repeats:YES];
    [randomBrickTimer fire];
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
        RPBBall *ballPointer=ballViewArray[i];
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
        RPBBall *ballPointer=ballViewArray[k];
        if (whichPowerUp == 1) {
            [ballPointer undoSpeedUp];
        } else if (whichPowerUp == 2) {
            [ballPointer undoSlowDown];
        }
    }
	powerUpEnabledEnabled = 0;
	scoreMultiplier = 1.0f;
	[theTimer invalidate];
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
	[ballTimer invalidate];
	[speedTimer invalidate];
	[powerUpTimer invalidate];
	if ([powerUpStartedTimer isValid]) {
		[powerUpStartedTimer invalidate];
	}
	for (RPBBall *aBall in ballViewArray) {
        aBall.ballEffect = nil;
    }
    powerUpEnabled=0;
    [randomBrickTimer invalidate];
    [pauseButton setEnabled:YES];
    [wallScoreBoostTimer invalidate];
	didInvalidate = 1;
	isPaused = 1;
	//mainView.ballRect = mainView.oldBallRect;
	//mainView.ballRect2 = mainView.oldPaddleRect;
    accelerometerDelegate = nil;
    [self tearDownGL];
}
-(void)newGame
{
    isPlaying=NO;
    whichBrick=4;
    powerUpAbsorbed=0;
    playcount=0;
    randomBrickFailed=NO;
    brickIntersectionEnablePowerUp=NO;
    randomBrickIsEnabled=NO;
    didStartLoseWall=YES;
    wallToLose=4;
    wallToEnable = 0;
    //mainView.wallToLose=wallToLose;
    ballViewArray = [[NSMutableArray alloc] init];
    randomBrickArray=[[NSMutableArray alloc] init];
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
    // setup verticies
    CGRect mainViewFrame = mainView.frame;
    float multiplyFactor;
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        multiplyFactor = 2.0f;
    } else {
        multiplyFactor = 1.0f;
    }
    //Define verticies for the ball, paddle, and wall
    PaddleVertices[0].Position[0]=paddleSize;
    PaddleVertices[0].Position[1]=paddleSize;
    PaddleVertices[0].Position[2]=0.0f;
    PaddleVertices[1].Position[0]=paddleSize;
    PaddleVertices[1].Position[1]=0.0f;
    PaddleVertices[1].Position[2]=0.0f;
    PaddleVertices[2].Position[0]=0.0f;
    PaddleVertices[2].Position[1]=paddleSize;
    PaddleVertices[2].Position[2]=0.0f;
    PaddleVertices[3].Position[0]=0.0f;
    PaddleVertices[3].Position[1]=0.0f;
    PaddleVertices[3].Position[2]=0.0f;
    BallVerticies[0].Position[0]=10.0f*multiplyFactor;
    BallVerticies[0].Position[1]=10.0f*multiplyFactor;
    BallVerticies[0].Position[2]=0.0f;
    BallVerticies[1].Position[0]=10.0f*multiplyFactor;
    BallVerticies[1].Position[1]=0.0f;
    BallVerticies[1].Position[2]=0.0f;
    BallVerticies[2].Position[0]=0.0f;
    BallVerticies[2].Position[1]=10.0f*multiplyFactor;
    BallVerticies[2].Position[2]=0.0f;
    BallVerticies[3].Position[0]=0.0f;
    BallVerticies[3].Position[1]=0.0f;
    BallVerticies[3].Position[2]=0.0f;
    //Random Brick Verticies
    RandomBrickVerticies[0].Position[0] = 80.0f*multiplyFactor;
    RandomBrickVerticies[0].Position[1] = 30.0f*multiplyFactor;
    RandomBrickVerticies[0].Position[2] = 0.0f;
    RandomBrickVerticies[1].Position[0] = 80.0f*multiplyFactor;
    RandomBrickVerticies[1].Position[1] = 0.0f;
    RandomBrickVerticies[1].Position[2] = 0.0f;
    RandomBrickVerticies[2].Position[0] = 0.0f;
    RandomBrickVerticies[2].Position[1] = 30.0f*multiplyFactor;
    RandomBrickVerticies[2].Position[2] = 0.0f;
    RandomBrickVerticies[3].Position[0] = 0.0f;
    RandomBrickVerticies[3].Position[1] = 0.0f;
    RandomBrickVerticies[3].Position[2] = 0.0f;
    // Power up verticies
    PowerUpVerticies[0].Position[0] = 20.0f*multiplyFactor;
    PowerUpVerticies[0].Position[1] = 20.0f*multiplyFactor;
    PowerUpVerticies[0].Position[2] = 0.0f;
    PowerUpVerticies[1].Position[0] = 20.0f*multiplyFactor;
    PowerUpVerticies[1].Position[1] = 0.0f;
    PowerUpVerticies[1].Position[2] = 0.0f;
    PowerUpVerticies[2].Position[0] = 0.0f;
    PowerUpVerticies[2].Position[1] = 20.0f*multiplyFactor;
    PowerUpVerticies[2].Position[2] = 0.0f;
    PowerUpVerticies[3].Position[0] = 0.0f;
    PowerUpVerticies[3].Position[1] = 0.0f;
    PowerUpVerticies[3].Position[2] = 0.0f;
    //Left wall
    WallVertices[0].Position[0]=0.0f;
    WallVertices[0].Position[1]=mainViewFrame.size.height;
    WallVertices[0].Position[2]=0.0f;
    WallVertices[1].Position[0]=4.0f*multiplyFactor;
    WallVertices[1].Position[1]=mainViewFrame.size.height;
    WallVertices[1].Position[2]=0.0f;
    WallVertices[2].Position[0]=4.0f*multiplyFactor;
    WallVertices[2].Position[1]=0.0f;
    WallVertices[2].Position[2]=0.0f;
    WallVertices[3].Position[0]=0.0f;
    WallVertices[3].Position[1]=0.0f;
    WallVertices[3].Position[2]=0.0f;
    //Right Wall
    WallVertices[4].Position[0]=mainViewFrame.size.width-4.0f*multiplyFactor;
    WallVertices[4].Position[1]=mainViewFrame.size.height;
    WallVertices[4].Position[2]=0.0f;
    WallVertices[5].Position[0]=mainViewFrame.size.width;
    WallVertices[5].Position[1]=mainViewFrame.size.height;
    WallVertices[5].Position[2]=0.0f;
    WallVertices[6].Position[0]=mainViewFrame.size.width;
    WallVertices[6].Position[1]=0.0f;
    WallVertices[6].Position[2]=0.0f;
    WallVertices[7].Position[0]=mainViewFrame.size.width-4.0f*multiplyFactor;
    WallVertices[7].Position[1]=0.0f;
    WallVertices[7].Position[2]=0.0f;
    //Bottom Wall
    WallVertices[8].Position[0]=0.0f;
    WallVertices[8].Position[1]=0.0f;
    WallVertices[8].Position[2]=0.0f;
    WallVertices[9].Position[0]=mainViewFrame.size.width;
    WallVertices[9].Position[1]=0.0f;
    WallVertices[9].Position[2]=0.0f;
    WallVertices[10].Position[0]=mainViewFrame.size.width;
    WallVertices[10].Position[1]=4.0f*multiplyFactor;
    WallVertices[10].Position[2]=0.0f;
    WallVertices[11].Position[0]=0.0f;
    WallVertices[11].Position[1]=4.0f*multiplyFactor;
    WallVertices[11].Position[2]=0.0f;
    //Top Wall
    WallVertices[12].Position[0]=0.0f;
    WallVertices[12].Position[1]=mainViewFrame.size.height;
    WallVertices[12].Position[2]=0.0f;
    WallVertices[13].Position[0]=mainViewFrame.size.width;
    WallVertices[13].Position[1]=mainViewFrame.size.height;
    WallVertices[13].Position[2]=0.0f;
    WallVertices[14].Position[0]=mainViewFrame.size.width;
    WallVertices[14].Position[1]=mainViewFrame.size.height-4.0f*multiplyFactor;
    WallVertices[14].Position[2]=0.0f;
    WallVertices[15].Position[0]=0.0f;
    WallVertices[15].Position[1]=mainViewFrame.size.height-4.0f*multiplyFactor;
    WallVertices[15].Position[2]=0.0f;
    //Left paddle wall
    WallVertices[16].Position[0]=4.0f*multiplyFactor;
    WallVertices[16].Position[1]=mainViewFrame.size.height-4.0f*multiplyFactor;
    WallVertices[16].Position[2]=0.0f;
    WallVertices[17].Position[0]=19.0f*multiplyFactor;
    WallVertices[17].Position[1]=mainViewFrame.size.height-4.0f*multiplyFactor;
    WallVertices[17].Position[2]=0.0f;
    WallVertices[18].Position[0]=19.0f*multiplyFactor;
    WallVertices[18].Position[1]=4.0f*multiplyFactor;
    WallVertices[18].Position[2]=0.0f;
    WallVertices[19].Position[0]=4.0f*multiplyFactor;
    WallVertices[19].Position[1]=4.0f*multiplyFactor;
    WallVertices[19].Position[2]=0.0f;
    //Right paddle Wall
    WallVertices[20].Position[0]=mainViewFrame.size.width-4.0f*multiplyFactor;
    WallVertices[20].Position[1]=mainViewFrame.size.height-4.0f*multiplyFactor;
    WallVertices[20].Position[2]=0.0f;
    WallVertices[21].Position[0]=mainViewFrame.size.width-19.0f*multiplyFactor;
    WallVertices[21].Position[1]=mainViewFrame.size.height-4.0f*multiplyFactor;
    WallVertices[21].Position[2]=0.0f;
    WallVertices[22].Position[0]=mainViewFrame.size.width-4.0f*multiplyFactor;
    WallVertices[22].Position[1]=4.0f*multiplyFactor;
    WallVertices[22].Position[2]=0.0f;
    WallVertices[23].Position[0]=mainViewFrame.size.width-19.0f*multiplyFactor;
    WallVertices[23].Position[1]=4.0f*multiplyFactor;
    WallVertices[23].Position[2]=0.0f;
    //Bottom paddle Wall
    WallVertices[24].Position[0]=4.0f*multiplyFactor;
    WallVertices[24].Position[1]=4.0f*multiplyFactor;
    WallVertices[24].Position[2]=0.0f;
    WallVertices[25].Position[0]=mainViewFrame.size.width-4.0f*multiplyFactor;
    WallVertices[25].Position[1]=4.0f*multiplyFactor;
    WallVertices[25].Position[2]=0.0f;
    WallVertices[26].Position[0]=mainViewFrame.size.width-4.0f*multiplyFactor;
    WallVertices[26].Position[1]=19.0f*multiplyFactor;
    WallVertices[26].Position[2]=0.0f;
    WallVertices[27].Position[0]=4.0f*multiplyFactor;
    WallVertices[27].Position[1]=19.0f*multiplyFactor;
    WallVertices[27].Position[2]=0.0f;
    //Top paddle Wall
    WallVertices[28].Position[0]=4.0f*multiplyFactor;
    WallVertices[28].Position[1]=mainViewFrame.size.height-4.0*multiplyFactor;
    WallVertices[28].Position[2]=0.0f;
    WallVertices[29].Position[0]=mainViewFrame.size.width-4.0f*multiplyFactor;
    WallVertices[29].Position[1]=mainViewFrame.size.height-4.0f*multiplyFactor;
    WallVertices[29].Position[2]=0.0f;
    WallVertices[30].Position[0]=4.0f*multiplyFactor;
    WallVertices[30].Position[1]=mainViewFrame.size.height-19.0f*multiplyFactor;
    WallVertices[30].Position[2]=0.0f;
    WallVertices[31].Position[0]=mainViewFrame.size.width-4.0f*multiplyFactor;
    WallVertices[31].Position[1]=mainViewFrame.size.height-19.0f*multiplyFactor;
    WallVertices[31].Position[2]=0.0f;
    PaddleVertices[0].Color[0] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"]/255;
    PaddleVertices[0].Color[1] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"]/255;
    PaddleVertices[0].Color[2] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"]/255;
    PaddleVertices[0].Color[3] = 1.0f;
    PaddleVertices[1].Color[0] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"]/255;
    PaddleVertices[1].Color[1] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"]/255;
    PaddleVertices[1].Color[2] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"]/255;
    PaddleVertices[1].Color[3] = 1.0f;
    PaddleVertices[2].Color[0] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"]/255;
    PaddleVertices[2].Color[1] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"]/255;
    PaddleVertices[2].Color[2] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"]/255;
    PaddleVertices[2].Color[3] = 1.0f;
    PaddleVertices[3].Color[0] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"]/255;
    PaddleVertices[3].Color[1] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"]/255;
    PaddleVertices[3].Color[2] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"]/255;
    PaddleVertices[3].Color[3] = 1.0f;
    BallVerticies[0].Color[0] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"]/255;
    BallVerticies[0].Color[1] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"]/255;
    BallVerticies[0].Color[2] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"]/255;
    BallVerticies[0].Color[3] = 1.0f;
    BallVerticies[1].Color[0] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"]/255;
    BallVerticies[1].Color[1] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"]/255;
    BallVerticies[1].Color[2] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"]/255;
    BallVerticies[1].Color[3] = 1.0f;
    BallVerticies[2].Color[0] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"]/255;
    BallVerticies[2].Color[1] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"]/255;
    BallVerticies[2].Color[2] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"]/255;
    BallVerticies[2].Color[3] = 1.0f;
    BallVerticies[3].Color[0] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"]/255;
    BallVerticies[3].Color[1] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"]/255;
    BallVerticies[3].Color[2] = [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"]/255;
    BallVerticies[3].Color[3] = 1.0f;
    for (int i=0; i<16; i++) {
        WallVertices[i].Color[0]=0.0f;
        WallVertices[i].Color[1]=0.0f;
        WallVertices[i].Color[2]=1.0f;
        WallVertices[i].Color[3]=1.0f;
    }
    for (int i=16; i<32; i++) {
        WallVertices[i].Color[0]=0.0f;
        WallVertices[i].Color[1]=0.0f;
        WallVertices[i].Color[2]=0.5f;
        WallVertices[i].Color[3]=1.0f;
    }
    for (int i=0; i<4; i++) {
        RandomBrickVerticies[i].Color[0] = 0.0f;
        RandomBrickVerticies[i].Color[1] = 1.0f;
        RandomBrickVerticies[i].Color[2] = 0.0f;
        RandomBrickVerticies[i].Color[3] = 1.0f;
    }
    memcpy(RandomBrickRedVerticies, RandomBrickVerticies, sizeof(RandomBrickVerticies));
    for (int i=0; i<4; i++) {
        RandomBrickRedVerticies[i].Color[0] = 1.0f;
        RandomBrickRedVerticies[i].Color[1] = 0.0f;
        RandomBrickRedVerticies[i].Color[2] = 0.0f;
        RandomBrickRedVerticies[i].Color[3] = 1.0f;
    }
    for (int i=0; i<4; i++) {
        PowerUpVerticies[i].Color[0] = 1.0f;
        PowerUpVerticies[i].Color[1] = 1.0f;
        PowerUpVerticies[i].Color[2] = 1.0f;
        PowerUpVerticies[i].Color[3] = 1.0f;
    }
    if ([UIScreen mainScreen].scale>1.0f) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            self.powerUpTexture1 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LightningBolt@2x~iPad.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture2 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SlowDown@2x~iPad.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture3 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BallSplit@2x~iPad.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
        } else {
            self.powerUpTexture1 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LightningBolt@2x.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture2 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SlowDown@2x.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture3 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BallSplit@2x.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
        }
    } else {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            self.powerUpTexture1 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LightningBolt~iPad.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture2 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SlowDown~iPad.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture3 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BallSplit~iPad.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
        } else {
            self.powerUpTexture1 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LightningBolt.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture2 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SlowDown.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
            self.powerUpTexture3 = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BallSplit.png" ofType:nil] options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:nil];
        }
    }
    [self setupGL];
    CGRect paddleImageRect = CGRectMake(paddleCenter.x-(paddleSize/2), paddleCenter.y-(paddleSize/2), paddleSize, paddleSize);
    paddleImageRect.size.width = paddleSize;
    paddleImageRect.size.height = paddleSize;
    paddleCenter=CGPointMake((screenSize.size.width/2),(screenSize.size.height/2));
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
    //paddlelocation = paddleCenter;
    CGRect tempRect = CGRectMake(paddleCenter.x-(paddleSize/2), paddleCenter.y-(paddleSize/2), paddleSize, paddleSize);
    leftTopRect = CGRectMake(tempRect.origin.x, tempRect.origin.y-4, paddleSize/2, 4);
    rightTopRect = CGRectMake(tempRect.origin.x+(paddleSize/2), tempRect.origin.y-4, (paddleSize/2), 4);
    leftBottomRect = CGRectMake(leftTopRect.origin.x, leftTopRect.origin.y+(paddleSize/2), (paddleSize/2), 4);
    rightBottomRect = CGRectMake(rightTopRect.origin.x, rightTopRect.origin.y+paddleSize, (paddleSize/2), 4);
    upperLeftRect = CGRectMake(tempRect.origin.x-4, tempRect.origin.y, 4, (paddleSize/2));
    lowerLeftRect = CGRectMake(tempRect.origin.x-4, tempRect.origin.y+(paddleSize/2), 4, (paddleSize/2));
    upperRightRect = CGRectMake(tempRect.origin.x+paddleSize, tempRect.origin.y, 4, (paddleSize/2));
    lowerRightRect = CGRectMake(tempRect.origin.x+paddleSize, tempRect.origin.y+(paddleSize/2), 4, (paddleSize/2));
    RPBBall *ball1 = [[RPBBall alloc] init];
    ball1.ballRect=ballRect;
    ball1.xBounce=0.0f;
    ball1.bounce=2.0f;
    ball1.ballEffect = [[GLKBaseEffect alloc] init];
    ball1.ballEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, 0, self.view.frame.size.height, -1024, 1024);
    NSMutableArray *highScoreArray=[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores];
    NSDictionary *highScoreEntry = highScoreArray[0];
    NSNumber *highScoreValue = highScoreEntry[@"RPBScore"];
    if ([highScoreValue intValue]!=0) {
        self.highScoreField.text=[NSString stringWithFormat:@"High Score: %d",[highScoreArray[0][@"RPBScore"] intValue],nil];
    }
    
    //[mainView addSubview:ball1.ballView];
    //[mainView sendSubviewToBack:ball1.ballView];
    [ballViewArray addObject:ball1];
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
    [bounceArray addObject:@1.0f];
    [xBounceArray addObject:@0.0f];
    //powerUpImage4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    //powerUpImage4.backgroundColor=[UIColor redColor];
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
	self.speedTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(speedUp:) userInfo:nil repeats:YES];
    /*self.cheatCheckTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(cheatCheck:) userInfo:nil repeats:YES];
    [cheatCheckTimer retain];*/
	self.powerUpTimer = [NSTimer scheduledTimerWithTimeInterval:20.00 target:self selector:@selector(powerUpCreate:) userInfo:nil repeats:YES];
    double time = [self randomTimerTime];
    self.wallScoreBoostTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(wallScoreBoostEnableOrDisable:) userInfo:nil repeats:YES];
    /*self.loseWallChangeTimer = [NSTimer scheduledTimerWithTimeInterval:60.00 target:self selector:@selector(loseTimeChangeWall:) userInfo:nil repeats:YES];
    [loseWallChangeTimer fire];*/
    RPBBall *ballPointer = ballViewArray[0];
    ballViewArray[0] = ballPointer;
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
	[speedTimer invalidate];
	[powerUpTimer invalidate];
	[powerUpStartedTimer invalidate];
    /*[cheatCheckTimer invalidate];
    [cheatCheckTimer release];*/
    [wallScoreBoostTimer invalidate];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBAccelerometerEnabled"] == YES) {
        //accelerometerDelegate.delegate = nil;
        [accelerometerDelegate stopAccelerometerUpdates];
        accelerometerDelegate = nil;
    }
}

@end
