//
//  TutorialViewController.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 12/19/13.
//
//

#import "TutorialViewController.h"
#import "CoreGraphicsDrawingAppDelegate.h"
#import "RPBUsefulFunctions.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.stageNumber = 0;
    // We are on the second view controller.
    if (self.view.tag==1) {
        CGRect ballFrame = self.ballView2.frame;
        CGRect paddleFrame = self.paddleView2.frame;
        if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
            paddleFrame.origin.y = 378;
            ballFrame.origin.y = 245;
        } else {
            paddleFrame.origin.y = 219;
            ballFrame.origin.y = 107;
        }
        self.paddleView2.frame = paddleFrame;
        self.ballView2.frame = ballFrame;
        self.viewTimer = [NSTimer scheduledTimerWithTimeInterval:0.025 target:self selector:@selector(animateView2:) userInfo:nil repeats:YES];
    } else if (self.view.tag==2) {
        // We are on the third view controller.
        self.viewTimer = [NSTimer scheduledTimerWithTimeInterval:0.025 target:self selector:@selector(animateView3:) userInfo:nil repeats:YES];
    }
    [self.viewTimer fire];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewTimer invalidate];
}
-(IBAction)goBack:(UIStoryboardSegue *)unwindSegue
{
    
}
// Animates the second view.
-(void)animateView2:(NSTimer *)theTimer
{
    // Move up until we intersect the ball.
    if (self.stageNumber == 0) {
        CGRect paddleFrame = self.paddleView2.frame;
        paddleFrame.origin.y -= 2;
        self.paddleView2.frame = paddleFrame;
        if (CGRectIntersectsRect(self.paddleView2.frame, self.ballView2.frame)) {
            self.stageNumber = 1;
        }
    } else if (self.stageNumber == 1) {
        // Move the ball up until we hit the top wall.
        CGRect ballFrame = self.ballView2.frame;
        ballFrame.origin.y -= 2;
        self.ballView2.frame = ballFrame;
        if (CGRectIntersectsRect(self.ballView2.frame, self.topOfScreen.frame)) {
            self.stageNumber = 2;
        }
    } else if (self.stageNumber == 2) {
        // Move the ball down until we hit the ball.
        CGRect ballFrame = self.ballView2.frame;
        ballFrame.origin.y += 2;
        self.ballView2.frame = ballFrame;
        if (CGRectIntersectsRect(self.ballView2.frame, self.paddleView2.frame)) {
            self.stageNumber = 1;
        }
    }
}
// Animation for third view.
-(void)animateView3:(NSTimer *)theTimer {
    // Move the ball up until we hit the wall.
    if (self.stageNumber == 0) {
        CGRect ballFrame = self.ballView2.frame;
        ballFrame.origin.y -= 2;
        self.ballView2.frame = ballFrame;
        if (CGRectIntersectsRect(self.ballView2.frame, self.topOfScreen.frame)) {
            self.stageNumber = 1;
        }
    } else if (self.stageNumber == 1) {
        // Move the ball down until we hit the paddle.
        CGRect ballFrame = self.ballView2.frame;
        ballFrame.origin.y += 2;
        self.ballView2.frame = ballFrame;
        if (CGRectIntersectsRect(self.ballView2.frame, self.paddleView2.frame)) {
            self.stageNumber = 0;
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
