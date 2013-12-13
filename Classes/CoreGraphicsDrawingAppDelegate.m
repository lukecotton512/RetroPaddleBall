//
//  CoreGraphicsDrawingAppDelegate.m
//  CoreGraphicsDrawing
//
//  Created by Luke Cotton on 2/5/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import "CoreGraphicsDrawingAppDelegate.h"
#import "MainMenuViewController.h"
#import "GameOverViewController.h"
#import "SettingsViewController.h"
#import "HighScoreViewController.h"
#import "HowToPlayViewController.h"
#import "HighScoreDocument.h"
@implementation CoreGraphicsDrawingAppDelegate

@synthesize window;
@synthesize viewController, gameController, gameOverController, currentViewController, settingsController, userDefaults, defaults, score, highScoreController, highScores, difficultyMultiplier, appSupportTimer, highScoresEnabled, howToPlayController, soundIsOn, ubiq, icloudEnabled, query, highScoreDoc, isDone, isOniPad, databaseCreated, alreadyChecked, upgradeEligible, productsRequest,removeAdsFreeProduct, removeAdsProduct, upgradePurchased;


#pragma mark -
#pragma mark Application lifecycle
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSUbiquitousKeyValueStore *cloudDefaults = [NSUbiquitousKeyValueStore defaultStore];
    [cloudDefaults synchronize];
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    self.databaseCreated=NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    highScoresEnabled=NO;
    if (([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location!=NSNotFound)) {
        isOniPad=YES;
    } else {
        isOniPad=NO;
    }
    // Add the view controller's view to the window and display.
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error:nil];
    self.window.rootViewController=viewController;
    //[self.window addSubview:viewController.view];
	currentViewController = viewController;
    self.alreadyChecked=NO;
    self.upgradePurchased = NO;
    [self.window makeKeyAndVisible];
	userDefaults = [NSUserDefaults standardUserDefaults];
	defaults = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.0f], @"RPBRedColorPaddle", [NSNumber numberWithFloat:255.0f], @"RPBGreenColorPaddle", [NSNumber numberWithFloat:0.0f], @"RPBBlueColorPaddle", [NSNumber numberWithFloat:255.0f], @"RPBRedColorBall", [NSNumber numberWithFloat:0.0f], @"RPBGreenColorBall", [NSNumber numberWithFloat:0.0f], @"RPBBlueColorBall",[NSNumber numberWithDouble:1.0], @"RPBDifficultyMultiplier",[NSNumber numberWithBool:NO], @"RPBAccelerometerEnabled",[NSNumber numberWithBool:YES], @"RPBSound", [NSNumber numberWithBool:NO], @"RPBAlreadyChecked", [NSNumber numberWithBool:NO], @"RPBDatabaseCreated", [NSNumber numberWithBool:NO], @"RPBUpgradeEligible",[NSNumber numberWithBool:NO], @"RPBUpgradeBought", [NSNumber numberWithBool:NO], @"RPBFreeUpgradeNotice",nil];
    NSUbiquitousKeyValueStore *cloudDefaults = [NSUbiquitousKeyValueStore defaultStore];
    [cloudDefaults synchronize];
    sleep(2);
    [userDefaults registerDefaults:defaults];
    [userDefaults synchronize];
    [self checkEligibility];
    //[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]] error:nil];
    //testing for database created
    //databaseCreated=[[NSUserDefaults standardUserDefaults] boolForKey:@"RPBDatabaseCreated"];
    ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    //load high scores and iCloud
    if (ubiq) {
        icloudEnabled=YES;
        query = [[NSMetadataQuery alloc] init];
        [query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", NSMetadataItemFSNameKey, @"highscoredatabase.db"];
        [query setPredicate:pred];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDidFinishGathering:) name:NSMetadataQueryDidFinishGatheringNotification object:query];
        [query startQuery];
    } else {
        //self.highScores = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]]]];
        self.highScores = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]]];
        if(highScores==nil) {
            self.highScores = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]]]]];
            if (highScores==nil||[highScores count]==0) {
                highScores = [NSMutableArray array];
                int i;
                for (i=0; i<10; i++) {
                    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:0], @"RPBScore", @" ", @"RPBName", nil];
                    [highScores addObject:dictionary];
                    [dictionary release];
                }
                //self.databaseCreated=YES;
                [self saveHighScores];
                [highScores retain];
            }
        }
    }
    NSSet *productIdentifiers;
    if (self.upgradeEligible) {
        NSLog(@"Upgrade Eligible = YES");
    } else {
        NSLog(@"Upgrade Eligible = NO");
    }
    productIdentifiers = [NSSet setWithObjects:@"com.lukecotton.retropaddleball.disableadsfree",@"com.lukecotton.retropaddleball.disableads", nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] upgradePurchased]) {
        [viewController hideAds];
        [settingsController.purchaseLabel setHidden:YES];
        [settingsController.purchaseButton setHidden:YES];
    }
    //RPBLOG(@"%i",[highScores retainCount]);
    //Anti-Piracy Code
    char char1=0x53, char2=0x69, char3=0x67, char4=0x6e, char5=0x65, char6=0x72, char7=0x49, char8=0x64, char9=0x65, char10=0x6e, char11=0x69, char12=0x74, char13=0x79, char14=0x00;
    char charA[15]={char1, char2, char3, char4, char5, char6, char7, char8, char9, char10, char12,char11, char12, char13, char14};
    NSString *charS = [[NSString alloc] initWithCString:charA encoding:NSASCIIStringEncoding];
    //RPBLOG(@"%@",charS);
    char char15=0x49, char16=0x6e, char17=0x66, char18=0x6f, char19=0x70, char20=0x6c, char21=0x69, char22=0x73, char23=0x74;
    char charA2[5]={char15, char16, char17, char18, char14};
    char charA3[6]={char19, char20, char21, char22, char23, char14};
    NSString *charS2 = [[NSString alloc] initWithCString:charA2 encoding:NSASCIIStringEncoding];
    NSString *charS3 = [[NSString alloc] initWithCString:charA3 encoding:NSASCIIStringEncoding];
    //NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:charS2 withExtension:charS3]];
    //NSBundle *imageAccess=[NSBundle mainBundle];
    char charA4[15]={0x69,0x6e,0x66,0x6f,0x44,0x69,0x63,0x74,0x69,0x6f,0x6e,0x61,0x72,0x79,char14};
    char charA5[11]={0x6d,0x61,0x69,0x6e,0x42,0x75,0x6e,0x64,0x6c,0x65,char14};
    NSString *charS4 = [[NSString alloc] initWithCString:charA4 encoding:NSASCIIStringEncoding];
    NSString *charS5 = [[NSString alloc] initWithCString:charA5 encoding:NSASCIIStringEncoding];
    Class class=[NSBundle class];
    NSDictionary *dict = objc_msgSend(objc_msgSend(class,NSSelectorFromString(charS5)),NSSelectorFromString(charS4));
    if([dict objectForKey:charS] != nil)
    {
        appSupportTimer = [NSTimer scheduledTimerWithTimeInterval:300.00 target:self selector:@selector(appSupportTimerCall:) userInfo:nil repeats:YES];
        [appSupportTimer fire];
        [appSupportTimer retain];
    }
    [charS release];
    [charS2 release];
    [charS3 release];
    [charS4 release];
    [charS5 release];
    [cloudDefaults synchronize];
    return YES;
}
-(void)checkEligibility {
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath]; // e.g. /var/mobile/Applications/<GUID>/<AppName>.app
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDictionary* attrs = [manager attributesOfItemAtPath:bundleRoot error:nil];
    NSLog(@"Build or download Date/Time of first  version to be installed: %@", [attrs fileCreationDate]);
    NSDate *modDate = [attrs fileModificationDate];
    NSLog(@"Date/Time of last install (unless bundle changed by code): %@", modDate);
    NSString *rootPath = [bundleRoot substringToIndex:[bundleRoot rangeOfString:@"/" options:NSBackwardsSearch].location]; // e.g /var/mobile/Applications/<GUID>
    attrs = [manager attributesOfItemAtPath:rootPath error:nil];
    NSDate *createDate = [attrs fileCreationDate];
    NSLog(@"Date/Time first installed (or first reinstalled after deletion): %@", createDate);
    NSTimeInterval timeCreate = [createDate timeIntervalSince1970], timeMod = [modDate timeIntervalSince1970];
    NSTimeInterval interval1 = timeCreate-61, interval2 = timeCreate+61;
    if(!(timeMod>interval1&&timeMod<interval2)) {
        self.databaseCreated=YES;
    } else {
        self.databaseCreated=NO;
    }
    self.upgradePurchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"RPBUpgradeBought"];
    self.alreadyChecked=[[NSUserDefaults standardUserDefaults] boolForKey:@"RPBAlreadyChecked"];
    self.upgradeEligible = [[NSUserDefaults standardUserDefaults] boolForKey:@"RPBUpgradeEligible"];
    if(!alreadyChecked) {
        self.alreadyChecked=YES;
        [[NSUserDefaults standardUserDefaults] setBool:self.alreadyChecked forKey:@"RPBAlreadyChecked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(databaseCreated) {
            self.upgradeEligible=YES;
            [[NSUserDefaults standardUserDefaults] setBool:self.upgradeEligible forKey:@"RPBUpgradeEligible"];
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"RPBFreeUpgradeNotice"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"For Paid Users" message:@"If you are reading this then you bought RetroPaddleBall when it was a paid app. RetroPaddleBall is now a free app with ads in it. Since you bought the app when it was a paid app, you are eligible to remove the ads for free. Just go to Settings, and tap the button labeled \"Remove Ads\" (Don't worry! Even the button label says free).\n\n If you are recieving this message and have already have done this, then tap \"Restore Purchases\" to get your ads removed." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RPBFreeUpgradeNotice"];
            }
        }
    }
}
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = [response products];
    int i=0;
    for (SKProduct *indProduct in products) {
        if([indProduct.productIdentifier isEqualToString:@"com.lukecotton.retropaddleball.disableadsfree"]) {
            removeAdsFreeProduct = [products objectAtIndex:i];
            [removeAdsFreeProduct retain];
            NSLog(@"%@", removeAdsFreeProduct.productIdentifier);
        } else if ([indProduct.productIdentifier isEqualToString:@"com.lukecotton.retropaddleball.disableads"]){
            removeAdsProduct = [products objectAtIndex:i];
            [removeAdsProduct retain];
            NSLog(@"%@", removeAdsProduct.productIdentifier);
        }
        i++;
    }
    [productsRequest release];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (int i=0; i<[transactions count]; i++) {
        SKPaymentTransaction *paymentTransaction = [transactions objectAtIndex:i];
        switch (paymentTransaction.transactionState) {
            case SKPaymentTransactionStatePurchased: {
                [[NSUserDefaults standardUserDefaults] setValue:paymentTransaction.transactionReceipt forKey:@"RPBUpgradedProduct"];
                self.upgradePurchased=YES;
                [[NSUserDefaults standardUserDefaults] setBool:self.upgradePurchased forKey:@"RPBUpgradeBought"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [viewController hideAds];
                if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] upgradePurchased]) {
                    [settingsController.purchaseLabel setHidden:YES];
                    [settingsController.purchaseButton setHidden:YES];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
                break;
            }
            case SKPaymentTransactionStateRestored: {
                [[NSUserDefaults standardUserDefaults] setValue:paymentTransaction.originalTransaction.transactionReceipt forKey:@"RPBUpgradedProduct"];
                self.upgradePurchased=YES;
                [[NSUserDefaults standardUserDefaults] setBool:self.upgradePurchased forKey:@"RPBUpgradeBought"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if ([[CoreGraphicsDrawingAppDelegate sharedAppDelegate] upgradePurchased]) {
                    [settingsController.purchaseLabel setHidden:YES];
                    [settingsController.purchaseButton setHidden:YES];
                }
                [viewController hideAds];
                [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
            }
            case SKPaymentTransactionStateFailed: {
                NSLog(@"Payment Transaction Failed!");
                [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
                break;
            }
            default:
                break;
        }
    }
}
+ (id)sharedAppDelegate
{
	return [[UIApplication sharedApplication] delegate];
}
-(void)queryDidFinishGathering:(NSNotification *)notification
{
    NSMetadataQuery *query2 = [notification object];
    [query2 disableUpdates];
    [query2 stopQuery];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query2];
    query=nil;
    [self loadData:query2];
}
-(void)restorePurchases {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
-(void)loadData:(NSMetadataQuery *)query2 {
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    if ([query2 resultCount]==1) {
        NSMetadataItem *item = [query2 resultAtIndex:0];
        NSURL *url = [[[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:@"highscoredatabase.db"];
        HighScoreDocument *doc = [[HighScoreDocument alloc] initWithFileURL:url];
        self.highScoreDoc = doc;
        [self.highScoreDoc openWithCompletionHandler:^(BOOL success){
            if (success) {
                self.highScores=self.highScoreDoc.arrayContents;
                RPBLOG(@"iCloud Access To Document");
                /*if ([self.highScores count]<11) {
                    [self.highScores addObject:[NSNumber numberWithBool:YES]];
                }*/
                [self saveHighScores];
                isDone=YES;
            } else {
                RPBLOG(@"Failed!");
                isDone=YES;
            }
         }];
    } else {
        self.highScores = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]]];
        if(highScores==nil) {
            self.highScores = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]]]]];
            if (highScores==nil||[highScores count]==0) {
                highScores = [NSMutableArray array];
                int i;
                for (i=0; i<10; i++) {
                    //self.databaseCreated=YES;
                    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:0], @"RPBScore", @" ", @"RPBName", nil];
                    [highScores addObject:dictionary];
                    [dictionary release];
                }
                //[[NSUbiquitousKeyValueStore defaultStore] setString:@"NO" forKey:@"RPBUpgradeEligible"];
                [self saveHighScores];
                [highScores retain];
            } else {
            }
        } else {
            if (self.upgradeEligible) {
            }
        }
        NSURL *ubiqPackage = [[[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:@"highscoredatabase.db"];
        self.highScoreDoc = [[HighScoreDocument alloc] initWithFileURL:ubiqPackage];
        self.highScoreDoc.arrayContents=self.highScores;
        [self.highScoreDoc saveToURL:[self.highScoreDoc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [self.highScoreDoc openWithCompletionHandler:^(BOOL success) {
                RPBLOG(@"iCloud Access To Document");
                self.highScores=self.highScoreDoc.arrayContents;
                }];
                if (self.upgradeEligible==NO) {
                    [[NSUbiquitousKeyValueStore defaultStore] setString:@"NO" forKey:@"RPBUpgradeEligible"];
                } else {
                    [[NSUbiquitousKeyValueStore defaultStore] setString:@"YES" forKey:@"RPBUpgradeEligible"];
                }
            }
        }];
        isDone=YES;
    }
    isDone=YES;
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}
- (NSString *)getPathToSave
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //RPBLOG(@"No iCloud access");
    return documentsDirectory;
}
-(void)saveHighScores
{
    if (icloudEnabled==YES) {
        //NSURL *ubiqPackage = [[[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:@"highscoredatabase.db"];
        self.highScoreDoc.arrayContents=self.highScores;
        //self.highScoreDoc = [[HighScoreDocument alloc] initWithFileURL:ubiqPackage];
        [self.highScoreDoc saveToURL:[self.highScoreDoc fileURL] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        }];
    } else {
        NSData *arrayData=[NSKeyedArchiver archivedDataWithRootObject:highScores];
        [arrayData writeToFile:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]] atomically:YES];
    }
	//[highScores writeToFile:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]] atomically:YES];
    //NSError *error;
    //[[NSFileManager defaultManager] setUbiquitous:NO itemAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]]] destinationURL:[[ubiq URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:@"highscoredatabase.db"] error:&error];
    //BOOL worked = [[NSFileManager defaultManager] setUbiquitous:YES itemAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]]] destinationURL:[[ubiq URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:@"highscoredatabase.db"] error:&error];
    //RPBLOG(@"iCloud worked: %d %@", worked, error);
}
-(void)playGame:(id)sender
{
    //NSString *deviceName = [[UIDevice currentDevice] model];
    CoreGraphicsDrawingViewController *aGameController;
    aGameController = [[CoreGraphicsDrawingViewController alloc] initWithNibName:@"CoreGraphicsDrawingViewController" bundle:[NSBundle mainBundle]];
	self.gameController = aGameController;
	[currentViewController presentViewController:gameController animated:YES completion:NULL];
	[aGameController release];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:currentViewController.view cache:YES];
	[currentViewController.view removeFromSuperview];
	[self.window addSubview:[gameController view]];	
	[UIView commitAnimations];
    //[currentViewController release];
	currentViewController = gameController;
}
-(void)showMainMenu
{
	MainMenuViewController *aMainMenu = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:[NSBundle mainBundle]];
	self.viewController = aMainMenu;
	[currentViewController presentViewController:viewController animated:YES completion:NULL];
	[aMainMenu release];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:currentViewController.view cache:YES];
	[currentViewController.view removeFromSuperview];
	[self.window addSubview:[viewController view]];
	[UIView commitAnimations];
    //[currentViewController release];
	currentViewController = viewController;
}
-(void)showSettings
{
	
	SettingsViewController *aSettings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:[NSBundle mainBundle]];
	self.settingsController = aSettings;
	[currentViewController presentViewController:settingsController animated:YES completion:NULL];
	[aSettings release];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:currentViewController.view cache:YES];
	[currentViewController.view removeFromSuperview];
	[self.window addSubview:[settingsController view]];
	[UIView commitAnimations];
    //[currentViewController release];
	currentViewController = settingsController;
}
-(void)showHighScores
{
	
	HighScoreViewController *aHighScores = [[HighScoreViewController alloc] initWithNibName:@"HighScoreViewController" bundle:[NSBundle mainBundle]];
	self.highScoreController = aHighScores;
	[currentViewController presentViewController:highScoreController animated:YES completion:NULL];
	[aHighScores release];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:currentViewController.view cache:YES];
	[currentViewController.view removeFromSuperview];
	[self.window addSubview:[highScoreController view]];
	[UIView commitAnimations];
    //[currentViewController release];
	currentViewController = highScoreController;
    
}
-(void)showHowToPlay
{
    HowToPlayViewController *aHowToPlay = [[HowToPlayViewController alloc] initWithNibName:@"HowToPlayViewController" bundle:[NSBundle mainBundle]];
	self.howToPlayController = aHowToPlay;
	[currentViewController presentViewController:howToPlayController animated:YES completion:NULL];
	[aHowToPlay release];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:currentViewController.view cache:YES];
	[currentViewController.view removeFromSuperview];
	[self.window addSubview:[howToPlayController view]];
	[UIView commitAnimations];
    //[currentViewController release];
	currentViewController = howToPlayController;
}
-(void)endGame
{
	[gameController lostGame];
	GameOverViewController *aGameOver = [[GameOverViewController alloc] initWithNibName:@"GameOverViewController" bundle:[NSBundle mainBundle]];
	self.gameOverController = aGameOver;
	gameOverController.score = self.score;
	[gameController presentViewController:gameOverController animated:YES completion:NULL];
	[aGameOver release];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:gameController.view cache:YES];
	[gameController.view removeFromSuperview];
	[self.window addSubview:[gameOverController view]];
	[UIView commitAnimations];
	[gameOverController updateScore];
    //[currentViewController release];
	currentViewController = gameOverController;
	
}
/*- (void)acceleratedInX:(float)xx Y:(float)yy Z:(float)zz
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"RPBAccelerometerEnabled"]== NO)
    {
        return;
    }
    //RPBLOG(@"Accelerometer Event Called!");
    float velocityX = xx;
    float velocityY = -yy;
    CGRect tempRect;
    tempRect.origin.x=(tempRect.origin.x+velocityX)-30;
    tempRect.origin.y=(tempRect.origin.y+velocityY)-30;
    tempRect.size=CGSizeMake(60, 60);
    CGPoint paddleImagePointTemp = gameController.paddleImage.center;
    if ((CGRectIntersectsRect(tempRect, gameController.topOfScreen) && CGRectIntersectsRect(tempRect, gameController.leftOfScreen))|| (CGRectIntersectsRect(tempRect, gameController.topOfScreen) && CGRectIntersectsRect(tempRect, gameController.rightOfScreen))) {
        return;
    } else if ((CGRectIntersectsRect(tempRect, gameController.bottomOfScreen) && CGRectIntersectsRect(tempRect, gameController.leftOfScreen))|| (CGRectIntersectsRect(tempRect, gameController.bottomOfScreen) && CGRectIntersectsRect(tempRect, gameController.rightOfScreen))) {
        return;
    } else if (CGRectIntersectsRect(tempRect, gameController.topOfScreen) || CGRectIntersectsRect(tempRect, gameController.bottomOfScreen)) {
        paddleImagePointTemp.x += velocityX;
    } else if (CGRectIntersectsRect(tempRect, gameController.leftOfScreen) || CGRectIntersectsRect(tempRect, gameController.rightOfScreen)){
        paddleImagePointTemp.y += velocityY;
    } else {
        paddleImagePointTemp = CGPointMake(paddleImagePointTemp.x+velocityX, paddleImagePointTemp.y+velocityY);
    }
    if(gameController.lastTimeUpdate > 0)
    {
        gameController.paddleImage.center = paddleImagePointTemp;
    }
    //lastTimeUpdate = acceleration.timestamp;
}*/
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	if (gameController.isPaused == 1) {
		return;
	}
	[gameController pauseGame:nil];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    [currentViewController retain];
    [viewController release];
    [gameController release];
    [gameOverController release];
    [howToPlayController release];
    [settingsController release];
    [highScoreController release];
    if (highScoreController != currentViewController) {
        highScoreController = nil;
    }
    if (viewController != currentViewController) {
        viewController = nil;
    }
    if (gameController != currentViewController) {
        gameController = nil;
    }
    if (gameOverController != currentViewController) {
        gameOverController = nil;
    }
    if (settingsController != currentViewController) {
        settingsController = nil;
    }
    if (howToPlayController != currentViewController) {
        howToPlayController = nil;
    }
}
-(void)appSupportTimerCall:(NSTimer *)theTimer
{
    if (highScoresEnabled == NO) {
        highScoresEnabled = YES;
        return;
    }
    [theTimer invalidate];
    [theTimer release];
    char char1=0x50, char2=0x69, char3=0x72, char4=0x61, char5=0x63, char6=0x79, char7=0x20, char8=0x44, char9=0x65, char10=0x74, char11=0x65, char12=0x63, char13=0x74, char14=0x65, char15=0x64, char16=0x21, char17=0x00;
    char charA[17]={char1, char2, char3, char4, char5, char6, char7, char8, char9, char10, char11, char12, char13, char14, char15, char16, char17};
    char charA2[166]={0x54, 0x68, 0x69, 0x73, 0x20, 0x41, 0x70, 0x70, 0x20, 0x68, 0x61, 0x73, 0x20, 0x62, 0x65, 0x65, 0x6e,0x20,0x64,0x65,0x74,0x65,0x63,0x74,0x65,0x64,0x20,0x74,0x6f,0x20,0x68,0x61,0x76,0x65,0x20,0x62,0x65,0x65,0x6e,0x20,0x70,0x69,0x72,0x61,0x74,0x65,0x64,0x2c,0x20,0x62,0x65,0x63,0x61,0x75,0x73,0x65,0x20,0x69,0x74,0x20,0x68,0x61,0x73,0x20,0x62,0x65,0x65,0x6e,0x2c,0x20,0x69,0x74,0x20,0x77,0x69,0x6c,0x6c,0x20,0x6e,0x6f,0x77,0x20,0x73,0x68,0x75,0x74,0x20,0x64,0x6f,0x77,0x6e,0x2e,0x20,0x49,0x66,0x20,0x79,0x6f,0x75,0x20,0x6c,0x69,0x6b,0x65,0x20,0x74,0x68,0x65,0x20,0x61,0x70,0x70,0x2c,0x20,0x70,0x6c,0x65,0x61,0x73,0x65,0x20,0x70,0x75,0x72,0x63,0x68,0x61,0x73,0x65,0x20,0x74,0x68,0x65,0x20,0x61,0x70,0x70,0x20,0x6f,0x6e,0x20,0x74,0x68,0x65,0x20,0x41,0x70,0x70,0x20,0x53,0x74,0x6f,0x72,0x65,0x2e,0x20,0x54,0x68,0x61,0x6e,0x6b,0x20,0x79,0x6f,0x75,char17};
    char charA3[3]={0x4f, 0x4b, 0x00};
    NSString *charS= [[NSString alloc] initWithCString:charA encoding:NSASCIIStringEncoding];
    NSString *charS2= [[NSString alloc] initWithCString:charA2 encoding:NSASCIIStringEncoding];
    NSString *charS3= [[NSString alloc] initWithCString:charA3 encoding:NSASCIIStringEncoding];
    UIAlertView *appSupport= [[UIAlertView alloc] initWithTitle:charS message:charS2 delegate:self cancelButtonTitle:charS3 otherButtonTitles:nil];
    [appSupport show];
    [appSupport release];
    [charS2 release];
    [charS3 release];
    [charS release];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //RPBLOG(@"Showing Message");
    if([alertView.title isEqualToString:@"For Paid Users"]) {
        return;
    }
    Class class=[UIApplication class];
    char char1 = 0x00;
    char charA[18]={0x73,0x68,0x61,0x72,0x65,0x64,0x41,0x70,0x70,0x6c,0x69,0x63,0x61,0x74,0x69,0x6f,0x6e,char1};
    char charA2[10]={0x74,0x65,0x72,0x6d,0x69,0x6e,0x61,0x74,0x65,char1};
    NSString *charS=[[[NSString alloc] initWithCString:charA encoding:NSASCIIStringEncoding] autorelease];
    NSString *charS2=[[[NSString alloc] initWithCString:charA2 encoding:NSASCIIStringEncoding]autorelease];
    objc_msgSend(objc_msgSend(class, NSSelectorFromString(charS)), NSSelectorFromString(charS2));
    /*NSString *charS = [[NSString alloc] initWithString:@""];
    [charS release];
    [charS release];
    [charS dealloc];*/
}
- (void)dealloc {
    [viewController release];
	[gameController release];
	[gameOverController release];
	[settingsController release];
    [howToPlayController release];
    [highScoreController release];
	[highScores release];
    [window release];
    [super dealloc];
}


@end
