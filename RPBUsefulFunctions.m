//
//  RPBUsefulFunctions.c
//  RetroPaddleBall
//
//  Created by Luke Cotton on 6/10/14.
//
//

#import "RPBUsefulFunctions.h"

// Function to log only if we are a debug build.
void RPBLog(NSString *format, ...) {
#ifdef DEBUG
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
#else
    return;
#endif
}

// Function to move a point back.
void moveRectBack(CGRect * rect, CGRect intersect) {
    CGFloat halfWidth = rect->size.width/2;
    CGFloat halfHeight = rect->size.height/2;
    CGFloat relativeIntersectX = intersect.origin.x - halfWidth;
    CGFloat relativeIntersectY = intersect.origin.y - halfHeight;
    rect->origin.x -= relativeIntersectX;
    rect->origin.y += relativeIntersectY;
}
