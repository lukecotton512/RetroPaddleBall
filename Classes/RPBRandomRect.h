//
//  RPBRandomRect.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 6/1/12.
//  Copyright (c) 2012 Striped Cat Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class RPBRectangle;
@interface RPBRandomRect : NSObject {
    RPBRectangle *rectOfView;
    CGRect rightRect;
    CGRect leftRect;
    CGRect topRect;
    CGRect bottomRect;
    CGRect rightRectIntersection;
    CGRect leftRectIntersection;
    CGRect topRectIntersection;
    CGRect bottomRectIntersection;
    CGRect rightRectBall;
    CGRect leftRectBall;
    CGRect topRectBall;
    CGRect bottomRectBall;
    int powerUpAbsorbed;
}
@property (nonatomic, assign) CGRect rectOfView;
@property (nonatomic, readonly, assign) CGRect rightRect;
@property (nonatomic, readonly, assign) CGRect leftRect;
@property (nonatomic, readonly, assign) CGRect topRect;
@property (nonatomic, readonly, assign) CGRect bottomRect;
@property (nonatomic, readonly, assign) CGRect rightRectIntersection;
@property (nonatomic, readonly, assign) CGRect leftRectIntersection;
@property (nonatomic, readonly, assign) CGRect topRectIntersection;
@property (nonatomic, readonly, assign) CGRect bottomRectIntersection;
@property (nonatomic, readonly, assign) CGRect rightRectBall;
@property (nonatomic, readonly, assign) CGRect leftRectBall;
@property (nonatomic, readonly, assign) CGRect topRectBall;
@property (nonatomic, readonly, assign) CGRect bottomRectBall;
@property (nonatomic, assign) int powerUpAbsorbed;
-(UIColor *)color;
-(void)setColor:(UIColor *)aColor;
-(GLKMatrix4)projectMatrix;
-(void)setProjectMatrix:(GLKMatrix4)projectMatrix;
-(void)render;
@end
