//
//  MainMenuViewController.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 2/11/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import "MainMenuViewController.h"
#import "CoreGraphicsDrawingAppDelegate.h"
#import "RPBUsefulFunctions.h"

@implementation MainMenuViewController
@synthesize window;
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

-(IBAction)goToBeginning:(UIStoryboardSegue *)unwindSegue {
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Setup the tutorial view controller.
    if ([segue.identifier isEqualToString:@"showTutorial"] == YES) {
        UIStoryboard *storyboard;
        if([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] isOniPad]) {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPad" bundle:nil];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPhone" bundle:nil];
        }
        UIPageViewController *pageViewController = segue.destinationViewController;
        [pageViewController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"tutorial0"]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] setCurrentTutorialController:0];
        pageViewController.dataSource = [CoreGraphicsDrawingAppDelegate sharedAppDelegate];
        pageViewController.delegate = [CoreGraphicsDrawingAppDelegate sharedAppDelegate];
    }
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
