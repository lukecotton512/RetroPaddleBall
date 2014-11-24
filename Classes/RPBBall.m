//
//  RPBBall.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 2/1/12.
//  Copyright (c) 2012 Striped Cat Development. All rights reserved.
//

#import "RPBBall.h"

@implementation RPBBall
@synthesize ballRect, ballHitCounter, ballHitCounterLeft, ballHitCounterTop, ballHitCounterRight, ballHitCounterScore, oldbounce, oldxBounce, oldSpeedMultiplier, xBounce, bounce, ballEffect, multiplyFactor;
-(id)init
{
    if (self=[super init]) {
        ballRect = CGRectMake(0, 0, 10, 10);
        speedMultiplier=3.0f;
        oldSpeedMultiplier=2.0f;
        ballHitCounter = 0;
        ballHitCounterLeft = 0;
        ballHitCounterRight = 0;
        ballHitCounterTop = 0;
        ballHitCounterScore = 0;
        xBounce = 0.0f;
        bounce = 2.0f;
        oldbounce=1.0f;
        oldxBounce=0.0f;
        multiplyFactor = 1.0f;
    }
    return self;
}
-(float)speedMultiplier{
    return speedMultiplier;
}
-(void)setSpeedMultiplier:(float)theSpeedMultiplier
{
    speedMultiplier=theSpeedMultiplier;
}

-(void)speedUpBall
{
    oldSpeedMultiplier=speedMultiplier;
    xBounce = xBounce/oldSpeedMultiplier;
    bounce = bounce/oldSpeedMultiplier;
    float accelerateFactor = 1.5f+(((speedMultiplier-3.0f)/0.75f)*.25);
    accelerateFactor *= multiplyFactor;
    speedMultiplier=speedMultiplier+accelerateFactor;
    xBounce *= speedMultiplier;
    bounce *= speedMultiplier;
}
-(void)slowDownBall
{
    oldSpeedMultiplier=speedMultiplier;
    xBounce = xBounce/oldSpeedMultiplier;
    bounce = bounce/oldSpeedMultiplier;
    float accelerateFactor = 1.5f+(((speedMultiplier-3.0f)/0.75f)*.25);
    accelerateFactor *= multiplyFactor;
    speedMultiplier=speedMultiplier-accelerateFactor;
    xBounce *= speedMultiplier;
    bounce *= speedMultiplier;
}
-(void)undoSpeedUp
{
    xBounce = xBounce/speedMultiplier;
    bounce = bounce/speedMultiplier;
    speedMultiplier=oldSpeedMultiplier;
    xBounce *= speedMultiplier;
    bounce *= speedMultiplier;
}
-(void)undoSlowDown
{
    xBounce = xBounce/speedMultiplier;
    bounce = bounce/speedMultiplier;
    speedMultiplier=oldSpeedMultiplier;
    xBounce *= speedMultiplier;
    bounce *= speedMultiplier;
}
@end
