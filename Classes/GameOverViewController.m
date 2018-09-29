//
//  GameOverViewController.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 2/16/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import "GameOverViewController.h"
#import "CoreGraphicsDrawingAppDelegate.h"
#import "RPBUsefulFunctions.h"

@implementation GameOverViewController
@synthesize scoreTextView, score, highScoreAlertField, highScores;
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
    // Get high scores and score.
    highScores = [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores];
    self.score = [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] score];
    
}
-(void)viewDidAppear:(BOOL)animated {
    // Check to see if we got on the high score board.
    int i;
    self.scoreTextView.text=[NSString stringWithFormat:@"Score: %i",self.score];
	for (i=0; i<highScores.count; i++) {
        // If we did, then present the user with a dialog box.
		if (score>[highScores[i][@"RPBScore"] intValue]) {
			UIAlertView *highScoreAlert= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NEWHIGHSCORE", nil) message:NSLocalizedString(@"ENTERYOURNAME", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) otherButtonTitles:NSLocalizedString(@"OK",nil),nil];
            highScoreAlert.alertViewStyle=UIAlertViewStylePlainTextInput;
            highScoreAlertField=[highScoreAlert textFieldAtIndex:0];
            highScoreAlertField.placeholder = @"Enter name";
			[highScoreAlert show];
			break;
		}
	}
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // If we hit cancel, then get out of here.
	if (buttonIndex == 0) {
		return;
	}
    
    if(highScoreAlertField.text.length == 0)
    {
        return;
    }
    // Put the score in the dictionary, and then delete the value at the very end.
	NSDictionary *dictionary = @{@"RPBScore": @(score), @"RPBName": highScoreAlertField.text};
	int i;
	for (i=0; i<highScores.count; i++) {
		if (score>[highScores[i][@"RPBScore"] intValue]) {
			[highScores insertObject:dictionary atIndex:i];
			if (highScores.count == 11) {
				[highScores removeLastObject];
			}
			break;
		}
	}
    // Save the high scores.
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] setHighScores:highScores];
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] saveHighScores];
}

// Reload score field with new high score.
-(void)updateScore
{
	scoreTextView.text=[NSString stringWithFormat:@"Score: %d", self.score];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
-(void)playAgain:(id)sender {
    // Get the correct storyboard for the device we are on.
    UIStoryboard *theStoryboard;
    if([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
        theStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPad" bundle:nil];
    } else {
        theStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPhone" bundle:nil];
    }
    // Load in the game view controller, and show it.
    CoreGraphicsDrawingViewController *newGame = [theStoryboard instantiateViewControllerWithIdentifier:@"GameController"];
    UINavigationController *naviControl = self.navigationController;
    NSMutableArray *viewControllerArray = [NSMutableArray arrayWithArray:naviControl.viewControllers];
    [viewControllerArray removeLastObject];
    [viewControllerArray addObject:newGame];
    naviControl.viewControllers = viewControllerArray;
}
@end
