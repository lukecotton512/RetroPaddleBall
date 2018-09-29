//
//  SettingsViewController.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 3/18/11.
//  Copyright 2011 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController {
	IBOutlet UIButton *greenBallColorButton;
	IBOutlet UIButton *redBallColorButton;
	IBOutlet UIButton *blueBallColorButton;
	IBOutlet UIButton *yellowBallColorButton;
	IBOutlet UIButton *greenPaddleColorButton;
	IBOutlet UIButton *redPaddleColorButton;
	IBOutlet UIButton *bluePaddleColorButton;
	IBOutlet UIButton *yellowPaddleColorButton;
    IBOutlet UIButton *easyButton;
    IBOutlet UIButton *mediumButton;
    IBOutlet UIButton *hardButton;
    IBOutlet UIButton *offSoundButton;
    IBOutlet UIButton *onSoundButton;
    IBOutlet UIView *develView;
	UIButton *__weak selectedButtonBall;
	UIButton *__weak selectedButtonPaddle;
	UIButton *__weak selectedButtonDifficulty;
    UIButton *__weak selectedButtonControl;
    UIButton *__weak selectedButtonSound;
    UISwipeGestureRecognizer *develSettings;
    UIButton *paddlePopUpButton;
    UIButton *ballPopUpButton;
    BOOL paddlePopUpIsEnabled;
    BOOL ballPopUpIsEnabled;

}
@property (nonatomic, strong) IBOutlet UIButton *greenBallColorButton;
@property (nonatomic, strong) IBOutlet UIButton *redBallColorButton;
@property (nonatomic, strong) IBOutlet UIButton *blueBallColorButton;
@property (nonatomic, strong) IBOutlet UIButton *yellowBallColorButton;
@property (nonatomic, strong) IBOutlet UIButton *greenPaddleColorButton;
@property (nonatomic, strong) IBOutlet UIButton *redPaddleColorButton;
@property (nonatomic, strong) IBOutlet UIButton *bluePaddleColorButton;
@property (nonatomic, strong) IBOutlet UIButton *yellowPaddleColorButton;
@property (nonatomic, strong) IBOutlet UIButton *easyButton;
@property (nonatomic, strong) IBOutlet UIButton *mediumButton;
@property (nonatomic, strong) IBOutlet UIButton *hardButton;
@property (nonatomic, strong) IBOutlet UIButton *offSoundButton;
@property (nonatomic, strong) IBOutlet UIButton *onSoundButton;
@property (nonatomic, strong) IBOutlet UIView *develView;
@property (nonatomic, strong) IBOutlet UIView *paddleColorPopUp;
@property (nonatomic, strong) IBOutlet UIView *ballColorPopUp;
@property (nonatomic, strong) IBOutlet UIButton *ballPopUpButton;
@property (nonatomic, strong) IBOutlet UIButton *paddlePopUpButton;
@property (nonatomic, weak) UIButton *selectedButtonBall;
@property (nonatomic, weak) UIButton *selectedButtonPaddle;
@property (nonatomic, weak) UIButton *selectedButtonDifficulty;
@property (nonatomic, weak) UIButton *selectedButtonControl;
@property (nonatomic, weak) UIButton *selectedButtonSound;
@property (nonatomic) UISwipeGestureRecognizer *develSettings;
@property (nonatomic, assign) BOOL paddlePopUpIsEnabled;
@property (nonatomic, assign) BOOL ballPopUpIsEnabled;
-(IBAction)changeBallColor:(id)sender;
-(IBAction)changePaddleColor:(id)sender;
-(IBAction)changeDifficulty:(id)sender;
-(IBAction)changeSoundState:(id)sender;
-(void)openDevelSettings;
-(IBAction)showPaddleColorPopUp:(id)sender;
-(IBAction)showBallColorPopUp:(id)sender;
@end
