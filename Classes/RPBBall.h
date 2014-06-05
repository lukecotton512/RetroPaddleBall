//
//  RPBBall.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
@interface RPBBall : NSObject
{
    CGRect ballRect;
    float xBounce;
    float bounce;
    float oldxBounce;
    float oldbounce;
    float speedMultiplier;
    float oldSpeedMultiplier;
    int ballHitCounter;
    int ballHitCounterTop;
    int ballHitCounterLeft;
    int ballHitCounterRight;
    int ballHitCounterScore;
    GLKBaseEffect *ballEffect;
}
@property (nonatomic, assign) CGRect ballRect;
@property (nonatomic, assign) float xBounce;
@property (nonatomic, assign) float bounce;
@property (nonatomic, assign) float oldxBounce;
@property (nonatomic, assign) float oldbounce;
@property (nonatomic, assign) int ballHitCounter;
@property (nonatomic, assign) int ballHitCounterTop;
@property (nonatomic, assign) int ballHitCounterLeft;
@property (nonatomic, assign) int ballHitCounterRight;
@property (nonatomic, assign) int ballHitCounterScore;
@property (nonatomic, assign) float speedMultiplier;
@property (nonatomic, assign) float oldSpeedMultiplier;
@property (nonatomic, strong) GLKBaseEffect *ballEffect;
-(void)speedUpBall;
-(void)slowDownBall;
-(void)undoSpeedUp;
-(void)undoSlowDown;
@end
