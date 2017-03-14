//
//  RPBRandomRect.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 6/1/12.
//  Copyright (c) 2012 Westfield High School. All rights reserved.
//

#import "RPBRandomRect.h"
#import "RPBRectangle.h"

@implementation RPBRandomRect
@synthesize leftRect, rightRect, topRect, bottomRect, powerUpAbsorbed, leftRectBall, rightRectBall, topRectBall, bottomRectBall, topRectIntersection, bottomRectIntersection, leftRectIntersection, rightRectIntersection;
-(instancetype)init
{
    self=[super init];
    if (self) {
        rectOfView = [[RPBRectangle alloc] init];
        rectOfView.rect = CGRectMake(0, 0, 120, 40);
    }
    return self;
}
// Setters and getters for the containing rect.
-(void)setRectOfView:(CGRect)theRectOfView
{
    rectOfView.rect=theRectOfView;
    leftRect = CGRectMake(theRectOfView.origin.x, theRectOfView.origin.y, 1, theRectOfView.size.height);
    rightRect = CGRectMake((theRectOfView.origin.x+theRectOfView.size.width)-1, theRectOfView.origin.y, 1, theRectOfView.size.height);
    topRect = CGRectMake(theRectOfView.origin.x, theRectOfView.origin.y+1, theRectOfView.size.width, 1);
    bottomRect = CGRectMake(theRectOfView.origin.x, (theRectOfView.origin.y+theRectOfView.size.height)-1, theRectOfView.size.width, 1);
    leftRectBall = CGRectMake(theRectOfView.origin.x-21, theRectOfView.origin.y, 21, theRectOfView.size.height);
    rightRectBall = CGRectMake((theRectOfView.origin.x+theRectOfView.size.width)-1, theRectOfView.origin.y, 21, theRectOfView.size.height);
    topRectBall = CGRectMake(theRectOfView.origin.x, theRectOfView.origin.y-21, theRectOfView.size.width, 21);
    bottomRectBall = CGRectMake(theRectOfView.origin.x, (theRectOfView.origin.y+theRectOfView.size.height)+21, theRectOfView.size.width, 21);
}
-(CGRect)rectOfView
{
    return rectOfView.rect;
}
// Render our rectangle.
-(void)render {
    [rectOfView render];
}

// Get and set our rectangle color.
-(UIColor *)color {
    return rectOfView.rectColor;
}
-(void)setColor:(UIColor *)aColor {
    rectOfView.rectColor = aColor;
}

// Gets and sets projection matrix.
-(GLKMatrix4)projectMatrix {
    return rectOfView.projectionMatrix;
}
-(void)setProjectMatrix:(GLKMatrix4)projectMatrix {
    rectOfView.projectionMatrix = projectMatrix;
}
@end
