//
//  SettingsViewController.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 3/18/11.
//  Copyright 2011 All rights reserved.
//

#import "SettingsViewController.h"
#import "CoreGraphicsDrawingAppDelegate.h"
@implementation SettingsViewController
@synthesize greenBallColorButton, redBallColorButton, blueBallColorButton, yellowBallColorButton, greenPaddleColorButton, redPaddleColorButton, bluePaddleColorButton, yellowPaddleColorButton, selectedButtonBall, selectedButtonPaddle, easyButton, mediumButton, hardButton, selectedButtonDifficulty, touchButton, accelerometerButton, selectedButtonControl, selectedButtonSound, offSoundButton, onSoundButton, develSettings, develView, purchaseLabel, purchaseButton;
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
    if (![SKPaymentQueue canMakePayments]) {
        purchaseLabel.hidden=YES;
        purchaseButton.hidden=YES;
    }
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] upgradePurchased]) {
        [purchaseLabel setHidden:YES];
        [purchaseButton setHidden:YES];
    }
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] upgradeEligible]) {
        [purchaseButton setTitle:@"Free" forState:UIControlStateNormal];
        
    }
	//Ball init
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"] == 0.0f) {
		greenBallColorButton.selected=YES;
		blueBallColorButton.selected=NO;
		redBallColorButton.selected=NO;
		yellowBallColorButton.selected=NO;
		selectedButtonBall = greenBallColorButton;
	}
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"] == 0.0f) {
		greenBallColorButton.selected=NO;
		blueBallColorButton.selected=NO;
		redBallColorButton.selected=YES;
		yellowBallColorButton.selected=NO;
		selectedButtonBall = redBallColorButton;
	}
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"] == 255.0f) {
		greenBallColorButton.selected=NO;
		blueBallColorButton.selected=YES;
		redBallColorButton.selected=NO;
		yellowBallColorButton.selected=NO;
		selectedButtonBall = blueBallColorButton;
	}
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"] == 0.0f) {
		greenBallColorButton.selected=NO;
		blueBallColorButton.selected=NO;
		redBallColorButton.selected=NO;
		yellowBallColorButton.selected=YES;
		selectedButtonBall = yellowBallColorButton;
	}	
	//Paddle init
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"] == 0.0f) {
		greenPaddleColorButton.selected=YES;
		bluePaddleColorButton.selected=NO;
		redPaddleColorButton.selected=NO;
		yellowPaddleColorButton.selected=NO;
		selectedButtonPaddle = greenPaddleColorButton;
	}
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"] == 0.0f) {
		greenPaddleColorButton.selected=NO;
		bluePaddleColorButton.selected=NO;
		redPaddleColorButton.selected=YES;
		yellowPaddleColorButton.selected=NO;
		selectedButtonPaddle = redPaddleColorButton;
	}
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"] == 255.0f) {
		greenPaddleColorButton.selected=NO;
		bluePaddleColorButton.selected=YES;
		redPaddleColorButton.selected=NO;
		yellowPaddleColorButton.selected=NO;
		selectedButtonPaddle = bluePaddleColorButton;
	}
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"] == 0.0f) {
		greenPaddleColorButton.selected=NO;
		bluePaddleColorButton.selected=NO;
		redPaddleColorButton.selected=NO;
		yellowPaddleColorButton.selected=YES;
		selectedButtonPaddle = yellowPaddleColorButton;
	} if ([[NSUserDefaults standardUserDefaults] doubleForKey:@"RPBDifficultyMultiplier"] == 1.0) {
		easyButton.selected=YES;
		mediumButton.selected=NO;
		hardButton.selected=NO;
		selectedButtonDifficulty = easyButton;
	} if ([[NSUserDefaults standardUserDefaults] doubleForKey:@"RPBDifficultyMultiplier"] == 2.0) {
		easyButton.selected=NO;
		mediumButton.selected=YES;
		hardButton.selected=NO;
		selectedButtonDifficulty = mediumButton;
	} if ([[NSUserDefaults standardUserDefaults] doubleForKey:@"RPBDifficultyMultiplier"] == 5.0) {
		easyButton.selected=NO;
		mediumButton.selected=NO;
		hardButton.selected=YES;
		selectedButtonDifficulty = hardButton;
	} if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBAccelerometerEnabled"]== NO) {
        touchButton.selected=YES;
        accelerometerButton.selected=NO;
        selectedButtonControl = touchButton;
    } if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBAccelerometerEnabled"]== YES) {
        touchButton.selected=NO;
        accelerometerButton.selected=YES;
        selectedButtonControl = accelerometerButton;
    } if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBSound"]== YES) {
        onSoundButton.selected=YES;
        offSoundButton.selected=NO;
        selectedButtonSound = onSoundButton;
    } if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBSound"]== NO) {
        onSoundButton.selected=NO;
        offSoundButton.selected=YES;
        selectedButtonSound = offSoundButton;
    }
    develSettings = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDevelSettings)];
    develSettings.direction=UISwipeGestureRecognizerDirectionUp;
    develSettings.numberOfTouchesRequired=3;
    [self.view addGestureRecognizer:develSettings];
	/*greenBallColorButton.adjustsImageWhenDisabled=YES;
	redBallColorButton.adjustsImageWhenDisabled=YES;
	blueBallColorButton.adjustsImageWhenDisabled=YES;
	yellowBallColorButton.adjustsImageWhenDisabled=YES;
	greenPaddleColorButton.adjustsImageWhenDisabled=YES;
	bluePaddleColorButton.adjustsImageWhenDisabled=YES;
	redPaddleColorButton.adjustsImageWhenDisabled=YES;
	yellowPaddleColorButton.adjustsImageWhenDisabled=YES;*/
	
}
-(IBAction)restorePurchases:(id)sender {
    [[CoreGraphicsDrawingAppDelegate sharedAppDelegate] restorePurchases];
}
-(IBAction)removeAds:(id)sender {
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] upgradeEligible]) {
        [[SKPaymentQueue defaultQueue] addPayment:[SKPayment paymentWithProduct:[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] removeAdsFreeProduct]]];
    } else {
        [[SKPaymentQueue defaultQueue] addPayment:[SKPayment paymentWithProduct:[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] removeAdsProduct]]];
    }
}
-(void)openDevelSettings
{
    RPBLOG(@"Swipe Detected");
    develView.hidden=NO;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
/*-(IBAction)easyButton:(id)sender
{
	
}
-(IBAction)middleButton:(id)sender
{
	
}
-(IBAction)hardButton:(id)sender
{
	
}*/
-(IBAction)changeBallColor:(id)sender
{
	if([sender tag] == 0)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBRedColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBGreenColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBBlueColorBall"];
		selectedButtonBall.selected = NO;
		greenBallColorButton.selected = YES;
		selectedButtonBall = greenBallColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	if([sender tag] == 1)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBRedColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBGreenColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBBlueColorBall"];
		selectedButtonBall.selected = NO;
		blueBallColorButton.selected = YES;
		selectedButtonBall = blueBallColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	if([sender tag] == 2)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBRedColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBGreenColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBBlueColorBall"];
		selectedButtonBall.selected = NO;
		redBallColorButton.selected = YES;
		selectedButtonBall = redBallColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	if([sender tag] == 3)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBRedColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBGreenColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBBlueColorBall"];
		selectedButtonBall.selected = NO;
		yellowBallColorButton.selected = YES;
		selectedButtonBall = yellowBallColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}
-(IBAction)changePaddleColor:(id)sender
{
	if([sender tag] == 0)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBRedColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBGreenColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBBlueColorPaddle"];
		selectedButtonPaddle.selected = NO;
		greenPaddleColorButton.selected = YES;
		selectedButtonPaddle = greenPaddleColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	if([sender tag] == 1)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBRedColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBGreenColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBBlueColorPaddle"];
		selectedButtonPaddle.selected = NO;
		bluePaddleColorButton.selected = YES;
		selectedButtonPaddle = bluePaddleColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	if([sender tag] == 2)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBRedColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBGreenColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBBlueColorPaddle"];
		selectedButtonPaddle.selected = NO;
		redPaddleColorButton.selected = YES;
		selectedButtonPaddle = redPaddleColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	if([sender tag] == 3)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBRedColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBGreenColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBBlueColorPaddle"];
		selectedButtonPaddle.selected = NO;
		yellowPaddleColorButton.selected = YES;
		selectedButtonPaddle = yellowPaddleColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}
-(IBAction)changeDifficulty:(id)sender
{
	if ([sender tag] == 1) {
		[[NSUserDefaults standardUserDefaults] setDouble:1.0 forKey:@"RPBDifficultyMultiplier"];
		selectedButtonDifficulty.selected = NO;
		easyButton.selected = YES;
		selectedButtonDifficulty = easyButton;
	}
	if ([sender tag] == 2) {
		[[NSUserDefaults standardUserDefaults] setDouble:2.0 forKey:@"RPBDifficultyMultiplier"];
		selectedButtonDifficulty.selected = NO;
		mediumButton.selected = YES;
		selectedButtonDifficulty = mediumButton;
	}
	if ([sender tag] == 3) {
		[[NSUserDefaults standardUserDefaults] setDouble:5.0 forKey:@"RPBDifficultyMultiplier"];
		selectedButtonDifficulty.selected = NO;
		hardButton.selected = YES;
		selectedButtonDifficulty = hardButton;
	}
}
-(IBAction)changeControlMethod:(id)sender
{
    if ([sender tag] == 1) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RPBAccelerometerEnabled"];
		selectedButtonControl.selected = NO;
		touchButton.selected = YES;
		selectedButtonControl = touchButton;
	}
	if ([sender tag] == 2) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RPBAccelerometerEnabled"];
		selectedButtonControl.selected = NO;
		accelerometerButton.selected = YES;
		selectedButtonControl = accelerometerButton;
	}
}
-(IBAction)changeSoundState:(id)sender
{
    if ([sender tag] == 1) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RPBSound"];
		selectedButtonSound.selected = NO;
		onSoundButton.selected = YES;
		selectedButtonSound = onSoundButton;
	}
	if ([sender tag] == 2) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RPBSound"];
		selectedButtonSound.selected = NO;
		offSoundButton.selected = YES;
		selectedButtonSound = offSoundButton;
	}
}
-(IBAction)returnToMainMenu:(id)sender
{
	[[CoreGraphicsDrawingAppDelegate sharedAppDelegate] showMainMenu];
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
    [greenBallColorButton release];
    [redBallColorButton release];
    [blueBallColorButton release];
    [yellowBallColorButton release];
    [greenPaddleColorButton release];
    [redPaddleColorButton release];
    [bluePaddleColorButton release];
    [yellowPaddleColorButton release];
    [self.view removeGestureRecognizer:develSettings];
    [develSettings release];
    [easyButton release];
    [hardButton release];
    [mediumButton release];
    [touchButton release];
    [accelerometerButton release];
    [offSoundButton release];
    [onSoundButton release];
    [develView release];
    [super dealloc];
}


@end
