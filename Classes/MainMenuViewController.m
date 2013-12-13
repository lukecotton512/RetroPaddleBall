//
//  MainMenuViewController.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 2/11/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import "MainMenuViewController.h"
#import "CoreGraphicsDrawingAppDelegate.h"

@implementation MainMenuViewController
@synthesize window, bannerAd;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] upgradePurchased]) {
        [self hideAds];
    }
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void)hideAds {
    [bannerAd removeFromSuperview];
}
-(IBAction)playGame:(id)sender
{
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] playGame:sender];
}
-(IBAction)showSettings:(id)sender
{
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] showSettings];
}
-(IBAction)showHighScores:(id)sender
{
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] showHighScores];
}
-(IBAction)showHowToPlay:(id)sender
{
    [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] showHowToPlay];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    //[window release];
    [super dealloc];
}


@end
