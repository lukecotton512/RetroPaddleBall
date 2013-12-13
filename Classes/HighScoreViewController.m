//
//  HighScoreViewController.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 4/23/11.
//  Copyright 2011 All rights reserved.
//

#import "HighScoreViewController.h"
#import "CoreGraphicsDrawingAppDelegate.h"

@implementation HighScoreViewController
@synthesize name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, score1, score2, score3, score4, score5, score6, score7, score8, score9, score10, highScores;
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
	
}
-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self loadHighScores];
}
-(void)loadHighScores
{
	highScores = [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores];
	name1.text = [[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:0] objectForKey:@"RPBName"];
	score1.text = [NSString stringWithFormat:@"%i", [[[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:0] objectForKey:@"RPBScore"] intValue]];
	name2.text = [[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:1] objectForKey:@"RPBName"];
	score2.text = [NSString stringWithFormat:@"%i", [[[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:1] objectForKey:@"RPBScore"] intValue]];
	name3.text = [[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:2] objectForKey:@"RPBName"];
	score3.text = [NSString stringWithFormat:@"%i", [[[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:2] objectForKey:@"RPBScore"] intValue]];
	name4.text = [[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:3] objectForKey:@"RPBName"];
	score4.text = [NSString stringWithFormat:@"%i", [[[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:3] objectForKey:@"RPBScore"] intValue]];
	name5.text = [[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:4] objectForKey:@"RPBName"];
	score5.text = [NSString stringWithFormat:@"%i", [[[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:4] objectForKey:@"RPBScore"] intValue]];
	name6.text = [[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:5] objectForKey:@"RPBName"];
	score6.text = [NSString stringWithFormat:@"%i", [[[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:5] objectForKey:@"RPBScore"] intValue]];
	name7.text = [[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:6] objectForKey:@"RPBName"];
	score7.text = [NSString stringWithFormat:@"%i", [[[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:6] objectForKey:@"RPBScore"] intValue]];
	name8.text = [[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:7] objectForKey:@"RPBName"];
	score8.text = [NSString stringWithFormat:@"%i", [[[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:7] objectForKey:@"RPBScore"] intValue]];
	name9.text = [[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:8] objectForKey:@"RPBName"];
	score9.text = [NSString stringWithFormat:@"%i", [[[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:8] objectForKey:@"RPBScore"] intValue]];
	name10.text = [[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:9] objectForKey:@"RPBName"];
	score10.text = [NSString stringWithFormat:@"%i", [[[[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores] objectAtIndex:9] objectForKey:@"RPBScore"] intValue]];
}
-(IBAction)showMainMenu:(id)sender
{
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] showMainMenu];
}
-(IBAction)resetHighScores:(id)sender
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"HIGHSCORESMESSAGETITLE", nil) message:NSLocalizedString(@"HIGHSCORESMESSAGEMESSAGE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"HIGHSCORESMESSAGENO", nil) otherButtonTitles:NSLocalizedString(@"HIGHSCORESMESSAGEDELETE", nil), nil];
	[alertView show];
	[alertView release];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		return;
	}
	[highScores release];
	highScores = [NSMutableArray array];
	int i;
	for (i=0; i<10; i++) {
		NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:0], @"RPBScore", @" ", @"RPBName", nil];
		[highScores addObject:dictionary];
		[dictionary release];
	}
    CoreGraphicsDrawingAppDelegate *appDelegate = [CoreGraphicsDrawingAppDelegate sharedAppDelegate];
    //appDelegate.highScores=nil;
    if ([appDelegate.highScores retainCount]==0) {
        [appDelegate.highScores retain];
    }
    [appDelegate.highScores retain];
	appDelegate.highScores=highScores;
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/highscoredatabase.db", [appDelegate getPathToSave]] error:nil];
	[appDelegate saveHighScores];
	[self loadHighScores];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [highScores release];
    [name1 release];
    [name2 release];
    [name3 release];
    [name4 release];
    [name5 release];
    [name6 release];
    [name7 release];
    [name8 release];
    [name9 release];
    [name10 release];
    [score1 release];
    [score2 release];
    [score3 release];
    [score4 release];
    [score5 release];
    [score6 release];
    [score7 release];
    [score8 release];
    [score9 release];
    [score10 release];
    [super dealloc];
}


@end
