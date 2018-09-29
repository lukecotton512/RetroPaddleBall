//
//  RPBPaddle.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 11/17/16.
//
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class RPBRectangle;
@interface RPBPaddle : NSObject {
    RPBRectangle * _rectangle;
}

// Member functions.
-(instancetype)init;
-(CGRect)rect;
-(void)setRect:(CGRect)aRect;
-(UIColor *)color;
-(void)setColor:(UIColor *)aColor;
-(CGPoint)paddleCenter;
-(void)setPaddleCenter:(CGPoint)newCenter;
-(GLKMatrix4)projectMatrix;
-(void)setProjectMatrix:(GLKMatrix4)projectMatrix;

-(void)render;
@end
