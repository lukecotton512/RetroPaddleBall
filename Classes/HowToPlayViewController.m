//
//  HowToPlayViewController.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 7/3/11.
//  Copyright 2011 All rights reserved.
//

#import "HowToPlayViewController.h"
#import "CoreGraphicsDrawingAppDelegate.h"
@implementation HowToPlayViewController
@synthesize view1, view2, view3, view4, view5, view6, view7, viewCounter, currentView, animationControl, view2Timer, view3Timer, ballView2, ballView3, paddleView2, paddleView3, intersectView2, intersectView3, viewIntersected, viewIntersected2, previousButton, nextButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(IBAction)showMainMenu:(id)sender
{
    [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] showMainMenu];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //howToPlayView.delegate = self;
    //[howToPlayView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"RetroPaddleBallHowtoPlay" ofType:@"html"]]]];
    viewCounter = 1;
    viewIntersected = NO;
    view2Intersected = NO;
    previousButton.enabled=NO;
    [self.view addSubview:view1];
    currentView = view1;
    if([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        animationControl.frame=CGRectMake(60, 60, animationControl.frame.size.width, animationControl.frame.size.height);
    } else {
        animationControl.frame=CGRectMake(30, 30, animationControl.frame.size.width, animationControl.frame.size.height);
    }
    [self.view addSubview:animationControl];
    [self.view bringSubviewToFront:animationControl];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
/*- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    coverView.hidden=YES;
}*/
-(IBAction)nextView:(id)sender;
{
    viewIntersected = NO;
    view2Intersected = NO;
    viewCounter = viewCounter +1;
    if(viewCounter==2) {
        [currentView removeFromSuperview];
        [self.view addSubview:view2];
        currentView = view2;
        //view2Timer=nil;
        self.view2Timer = [NSTimer scheduledTimerWithTimeInterval:.025 target:self selector:@selector(animateView2:) userInfo:nil repeats:YES];
        [view2Timer fire];
        [view2Timer retain];
        [view2 bringSubviewToFront:ballView2];
        previousButton.enabled=YES;
    }
    if(viewCounter==3) {
        [view2Timer invalidate];
        [view2Timer release];
        //self.view2Timer = nil;
        [currentView removeFromSuperview];
        [self.view addSubview:view3];
        currentView = view3;
        //[view2Timer release];
        //view3Timer=nil;
        self.view3Timer = [NSTimer scheduledTimerWithTimeInterval:.025 target:self selector:@selector(animateView3:) userInfo:nil repeats:YES];
        [view3Timer fire];
        [view3Timer retain];
        [view3 bringSubviewToFront:ballView3];
    }
    if(viewCounter==4) {
        [view3Timer invalidate];
        [view3Timer release];
        //self.view3Timer=nil;
        [currentView removeFromSuperview];
        [self.view addSubview:view4];
        currentView = view4;
    }
    if(viewCounter==5) {
        [currentView removeFromSuperview];
        [self.view addSubview:view5];
        currentView = view5;
    }
    if(viewCounter==6) {
        [currentView removeFromSuperview];
        [self.view addSubview:view6];
        currentView = view6;
    }
    if(viewCounter==7) {
        [currentView removeFromSuperview];
        [self.view addSubview:view7];
        currentView = view7;
        nextButton.enabled = NO;
    }
    [self.view sendSubviewToBack:currentView];
}
-(IBAction)previousView:(id)sender;
{
    viewIntersected = NO;
    view2Intersected = NO;
    viewCounter = viewCounter -1;
    if(viewCounter==1) {
        [view2Timer invalidate];
        [view2Timer release];
        //self.view2Timer=nil;
        [currentView removeFromSuperview];
        [self.view addSubview:view1];
        currentView = view1;
        previousButton.enabled=NO;
    }
    if(viewCounter==2) {
        [view3Timer invalidate];
        [view3Timer release];
        //self.view3Timer=nil;
        [currentView removeFromSuperview];
        [self.view addSubview:view2];
        currentView = view2;
        self.view2Timer = [NSTimer scheduledTimerWithTimeInterval:.025 target:self selector:@selector(animateView2:) userInfo:nil repeats:YES];
        [view2Timer fire];
        [view2Timer retain];
    }
    if(viewCounter==3) {
        /*[view2Timer invalidate];
        [view2Timer release];*/
        //self.view2Timer=nil;
        [currentView removeFromSuperview];
        [self.view addSubview:view3];
        currentView = view3;
        self.view3Timer = [NSTimer scheduledTimerWithTimeInterval:.025 target:self selector:@selector(animateView3:) userInfo:nil repeats:YES];
        [view3Timer fire];
        [view3Timer retain];
    }
    if(viewCounter==4) {
        [currentView removeFromSuperview];
        [self.view addSubview:view4];
        currentView = view4;
    }
    if(viewCounter==5) {
        [currentView removeFromSuperview];
        [self.view addSubview:view5];
        currentView = view5;
        //nextButton.enabled=YES;
    }
    if(viewCounter==6) {
        [currentView removeFromSuperview];
        [self.view addSubview:view6];
        currentView = view6;
        nextButton.enabled=YES;
    }
    [self.view sendSubviewToBack:currentView];
}
-(void)animateView2:(NSTimer *)theTimer
{
    CGRect ballRect1 = ballView2.frame;
    if (CGRectIntersectsRect(ballRect1, intersectView2.frame)) {
        viewIntersected = NO;
    }
    if (CGRectIntersectsRect(ballRect1, paddleView2.frame)) {
        viewIntersected = YES;
        view2Intersected = YES;
    }
    if([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        if (self.paddleView2.center.y==516) {
            view2Intersected = NO;
        }
    } else {
        if (self.paddleView2.center.y==258) {
            view2Intersected = NO;
        }
    }
    if (viewIntersected==YES) {
        ballRect1.origin.y=ballRect1.origin.y-1;
    } else if (viewIntersected==NO) {
        ballRect1.origin.y=ballRect1.origin.y+1;
    }
    if (view2Intersected == YES) {
        CGRect ballRect2 = paddleView2.frame;
        ballRect2.origin.y=ballRect2.origin.y+1;
        paddleView2.frame=ballRect2;
    } else if (view2Intersected == NO) {
        CGRect ballRect2 = paddleView2.frame;
        ballRect2.origin.y=ballRect2.origin.y-1;
        paddleView2.frame=ballRect2;
    }
    ballView2.frame=ballRect1;
}
-(void)animateView3:(NSTimer *)theTimer
{
    CGRect ballRect1 = ballView3.frame;
    if (CGRectIntersectsRect(ballRect1, intersectView3.frame)) {
        viewIntersected = YES;
    }
    if (CGRectIntersectsRect(ballRect1, paddleView3.frame)) {
        viewIntersected = NO;
    }
    if (viewIntersected==YES) {
        ballRect1.origin.y=ballRect1.origin.y+1;
    } else if (viewIntersected==NO) {
        ballRect1.origin.y=ballRect1.origin.y-1;
    }
    ballView3.frame=ballRect1;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)dealloc
{
    //[howToPlayView release];
    //[coverView release];
    [intersectView2 release];
    [intersectView3 release];
    [previousButton release];
    [nextButton release];
    [view1 release];
    [view2 release];
    [view3 release];
    [view4 release];
    [view5 release];
    [view6 release];
    [animationControl release];
    [view2Timer invalidate];
    [view2Timer release];
    [view3Timer invalidate];
    [view3Timer release];
    [super dealloc];
}
@end
