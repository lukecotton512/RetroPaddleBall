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
@interface CoreGraphicsDrawingAppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    UIWindow *window;
	UIViewController *__weak currentViewController;
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
    int currentTutorialController;
	//NSTimer *powerUpTimer;
	//NSTimer *powerUpStartedTimer;
	//UIImageView *powerUpImage;
    MainMenuViewController *viewController;
	CoreGraphicsDrawingViewController *__weak gameController;
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
-(void)loadData:(NSMetadataQuery *)query2;
-(void)queryDidFinishGathering:(NSNotification *)notification;
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response ;
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) NSTimer *appSupportTimer;
@property (nonatomic, strong) HighScoreDocument *highScoreDoc;
@property (nonatomic, weak) UIViewController *currentViewController;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int currentTutorialController;
@property (nonatomic, assign) BOOL soundIsOn;
@property (nonatomic, assign) BOOL highScoresEnabled;
@property (nonatomic, assign) BOOL isDone;
@property (nonatomic, assign) BOOL alreadyChecked;
@property (nonatomic, assign) BOOL upgradeEligible;
@property (nonatomic, assign) BOOL upgradePurchased;
@property (nonatomic, assign) double difficultyMultiplier;
@property (nonatomic, strong) MainMenuViewController *viewController;
@property (nonatomic, weak) CoreGraphicsDrawingViewController *gameController;
@property (nonatomic, strong) GameOverViewController *gameOverController;
@property (nonatomic, strong) SettingsViewController *settingsController;
@property (nonatomic, strong) HighScoreViewController *highScoreController;
@property (nonatomic, strong) HowToPlayViewController *howToPlayController;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSDictionary *defaults;
@property (nonatomic, strong) NSMutableArray *highScores;
@property (nonatomic, strong) NSURL *ubiq;
@property (nonatomic, assign) BOOL icloudEnabled;
@property (nonatomic, strong) NSMetadataQuery *query;
@property (nonatomic, assign) BOOL isOniPad;
@property (nonatomic, assign) BOOL databaseCreated;
@property (nonatomic, strong) SKProduct *removeAdsProduct;
@property (nonatomic, strong) SKProduct *removeAdsFreeProduct;
@property (nonatomic, strong) SKProductsRequest *productsRequest;
//@property (nonatomic, retain) UIImageView *powerUpImage;
//@property (nonatomic, assign) int didStartStartPowerUp;
//-(CGRect)randomRectangle;
@end

