//
//  RPBPaddle.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 11/17/16.
//
//

#import "RPBPaddle.h"
#import "RPBRectangle.h"

@implementation RPBPaddle

// Init method.
-(instancetype)init {
    self = [super init];
    if (self) {
        _rectangle = [[RPBRectangle alloc] init];
    }
    return self;
}
// Renders our paddle.
-(void)render {
    [_rectangle render];
}

// Gets and sets various parts of our rectangle.
// Gets and sets our rectangle size and position.
-(CGRect)rect {
    return _rectangle.rect;
}
-(void)setRect:(CGRect)aRect {
    _rectangle.rect = aRect;
}

// Get and set our rectangle color.
-(UIColor *)color {
    return _rectangle.rectColor;
}
-(void)setColor:(UIColor *)aColor {
    _rectangle.rectColor = aColor;
}

// Gets and sets projection matrix.
-(GLKMatrix4)projectMatrix {
    return _rectangle.projectionMatrix;
}
-(void)setProjectMatrix:(GLKMatrix4)projectMatrix {
    _rectangle.projectionMatrix = projectMatrix;
}
@end
