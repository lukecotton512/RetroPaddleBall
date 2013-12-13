//
//  HowToPlayViewController.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 7/3/11.
//  Copyright 2011 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowToPlayViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIView *view1;
    IBOutlet UIView *view2;
    IBOutlet UIView *view3;
    IBOutlet UIView *view4;
    IBOutlet UIView *view5;
    IBOutlet UIView *view6;
    IBOutlet UIView *view7;
    IBOutlet UIView *animationControl;
    IBOutlet UIView *ballView2;
    IBOutlet UIView *ballView3;
    IBOutlet UIView *paddleView2;
    IBOutlet UIView *paddleView3;
    IBOutlet UIView *intersectView2;
    IBOutlet UIView *intersectView3;
    IBOutlet UIButton *previousButton;
    IBOutlet UIButton *nextButton;
    BOOL viewIntersected;
    BOOL view2Intersected;
    UIView *currentView;
    NSTimer *view2Timer;
    NSTimer *view3Timer;
    int viewCounter;
}
-(IBAction)showMainMenu:(id)sender;
-(IBAction)nextView:(id)sender;
-(IBAction)previousView:(id)sender;
-(void)animateView2:(NSTimer *)theTimer;
-(void)animateView3:(NSTimer *)theTimer;
@property (nonatomic, retain) IBOutlet UIView *view1;
@property (nonatomic, retain) IBOutlet UIView *view2;
@property (nonatomic, retain) IBOutlet UIView *view3;
@property (nonatomic, retain) IBOutlet UIView *view4;
@property (nonatomic, retain) IBOutlet UIView *view5;
@property (nonatomic, retain) IBOutlet UIView *view6;
@property (nonatomic, retain) IBOutlet UIView *view7;
@property (nonatomic, retain) IBOutlet UIView *animationControl;
@property (nonatomic, retain) IBOutlet UIView *ballView2;
@property (nonatomic, retain) IBOutlet UIView *ballView3;
@property (nonatomic, retain) IBOutlet UIView *paddleView2;
@property (nonatomic, retain) IBOutlet UIView *paddleView3;
@property (nonatomic, retain) IBOutlet UIView *intersectView2;
@property (nonatomic, retain) IBOutlet UIView *intersectView3;
@property (nonatomic, retain) IBOutlet UIButton *previousButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, assign) UIView *currentView;
@property (nonatomic, retain) NSTimer *view2Timer;
@property (nonatomic, retain) NSTimer *view3Timer;
@property (nonatomic, assign) int viewCounter;
@property (nonatomic, assign) BOOL viewIntersected;
@property (nonatomic, assign) BOOL viewIntersected2;
@end
