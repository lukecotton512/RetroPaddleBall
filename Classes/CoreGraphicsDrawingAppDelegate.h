//
//  CoreGraphicsDrawingAppDelegate.h
//  CoreGraphicsDrawing
//
//  Created by Luke Cotton on 2/5/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "CoreGraphicsDrawingViewController.h"
@class MainMenuViewController;
@class GameOverViewController;
@class SettingsViewController;
@class HighScoreViewController;
@class HowToPlayViewController;
@class HighScoreDocument;
@interface CoreGraphicsDrawingAppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    UIWindow *window;
	UIViewController *currentViewController;
	NSUserDefaults *userDefaults;
	NSDictionary *defaults;
	NSMutableArray *highScores;
    NSTimer *appSupportTimer;
    NSURL *ubiq;
    NSMetadataQuery *query;
    SKProduct *removeAdsProduct;
    SKProduct *removeAdsFreeProduct;
    SKProductsRequest *productsRequest;
    HighScoreDocument *highScoreDoc;
    BOOL icloudEnabled;
    BOOL databaseCreated;
    BOOL upgradePurchased;
	//NSTimer *powerUpTimer;
	//NSTimer *powerUpStartedTimer;
	//UIImageView *powerUpImage;
    MainMenuViewController *viewController;
	CoreGraphicsDrawingViewController *gameController;
	GameOverViewController *gameOverController;
	SettingsViewController *settingsController;
	HighScoreViewController *highScoreController;
    HowToPlayViewController *howToPlayController;
	int score;
    BOOL highScoresEnabled;
    BOOL alreadyChecked;
    BOOL soundIsOn;
    BOOL upgradeEligible;
	double difficultyMultiplier;
    BOOL isDone;
    BOOL isOniPad;
}
-(void)playGame:(id)sender;
-(void)endGame;
-(void)showMainMenu;
-(void)showSettings;
-(void)showHighScores;
-(void)showHowToPlay;
+(id)sharedAppDelegate;
-(NSString *)getPathToSave;
-(void)appSupportTimerCall:(NSTimer *)theTimer;
-(void)saveHighScores;
-(void)restorePurchases;
-(void)checkEligibility;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSTimer *appSupportTimer;
@property (nonatomic, retain) HighScoreDocument *highScoreDoc;
@property (nonatomic, assign) UIViewController *currentViewController;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) BOOL soundIsOn;
@property (nonatomic, assign) BOOL highScoresEnabled;
@property (nonatomic, assign) BOOL isDone;
@property (nonatomic, assign) BOOL alreadyChecked;
@property (nonatomic, assign) BOOL upgradeEligible;
@property (nonatomic, assign) BOOL upgradePurchased;
@property (nonatomic, assign) double difficultyMultiplier;
@property (nonatomic, retain) MainMenuViewController *viewController;
@property (nonatomic, retain) CoreGraphicsDrawingViewController *gameController;
@property (nonatomic, retain) GameOverViewController *gameOverController;
@property (nonatomic, retain) SettingsViewController *settingsController;
@property (nonatomic, retain) HighScoreViewController *highScoreController;
@property (nonatomic, retain) HowToPlayViewController *howToPlayController;
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (nonatomic, retain) NSDictionary *defaults;
@property (nonatomic, retain) NSMutableArray *highScores;
@property (nonatomic, retain) NSURL *ubiq;
@property (nonatomic, assign) BOOL icloudEnabled;
@property (nonatomic, retain) NSMetadataQuery *query;
@property (nonatomic, assign) BOOL isOniPad;
@property (nonatomic, assign) BOOL databaseCreated;
@property (nonatomic, retain) SKProduct *removeAdsProduct;
@property (nonatomic, retain) SKProduct *removeAdsFreeProduct;
@property (nonatomic, retain) SKProductsRequest *productsRequest;
//@property (nonatomic, retain) UIImageView *powerUpImage;
//@property (nonatomic, assign) int didStartStartPowerUp;
//-(CGRect)randomRectangle;
@end

