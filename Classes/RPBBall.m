//
//  RPBBall.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RPBBall.h"

@implementation RPBBall
@synthesize ballView, ballRect, ballHitCounter, ballHitCounterLeft, ballHitCounterTop, ballHitCounterRight, ballHitCounterScore, oldbounce, oldxBounce, oldSpeedMultiplier, xBounce, bounce;
-(id)init
{
    //self = [super init];
    if (self=[super init]) {
        ballRect = CGRectMake(0, 0, 10, 10);
        ballView = [[UIView alloc] initWithFrame:ballRect];
        speedMultiplier=2.0f;
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
    }
    return self;
}
/*-(float)xBounce
{
    return xBounce;
}
-(float)bounce
{
    return bounce;
}*/
-(float)speedMultiplier{
    return speedMultiplier;
}
-(void)setSpeedMultiplier:(float)theSpeedMultiplier
{
    //oldSpeedMultiplier=speedMultiplier;
    speedMultiplier=theSpeedMultiplier;
    //self.xBounce=oldxBounce;
    //self.bounce=oldbounce;
}
/*-(void)setXBounce:(float)thexBounce{
    if (thexBounce==xBounce) {
        return;
    } else if ((thexBounce-0.01f)==-xBounce) {
        xBounce=(-xBounce)+0.01f;
        return;
    } else if (thexBounce==-xBounce) {
        xBounce=-xBounce;
        return;
    } else {
        xBounce=thexBounce*speedMultiplier;
    }
    if (speedMultiplier!=2.0f) {*/
    /*oldxBounce=thexBounce;
    xBounce=thexBounce*speedMultiplier;
    //}
}
-(void)setBounce:(float)theBounce {
    if (theBounce==bounce){
        return;
    } else if ((theBounce-0.01f)==-bounce) {
        bounce=(-bounce)+0.01f;
        return;
    } else if (theBounce==-bounce) {
        bounce=-bounce;
        return;
    } else {
        bounce=theBounce*speedMultiplier;
    }
    if (speedMultiplier!=2.0f) {*/
    /*oldbounce=theBounce;
    bounce=theBounce*speedMultiplier;
    //}
}*/
-(void)speedUpBall
{
    oldSpeedMultiplier=speedMultiplier;
    xBounce = xBounce/oldSpeedMultiplier;
    bounce = bounce/oldSpeedMultiplier;
    speedMultiplier=speedMultiplier+1.5f;
    xBounce *= speedMultiplier;
    bounce *= speedMultiplier;
}
-(void)slowDownBall
{
    //oldbounce=bounce/speedMultiplier;
    //oldxBounce=xBounce/speedMultiplier;
    oldSpeedMultiplier=speedMultiplier;
    xBounce = xBounce/oldSpeedMultiplier;
    bounce = bounce/oldSpeedMultiplier;
    speedMultiplier=speedMultiplier-1.5f;
    xBounce *= speedMultiplier;
    bounce *= speedMultiplier;
    //self.xBounce=oldxBounce;
    //self.bounce=oldbounce;
}
-(void)undoSpeedUp
{
    xBounce = xBounce/speedMultiplier;
    bounce = bounce/speedMultiplier;
    speedMultiplier=oldSpeedMultiplier;
    xBounce *= speedMultiplier;
    bounce *= speedMultiplier;
    //self.xBounce=oldxBounce;
    //self.bounce=oldbounce;
}
-(void)undoSlowDown
{
    xBounce = xBounce/speedMultiplier;
    bounce = bounce/speedMultiplier;
    speedMultiplier=oldSpeedMultiplier;
    xBounce *= speedMultiplier;
    bounce *= speedMultiplier;
    //self.xBounce=oldxBounce;
    //self.bounce=oldbounce;
}
-(void)dealloc
{
    [ballView release];
    [super dealloc];
}
@end
