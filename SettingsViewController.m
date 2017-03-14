//
//  SettingsViewController.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 3/18/11.
//  Copyright 2011 All rights reserved.
//

#import "SettingsViewController.h"
#import "CoreGraphicsDrawingAppDelegate.h"
#import "RPBUsefulFunctions.h"

@implementation SettingsViewController
@synthesize greenBallColorButton, redBallColorButton, blueBallColorButton, yellowBallColorButton, greenPaddleColorButton, redPaddleColorButton, bluePaddleColorButton, yellowPaddleColorButton, selectedButtonBall, selectedButtonPaddle, easyButton, mediumButton, hardButton, selectedButtonDifficulty, touchButton, accelerometerButton, selectedButtonControl, selectedButtonSound, offSoundButton, onSoundButton, develSettings, develView, paddleColorPopUp, paddlePopUpIsEnabled, ballPopUpIsEnabled, paddlePopUpButton, ballPopUpButton;
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
    // Layout the pop-up views.
    self.paddlePopUpIsEnabled = NO;
    self.ballPopUpIsEnabled = NO;
    self.paddleColorPopUp.layer.cornerRadius=5.0f;
    self.ballColorPopUp.layer.cornerRadius=5.0f;
    self.paddleColorPopUp.layer.borderColor=[UIColor whiteColor].CGColor;
    self.ballColorPopUp.layer.borderColor=[UIColor whiteColor].CGColor;
    self.paddleColorPopUp.layer.borderWidth=1.0f;
    self.ballColorPopUp.layer.borderWidth=1.0f;
    
	// Ball init.
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"] == 0.0f) {
		greenBallColorButton.selected=YES;
		blueBallColorButton.selected=NO;
		redBallColorButton.selected=NO;
		yellowBallColorButton.selected=NO;
		selectedButtonBall = greenBallColorButton;
        [self.ballPopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GreenBallButton" ofType:@"png"]] forState:UIControlStateNormal];
	}
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"] == 0.0f) {
		greenBallColorButton.selected=NO;
		blueBallColorButton.selected=NO;
		redBallColorButton.selected=YES;
		yellowBallColorButton.selected=NO;
		selectedButtonBall = redBallColorButton;
        [self.ballPopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RedBallButton" ofType:@"png"]] forState:UIControlStateNormal];
	}
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"] == 255.0f) {
		greenBallColorButton.selected=NO;
		blueBallColorButton.selected=YES;
		redBallColorButton.selected=NO;
		yellowBallColorButton.selected=NO;
		selectedButtonBall = blueBallColorButton;
        [self.ballPopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BlueBallButton" ofType:@"png"]] forState:UIControlStateNormal];
	}
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorBall"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorBall"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorBall"] == 0.0f) {
		greenBallColorButton.selected=NO;
		blueBallColorButton.selected=NO;
		redBallColorButton.selected=NO;
		yellowBallColorButton.selected=YES;
		selectedButtonBall = yellowBallColorButton;
        [self.ballPopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YellowBallButton" ofType:@"png"]] forState:UIControlStateNormal];
	}	
	//Paddle init.
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"] == 0.0f) {
		greenPaddleColorButton.selected=YES;
		bluePaddleColorButton.selected=NO;
		redPaddleColorButton.selected=NO;
		yellowPaddleColorButton.selected=NO;
		selectedButtonPaddle = greenPaddleColorButton;
        [self.paddlePopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GreenBallButton" ofType:@"png"]] forState:UIControlStateNormal];
	}
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"] == 0.0f) {
		greenPaddleColorButton.selected=NO;
		bluePaddleColorButton.selected=NO;
		redPaddleColorButton.selected=YES;
		yellowPaddleColorButton.selected=NO;
		selectedButtonPaddle = redPaddleColorButton;
        [self.paddlePopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RedBallButton" ofType:@"png"]] forState:UIControlStateNormal];
	}
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"] == 255.0f) {
		greenPaddleColorButton.selected=NO;
		bluePaddleColorButton.selected=YES;
		redPaddleColorButton.selected=NO;
		yellowPaddleColorButton.selected=NO;
		selectedButtonPaddle = bluePaddleColorButton;
        [self.paddlePopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BlueBallButton" ofType:@"png"]] forState:UIControlStateNormal];
	}
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"RPBRedColorPaddle"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBGreenColorPaddle"] == 255.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"RPBBlueColorPaddle"] == 0.0f) {
		greenPaddleColorButton.selected=NO;
		bluePaddleColorButton.selected=NO;
		redPaddleColorButton.selected=NO;
		yellowPaddleColorButton.selected=YES;
		selectedButtonPaddle = yellowPaddleColorButton;
        [self.paddlePopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YellowBallButton" ofType:@"png"]] forState:UIControlStateNormal];
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
	
}

-(void)openDevelSettings
{
    RPBLog(@"Swipe Detected");
    develView.hidden=NO;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction)changeBallColor:(id)sender
{
    // Find what button the user tapped, and then set the color based off what they selected.
    // User selected green ball color.
	if([sender tag] == 0)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBRedColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBGreenColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBBlueColorBall"];
		selectedButtonBall.selected = NO;
		greenBallColorButton.selected = YES;
		selectedButtonBall = greenBallColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
        [self.ballPopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GreenBallButton" ofType:@"png"]] forState:UIControlStateNormal];
	}
    // User selected blue ball color.
	if([sender tag] == 1)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBRedColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBGreenColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBBlueColorBall"];
		selectedButtonBall.selected = NO;
		blueBallColorButton.selected = YES;
		selectedButtonBall = blueBallColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
        [self.ballPopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BlueBallButton" ofType:@"png"]] forState:UIControlStateNormal];
	}
    // User selected red ball color.
	if([sender tag] == 2)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBRedColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBGreenColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBBlueColorBall"];
		selectedButtonBall.selected = NO;
		redBallColorButton.selected = YES;
		selectedButtonBall = redBallColorButton;
        [self.ballPopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RedBallButton" ofType:@"png"]] forState:UIControlStateNormal];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    // User selected yellow ball color.
	if([sender tag] == 3)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBRedColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBGreenColorBall"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBBlueColorBall"];
		selectedButtonBall.selected = NO;
		yellowBallColorButton.selected = YES;
		selectedButtonBall = yellowBallColorButton;
        [self.ballPopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YellowBallButton" ofType:@"png"]] forState:UIControlStateNormal];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}
-(IBAction)changePaddleColor:(id)sender
{
    // Change the paddle color to the selected color.
    // User selected green paddle color.
	if([sender tag] == 0)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBRedColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBGreenColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBBlueColorPaddle"];
		selectedButtonPaddle.selected = NO;
		greenPaddleColorButton.selected = YES;
		selectedButtonPaddle = greenPaddleColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
        [self.paddlePopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GreenBallButton" ofType:@"png"]] forState:UIControlStateNormal];
	}
    // User selected blue paddle color.
	if([sender tag] == 1)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBRedColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBGreenColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBBlueColorPaddle"];
		selectedButtonPaddle.selected = NO;
		bluePaddleColorButton.selected = YES;
		selectedButtonPaddle = bluePaddleColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
        [self.paddlePopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BlueBallButton" ofType:@"png"]] forState:UIControlStateNormal];
	}
    // User selected red paddle color.
	if([sender tag] == 2)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBRedColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBGreenColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBBlueColorPaddle"];
		selectedButtonPaddle.selected = NO;
		redPaddleColorButton.selected = YES;
		selectedButtonPaddle = redPaddleColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
        [self.paddlePopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RedBallButton" ofType:@"png"]] forState:UIControlStateNormal];
	}
    // User selected yellow paddle color.
	if([sender tag] == 3)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBRedColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:255.0f forKey:@"RPBGreenColorPaddle"];
		[[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"RPBBlueColorPaddle"];
		selectedButtonPaddle.selected = NO;
		yellowPaddleColorButton.selected = YES;
		selectedButtonPaddle = yellowPaddleColorButton;
		[[NSUserDefaults standardUserDefaults] synchronize];
        [self.paddlePopUpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YellowBallButton" ofType:@"png"]] forState:UIControlStateNormal];
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
// Enables or disables sound based off what the user selected.
-(IBAction)changeSoundState:(id)sender
{
    // Enable sound.
    if ([sender tag] == 1) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RPBSound"];
		selectedButtonSound.selected = NO;
		onSoundButton.selected = YES;
		selectedButtonSound = onSoundButton;
	}
    // Disable sound.
	if ([sender tag] == 2) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RPBSound"];
		selectedButtonSound.selected = NO;
		offSoundButton.selected = YES;
		selectedButtonSound = offSoundButton;
	}
}
-(IBAction)showPaddleColorPopUp:(id)sender {
    if (self.paddlePopUpIsEnabled==NO) {
        if (self.ballPopUpIsEnabled==YES) {
            [self showBallColorPopUp:nil];
        }
        CGRect originalFrame = self.paddleColorPopUp.frame;
        float sizeOfScreen;
        sizeOfScreen = self.view.bounds.size.width;
        CGRect buttonFrame = ((UIButton *) sender).frame;
        buttonFrame = [self.view convertRect: buttonFrame fromView: ((UIButton *) sender).superview];
        CGRect newFrame = CGRectMake((sizeOfScreen/2)-(self.paddleColorPopUp.frame.size.width/2), buttonFrame.origin.y+buttonFrame.size.height, originalFrame.size.width, originalFrame.size.height);
        self.paddleColorPopUp.frame = newFrame;
        [self.view addSubview:self.paddleColorPopUp];
        self.paddlePopUpIsEnabled=YES;
    } else {
        [self.paddleColorPopUp removeFromSuperview];
        self.paddlePopUpIsEnabled=NO;
    }
}
-(IBAction)showBallColorPopUp:(id)sender {
    if (self.ballPopUpIsEnabled==NO) {
        if (self.paddlePopUpIsEnabled==YES) {
            [self showPaddleColorPopUp:nil];
        }
        CGRect originalFrame = self.ballColorPopUp.frame;
        float sizeOfScreen;
        sizeOfScreen = self.view.bounds.size.width;
        CGRect buttonFrame = ((UIButton *) sender).frame;
        buttonFrame = [self.view convertRect: buttonFrame fromView: ((UIButton *) sender).superview];
        CGRect newFrame = CGRectMake((sizeOfScreen/2)-(self.ballColorPopUp.frame.size.width/2), buttonFrame.origin.y+buttonFrame.size.height, originalFrame.size.width, originalFrame.size.height);
        self.ballColorPopUp.frame = newFrame;
        [self.view addSubview:self.ballColorPopUp];
        self.ballPopUpIsEnabled=YES;
    } else {
        [self.ballColorPopUp removeFromSuperview];
        self.ballPopUpIsEnabled=NO;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.ballPopUpIsEnabled==NO&&self.paddlePopUpIsEnabled==NO) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint locationOfTouch = [touch locationInView:self.view];
    if (self.ballPopUpIsEnabled==YES&&!CGRectContainsPoint(self.ballColorPopUp.frame, locationOfTouch)) {
        [self showBallColorPopUp:nil];
    } else if (self.paddlePopUpIsEnabled==YES&&!CGRectContainsPoint(self.paddleColorPopUp.frame, locationOfTouch)){
        [self showPaddleColorPopUp:nil];
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


- (void)dealloc {
    [self.view removeGestureRecognizer:develSettings];
}


@end
