//
//  SettingsViewController.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 3/18/11.
//  Copyright 2011 All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

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
    IBOutlet UIButton *touchButton;
    IBOutlet UIButton *accelerometerButton;
    IBOutlet UIButton *offSoundButton;
    IBOutlet UIButton *onSoundButton;
    IBOutlet UIView *develView;
	UIButton *selectedButtonBall;
	UIButton *selectedButtonPaddle;
	UIButton *selectedButtonDifficulty;
    UIButton *selectedButtonControl;
    UIButton *selectedButtonSound;
    UISwipeGestureRecognizer *develSettings;

}
@property (nonatomic, retain) IBOutlet UIButton *greenBallColorButton;
@property (nonatomic, retain) IBOutlet UIButton *redBallColorButton;
@property (nonatomic, retain) IBOutlet UIButton *blueBallColorButton;
@property (nonatomic, retain) IBOutlet UIButton *yellowBallColorButton;
@property (nonatomic, retain) IBOutlet UIButton *greenPaddleColorButton;
@property (nonatomic, retain) IBOutlet UIButton *redPaddleColorButton;
@property (nonatomic, retain) IBOutlet UIButton *bluePaddleColorButton;
@property (nonatomic, retain) IBOutlet UIButton *yellowPaddleColorButton;
@property (nonatomic, retain) IBOutlet UIButton *easyButton;
@property (nonatomic, retain) IBOutlet UIButton *mediumButton;
@property (nonatomic, retain) IBOutlet UIButton *hardButton;
@property (nonatomic, retain) IBOutlet UIButton *touchButton;
@property (nonatomic, retain) IBOutlet UIButton *accelerometerButton;
@property (nonatomic, retain) IBOutlet UIButton *offSoundButton;
@property (nonatomic, retain) IBOutlet UIButton *onSoundButton;
@property (nonatomic, retain) IBOutlet UIView *develView;
@property (nonatomic, retain) IBOutlet UIButton *purchaseButton;
@property (nonatomic, retain) IBOutlet UILabel *purchaseLabel;
@property (nonatomic, assign) UIButton *selectedButtonBall;
@property (nonatomic, assign) UIButton *selectedButtonPaddle;
@property (nonatomic, assign) UIButton *selectedButtonDifficulty;
@property (nonatomic, assign) UIButton *selectedButtonControl;
@property (nonatomic, assign) UIButton *selectedButtonSound;
@property (nonatomic, assign) UISwipeGestureRecognizer *develSettings;
-(IBAction)changeBallColor:(id)sender;
-(IBAction)changePaddleColor:(id)sender;
-(IBAction)returnToMainMenu:(id)sender;
-(IBAction)changeDifficulty:(id)sender;
-(IBAction)changeControlMethod:(id)sender;
-(IBAction)changeSoundState:(id)sender;
-(IBAction)removeAds:(id)sender;
-(void)openDevelSettings;
-(IBAction)restorePurchases:(id)sender;
@end
