//
//  CoreGraphicsDrawingView.m
//  CoreGraphicsDrawing
//
//  Created by Luke Cotton on 2/5/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import "CoreGraphicsDrawingView.h"
#import "CoreGraphicsDrawingAppDelegate.h"
#define WALLSIZE 4
#define WALLSIZEIPAD (WALLSIZE*2)
#define WALLBORDER 15
#define WALLBORDERIPAD (WALLBORDER*2)
@implementation CoreGraphicsDrawingView
@synthesize initalPoint, secondPoint, thirdPoint, fourthPoint, ballRect, ballRect2, inFrontBallRect2, topOfScreen, rightOfScreen, leftOfScreen, bottomOfScreen, paddleLocked, oldBallRect, oldPaddleRect, powerUpRect, wallEnabled,leftOfScreenBall,bottomOfScreenBall,topOfScreenBall,rightOfScreenBall, wallToLose;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
    }
    return self;
}
-(void)awakeFromNib
{
	initalPoint.x=140.0f;
	initalPoint.y=210.0f;
	secondPoint.x=140.0f;
	secondPoint.y=250.0f;
	thirdPoint.x=180.0f;
	thirdPoint.y=250.0f;
	fourthPoint.x=180.0f;
	fourthPoint.y=210.0f;
	//RPBLOG(@"(%f,%f), (%f,%f), (%f,%f), (%f,%f)", initalPoint.x, initalPoint.y, secondPoint.x, secondPoint.y, thirdPoint.x, thirdPoint.y, fourthPoint.x, fourthPoint.y);
	ballRect.origin.x = 155;
	ballRect.origin.y = 10;
	ballRect.size.width = 10;
	ballRect.size.height = 10;
	ballRect2.origin=initalPoint;
	ballRect2.size.width=40;
	ballRect2.size.height=40;
	oldBallRect=ballRect;
	oldPaddleRect=ballRect2;
    wallEnabled = 0;
    wallToLose=4;
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        wallSize = WALLSIZEIPAD;
        wallBorderSize = WALLBORDERIPAD;
    } else {
        wallSize = WALLSIZE;
        wallBorderSize = WALLBORDER;
    }
	topOfScreen = CGRectMake(0, 0, screenSize.size.width, wallSize);
	leftOfScreen = CGRectMake(0, 0, wallSize, screenSize.size.height);
	rightOfScreen = CGRectMake((screenSize.size.width-wallSize), 0, wallSize, screenSize.size.height);
	bottomOfScreen = CGRectMake(0, (screenSize.size.height-wallSize), screenSize.size.width, wallSize);
    topOfScreenBall = CGRectMake((wallBorderSize+wallSize), wallSize, screenSize.size.width-((wallBorderSize+wallSize)*2), wallBorderSize);
    leftOfScreenBall = CGRectMake(wallSize, (wallBorderSize+wallSize), wallBorderSize, (screenSize.size.height-((wallBorderSize+wallSize)*2)));
    rightOfScreenBall = CGRectMake((screenSize.size.width-(wallBorderSize+wallSize)), (wallBorderSize+wallSize), wallBorderSize, (screenSize.size.height-((wallBorderSize+wallSize)*2)));
    bottomOfScreenBall = CGRectMake((wallBorderSize+wallSize), (screenSize.size.height-(wallBorderSize+wallSize)), (screenSize.size.width-((wallBorderSize+wallSize)*2)), wallBorderSize);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (paddleLocked == 0){
        RPBLOG(@"Method Called!");
		UITouch *touch = [touches anyObject];
		CGPoint location = [touch locationInView:self];
		CGRect backRect = self.ballRect2;
		CGPoint tempPoint, tempPoint2;
		CGRect tempRect;
		float bounce,xbounce;
		tempRect.origin.x=location.x-20;
		tempRect.origin.y=location.y-20;
		tempRect.size=ballRect2.size;
		CGRect tempRect2 =self.ballRect;
		tempPoint.x = location.x + 20;
		tempPoint2.x = location.x - 20;
		tempPoint2.y = location.y + 20;
		if (CGRectIntersectsRect(ballRect2, tempRect)|| CGRectIntersectsRect(tempRect, topOfScreen) || CGRectIntersectsRect(tempRect, bottomOfScreen) || CGRectIntersectsRect(tempRect, leftOfScreen) || CGRectIntersectsRect(tempRect, rightOfScreen)) {
			return;
		}
		if (CGRectIntersectsRect(tempRect, ballRect)) {
			RPBLOG(@"(%f,%f), (%f,%f), (%f,%f), (%f,%f)", initalPoint.x, initalPoint.y, secondPoint.x, secondPoint.y, thirdPoint.x, thirdPoint.y, fourthPoint.x, fourthPoint.y);
			RPBLOG(@"true");
			CGRect intersectRect = CGRectIntersection(self.ballRect2,tempRect2);
			if (!CGRectIsNull(intersectRect)) {
				RPBLOG(@"(%f,%f) width:%f height:%f", intersectRect.origin.x, intersectRect.origin.y, intersectRect.size.width, intersectRect.size.height);
				(tempRect2.origin.x+tempRect2.size.height)+
				float whereBallHit = ((tempRect.origin.x+(tempRect.size.width/2.0f))-(tempRect2.origin.x+(tempRect2.size.width/2.0f)));
				float temp1=(whereBallHit/(tempRect2.size.width/2.0f));
				float bounceAngle=(temp1*0.0f);
				RPBLOG(@"whereBallHit: %f temp1:%f bounceAngle: %f", whereBallHit, temp1, bounceAngle);
				xbounce = sin(bounceAngle);
				bounce= cos(bounceAngle);
				xbounce=xbounce/0.5f;
				RPBLOG(@"%f",xbounce);
			}
			return;
		}
		initalPoint.x = location.x - 20;
		initalPoint.y = location.y - 20;
		secondPoint.x = location.x - 20;
		secondPoint.y = location.y + 20;
		thirdPoint.x = location.x + 20;
		thirdPoint.y = location.y + 20;
		fourthPoint.x = location.x + 20;
		fourthPoint.y = location.y - 20;
		ballRect2.origin.x=initalPoint.x;
		ballRect2.origin.y=initalPoint.y;
		ballRect2.size.width=40;
		ballRect2.size.height=40;
		RPBLOG(@"(%f,%f), (%f,%f), (%f,%f), (%f,%f)", initalPoint.x, initalPoint.y, secondPoint.x, secondPoint.y, thirdPoint.x, thirdPoint.y, fourthPoint.x, fourthPoint.y);
		tempRect2.origin.y=tempRect.origin.y+bounce;
		tempRect2.origin.x=tempRect.origin.x+xbounce;
		[self setNeedsDisplayInRect:backRect];
		[self setNeedsDisplayInRect:ballRect2];
	}
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (paddleLocked == 0){
        RPBLOG(@"Method Called!");
		CGRect backRect = self.ballRect2;
		UITouch *touch = [touches anyObject];
		CGPoint location = [touch locationInView:self];
		CGPoint tempPoint, tempPoint2;
		CGRect tempRect;
		//float bounce,xbounce;
		tempRect.origin.x=location.x-20;
		tempRect.origin.y=location.y-20;
		tempRect.size=ballRect2.size;
		CGRect tempRect2 =self.ballRect;
		tempPoint.x = location.x + 20;
		tempPoint2.x = location.x - 20;
		tempPoint2.y = location.y + 20;
		if (CGRectIntersectsRect(tempRect, ballRect)) {
			RPBLOG(@"(%f,%f), (%f,%f), (%f,%f), (%f,%f)", initalPoint.x, initalPoint.y, secondPoint.x, secondPoint.y, thirdPoint.x, thirdPoint.y, fourthPoint.x, fourthPoint.y);
			RPBLOG(@"true");
			CGRect intersectRect = CGRectIntersection(self.ballRect2,tempRect2);
			if (!CGRectIsNull(intersectRect)) {
				RPBLOG(@"(%f,%f) width:%f height:%f", intersectRect.origin.x, intersectRect.origin.y, intersectRect.size.width, intersectRect.size.height);
				(tempRect2.origin.x+tempRect2.size.height)+
				float whereBallHit = ((tempRect.origin.x+(tempRect.size.width/2))-(tempRect2.origin.x+(tempRect2.size.width/2)));
				float temp1=(whereBallHit/(tempRect2.size.width/2));
				float bounceAngle=(temp1*20.0f);
				RPBLOG(@"whereBallHit: %f temp1:%f bounceAngle: %f", whereBallHit, temp1, bounceAngle);
				xbounce = sin(bounceAngle);
				bounce= cos(bounceAngle);
				xbounce=xbounce/0.5f;
				RPBLOG(@"%f",xbounce);
			}
			return;
		}
		if (CGRectIntersectsRect(tempRect, ballRect) || CGRectIntersectsRect(self.ballRect2, ballRect) || CGRectIntersectsRect(tempRect, topOfScreen) || CGRectIntersectsRect(tempRect, bottomOfScreen) || CGRectIntersectsRect(tempRect, leftOfScreen) || CGRectIntersectsRect(tempRect, rightOfScreen)) {
			return;
		}
		initalPoint.x = location.x - 20;
		initalPoint.y = location.y - 20;
		secondPoint.x = location.x - 20;
		secondPoint.y = location.y + 20;
		thirdPoint.x = location.x + 20;
		thirdPoint.y = location.y + 20;
		fourthPoint.x = location.x + 20;
		fourthPoint.y = location.y - 20;
		ballRect2.origin.x=initalPoint.x;
		ballRect2.origin.y=initalPoint.y;
		ballRect2.size.width=40;
		ballRect2.size.height=40;
		RPBLOG(@"(%f,%f), (%f,%f), (%f,%f), (%f,%f)", initalPoint.x, initalPoint.y, secondPoint.x, secondPoint.y, thirdPoint.x, thirdPoint.y, fourthPoint.x, fourthPoint.y);
		tempRect2.origin.y=tempRect.origin.y+bounce;
		tempRect2.origin.x=tempRect.origin.x+xbounce;
		[self setNeedsDisplayInRect:backRect];
		[self setNeedsDisplayInRect:ballRect2];
	}
}*/
/*-(CGMutablePathRef)pathFromRect:(CGRect)chosenRect
{
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, chosenRect.origin.x, chosenRect.origin.y);
	CGPathAddLineToPoint(path, NULL, (chosenRect.origin.x), (chosenRect.origin.y+chosenRect.size.height));
	CGPathAddLineToPoint(path, NULL, (chosenRect.origin.x+chosenRect.size.width), (chosenRect.origin.y+chosenRect.size.height));
	CGPathAddLineToPoint(path, NULL, (chosenRect.origin.x+chosenRect.size.width), chosenRect.origin.y);
	CGPathCloseSubpath(path);
	return path;
}*/
-(void)lockPaddle
{
	paddleLocked=1;
}
-(void)unlockPaddle
{
	paddleLocked=0;
}
- (void)dealloc {
	CGPathRelease(ballPath);
	CGPathRelease(ballPath2);
}


@end
