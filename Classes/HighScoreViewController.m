//
//  HighScoreViewController.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 4/23/11.
//  Copyright 2011 All rights reserved.
//

#import "HighScoreViewController.h"
#import "CoreGraphicsDrawingAppDelegate.h"
#import "RPBUsefulFunctions.h"

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
    // Load all high scores upon the view being put onto the screen.
	[super viewDidAppear:animated];
	[self loadHighScores];
}
-(void)loadHighScores
{
    // All high scores. Loop through each field and put the text in the fields.
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
    // Present an alert view to the user asking to remove all high scores and present it.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"HIGHSCORESMESSAGETITLE", nil) message:NSLocalizedString(@"HIGHSCORESMESSAGEMESSAGE", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"HIGHSCORESMESSAGENO", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"HIGHSCORESMESSAGEDELETE", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self deleteScores];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:true completion:nil];
}

// Deletes all scores.
-(void)deleteScores {
    // If the didn't then clear out all high scores by creating a new array to replace the original.
    highScores = [NSMutableArray array];
    int i;
    for (i=0; i<10; i++) {
        NSDictionary *dictionary = @{@"RPBScore": @0, @"RPBName": @" "};
        [highScores addObject:dictionary];
    }
    
    // Delete all high scores by removing the original file and then replacing it.
    CoreGraphicsDrawingAppDelegate *appDelegate = [CoreGraphicsDrawingAppDelegate sharedAppDelegate];
    appDelegate.highScores=highScores;
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/highscoredatabase.db", [appDelegate getPathToSave]] error:nil];
    [appDelegate saveHighScores];
    [self loadHighScores];
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

@end
