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
@synthesize highScores;
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
    int i=0;
    for (UILabel *nameLabel in self.nameFields) {
        nameLabel.text = [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores][i][@"RPBName"];
        i++;
    }
    i=0;
    for (UILabel *scoreLabel in self.scoreFields) {
        scoreLabel.text = [NSString stringWithFormat: @"%i", [[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] highScores][i][@"RPBScore"] intValue], nil];
        i++;
    }
}
-(IBAction)resetHighScores:(id)sender
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"HIGHSCORESMESSAGETITLE", nil) message:NSLocalizedString(@"HIGHSCORESMESSAGEMESSAGE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"HIGHSCORESMESSAGENO", nil) otherButtonTitles:NSLocalizedString(@"HIGHSCORESMESSAGEDELETE", nil), nil];
	[alertView show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		return;
	}
	highScores = [NSMutableArray array];
	int i;
	for (i=0; i<10; i++) {
		NSDictionary *dictionary = @{@"RPBScore": @0, @"RPBName": @" "};
		[highScores addObject:dictionary];
	}
    CoreGraphicsDrawingAppDelegate *appDelegate = [CoreGraphicsDrawingAppDelegate sharedAppDelegate];
    //appDelegate.highScores=nil;
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




@end
