//
//  GameOverViewController.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 2/16/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import "GameOverViewController.h"
#import "CoreGraphicsDrawingAppDelegate.h"

@implementation GameOverViewController
@synthesize scoreTextView, score, highScoreAlertField, highScores, bannerView;
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
/**/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    highScores = [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores];
    self.score = [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] score];
    if([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] upgradePurchased]) {
        [bannerView removeFromSuperview];
    } else {
        bannerView.delegate = self;
        bannerView.hidden = YES;
    }
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    banner.hidden = NO;
}
-(void)viewDidAppear:(BOOL)animated {
    int i;
    self.scoreTextView.text=[NSString stringWithFormat:@"Score: %i",self.score];
	for (i=0; i<[highScores count]; i++) {
		if (score>[highScores[i][@"RPBScore"] intValue]) {
			UIAlertView *highScoreAlert= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NEWHIGHSCORE", nil) message:NSLocalizedString(@"ENTERYOURNAME", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) otherButtonTitles:NSLocalizedString(@"OK",nil),nil];
			//[highScoreAlertField setBackgroundColor:[UIColor whiteColor]];
            highScoreAlert.alertViewStyle=UIAlertViewStylePlainTextInput;
            highScoreAlertField=[highScoreAlert textFieldAtIndex:0];
            highScoreAlertField.placeholder = @"Enter name";
			//[highScoreAlert addSubview:highScoreAlertField];
			[highScoreAlert show];
			break;
		}
	}
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		return;
	}if(highScoreAlertField.text.length == 0)
    {
        return;
    }
	NSDictionary *dictionary = @{@"RPBScore": @(score), @"RPBName": [highScoreAlertField text]};
	int i;
	for (i=0; i<[highScores count]; i++) {
		if (score>[highScores[i][@"RPBScore"] intValue]) {
			[highScores insertObject:dictionary atIndex:i];
			if ([highScores count] == 11) {
				[highScores removeLastObject];
			}
			break;
		}
	}
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] setHighScores:highScores];
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] saveHighScores];
	//[highScoreAlertField release];
}
/*- (void)willPresentAlertView:(UIAlertView *)highScoreAlert {
	CGRect alertFrame = highScoreAlert.frame;
	alertFrame.size.height = alertFrame.size.height + 75;
	highScoreAlert.frame = alertFrame;}*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void)updateScore
{
	scoreTextView.text=[NSString stringWithFormat:@"Score: %d", self.score];
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
-(void)playAgain:(id)sender {
    UIStoryboard *theStoryboard;
    if([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        theStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPad" bundle:nil];
    } else {
        theStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPhone" bundle:nil];
    }
    CoreGraphicsDrawingViewController *newGame = [theStoryboard instantiateViewControllerWithIdentifier:@"GameController"];
    UINavigationController *naviControl = [self navigationController];
    NSMutableArray *viewControllerArray = [NSMutableArray arrayWithArray:[naviControl viewControllers]];
    [viewControllerArray removeLastObject];
    [viewControllerArray addObject:newGame];
    naviControl.viewControllers = viewControllerArray;
}
@end
