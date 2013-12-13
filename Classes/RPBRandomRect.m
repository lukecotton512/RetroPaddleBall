//
//  RPBRandomRect.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 6/1/12.
//  Copyright (c) 2012 Westfield High School. All rights reserved.
//

#import "RPBRandomRect.h"

@implementation RPBRandomRect
@synthesize rectView, leftRect, rightRect, topRect, bottomRect, powerUpAbsorbed, leftRectBall, rightRectBall, topRectBall, bottomRectBall, topRectIntersection, bottomRectIntersection, leftRectIntersection, rightRectIntersection;
-(id)init
{
    self=[super init];
    if (self) {
        rectView=[[UIView alloc] init];
        self.rectOfView = CGRectMake(0, 0, 120, 40);
    }
    return self;
}
-(void)setRectOfView:(CGRect)theRectOfView
{
    rectOfView=theRectOfView;
    rectView.frame=theRectOfView;
    leftRect = CGRectMake(rectOfView.origin.x, rectOfView.origin.y, 1, rectOfView.size.height);
    rightRect = CGRectMake((rectOfView.origin.x+rectOfView.size.width)-1, rectOfView.origin.y, 1, rectOfView.size.height);
    topRect = CGRectMake(rectOfView.origin.x, rectOfView.origin.y+1, rectOfView.size.width, 1);
    bottomRect = CGRectMake(rectOfView.origin.x, (rectOfView.origin.y+rectOfView.size.height)-1, rectOfView.size.width, 1);
    leftRectBall = CGRectMake(rectOfView.origin.x-21, rectOfView.origin.y, 21, rectOfView.size.height);
    rightRectBall = CGRectMake((rectOfView.origin.x+rectOfView.size.width)-1, rectOfView.origin.y, 21, rectOfView.size.height);
    topRectBall = CGRectMake(rectOfView.origin.x, rectOfView.origin.y-21, rectOfView.size.width, 21);
    bottomRectBall = CGRectMake(rectOfView.origin.x, (rectOfView.origin.y+rectOfView.size.height)+21, rectOfView.size.width, 21);
}
-(CGRect)rectOfView
{
    return rectOfView;
}
-(void)dealloc
{
    [rectView release];
    [super dealloc];
}
@end
