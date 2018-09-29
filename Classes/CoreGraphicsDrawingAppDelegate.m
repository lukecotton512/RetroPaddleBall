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
#import "HighScoreDocument.h"
#import "TutorialViewController.h"
#import "RPBUsefulFunctions.h"
@implementation CoreGraphicsDrawingAppDelegate

@synthesize window;
@synthesize userDefaults, defaults, score, highScores, difficultyMultiplier, highScoresEnabled, soundIsOn, ubiq, icloudEnabled, query, highScoreDoc, isDone, isOniPad, databaseCreated, alreadyChecked, currentTutorialController;


#pragma mark -
#pragma mark Application lifecycle
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // URL for iCloud container.
    ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    //load high scores and iCloud.
    if (ubiq) {
        // Start a query search the proper way for our high score database.
        icloudEnabled=YES;
        query = [[NSMetadataQuery alloc] init];
        query.searchScopes = @[NSMetadataQueryUbiquitousDocumentsScope];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", NSMetadataItemFSNameKey, @"highscoredatabase.db"];
        query.predicate = pred;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDidFinishGathering:) name:NSMetadataQueryDidFinishGatheringNotification object:query];
        [query startQuery];
    } else {
        // Load high scores from normal place, and create them if they don't exist.
        self.highScores = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]]];
        if(highScores==nil) {
            self.highScores = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]]]]];
            if (highScores==nil||highScores.count==0) {
                highScores = [NSMutableArray array];
                int i;
                for (i=0; i<10; i++) {
                    NSDictionary *dictionary = @{@"RPBScore": @0, @"RPBName": @" "};
                    [highScores addObject:dictionary];
                }
                [self saveHighScores];
            }
        }
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.databaseCreated=NO;
    highScoresEnabled=NO;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        isOniPad=YES;
    } else {
        isOniPad=NO;
    }
    // Setup audio settings and hide status bar on older verisons of iOS.
    if (@available(iOS 11.0, *)) {
        if (self.window.safeAreaInsets.top > 0.0f && !UIEdgeInsetsEqualToEdgeInsets(self.window.safeAreaInsets, UIEdgeInsetsZero)) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        } else {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        }
    } else {
        // We are certainly not on the iPhone X.
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error:nil];
    self.alreadyChecked=NO;
    [self.window makeKeyAndVisible];
    
    // Set the default preferences if they have never been set before and register our keys with the OS.
	userDefaults = [NSUserDefaults standardUserDefaults];
    defaults = @{@"RPBRedColorPaddle": @0.0f, @"RPBGreenColorPaddle": @255.0f, @"RPBBlueColorPaddle": @0.0f, @"RPBRedColorBall": @255.0f, @"RPBGreenColorBall": @0.0f, @"RPBBlueColorBall": @0.0f, @"RPBDifficultyMultiplier": @0.0, @"RPBAccelerometerEnabled": @NO, @"RPBSound": @YES, @"RPBAlreadyChecked": @NO, @"RPBDatabaseCreated": @NO, @"RPBUpgradeEligible": @NO, @"RPBUpgradeBought": @NO, @"RPBFreeUpgradeNotice": @NO};
    [userDefaults registerDefaults:defaults];
    [userDefaults synchronize];
    
    return YES;
}
// Return our app delegate.
+ (CoreGraphicsDrawingAppDelegate*)sharedAppDelegate
{
	return (CoreGraphicsDrawingAppDelegate *)[UIApplication sharedApplication].delegate;
}
// Called once we are done finding the high score database.
-(void)queryDidFinishGathering:(NSNotification *)notification
{
    // Get the query object and stop it. Also, load the data in.
    NSMetadataQuery *query2 = notification.object;
    [query2 disableUpdates];
    [query2 stopQuery];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query2];
    query=nil;
    [self loadData:query2];
}

// Loads the data from disk.
-(void)loadData:(NSMetadataQuery *)query2 {
    // We have a file.
    if (query2.resultCount==1) {
        // Get the URL and load it in.
        NSMetadataItem *item = [query2 resultAtIndex:0];
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        HighScoreDocument *doc = [[HighScoreDocument alloc] initWithFileURL:url];
        self.highScoreDoc = doc;
        [self.highScoreDoc openWithCompletionHandler:^(BOOL success){
            if (success) {
                // We are successful, so load in the array contents into the delegate.
                self.highScores=self.highScoreDoc.arrayContents;
                RPBLog(@"iCloud Access To Document");
                [self saveHighScores];
                isDone=YES;
            } else {
                RPBLog(@"Failed!");
                isDone=YES;
            }
         }];
    } else {
        // Try load in a non-iCloud file in the new format.
        self.highScores = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]]];
        if(highScores==nil) {
            // If we can't, load in the old format in the non-iCloud container and also load it in.
            self.highScores = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]]]]];
            // If we still have nothing, then create a new file.
            if (highScores==nil||highScores.count==0) {
                highScores = [NSMutableArray array];
                int i;
                for (i=0; i<10; i++) {
                    NSDictionary *dictionary = @{@"RPBScore": @0, @"RPBName": @" "};
                    [highScores addObject:dictionary];
                }
                [self saveHighScores];
            }
        }
        // Now, save the file to the document container.
        NSURL *ubiqPackage = [[[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:@"highscoredatabase.db"];
        self.highScoreDoc = [[HighScoreDocument alloc] initWithFileURL:ubiqPackage];
        self.highScoreDoc.arrayContents=self.highScores;
        [self.highScoreDoc saveToURL:(self.highScoreDoc).fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [self.highScoreDoc openWithCompletionHandler:^(BOOL success) {
                RPBLog(@"iCloud Access To Document");
                self.highScores=self.highScoreDoc.arrayContents;
                }];
            }
        }];
        isDone=YES;
    }
    isDone=YES;
}
// Get the non-iCloud save directory.
- (NSString *)getPathToSave
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    return documentsDirectory;
}
// Save the high scores to the appropriate container.
-(void)saveHighScores
{
    // Save to iCloud container.
    if (icloudEnabled==YES) {
        self.highScoreDoc.arrayContents=self.highScores;
        [self.highScoreDoc saveToURL:(self.highScoreDoc).fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        }];
    } else {
        // Save to non-iCloud container.
        NSData *arrayData=[NSKeyedArchiver archivedDataWithRootObject:highScores];
        [arrayData writeToFile:[NSString stringWithFormat:@"%@/highscoredatabase.db", [self getPathToSave]] atomically:YES];
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    // If we are bigger than 6, then we have hit the end, so return nil.
    if ((currentTutorialController+1)>6) {
        return nil;
    }
    // Get the identifier based off the current view controller index.
    NSString *viewIdentifier = [NSString stringWithFormat:@"tutorial%i", (currentTutorialController+1), nil];
    // Get the correct storyboard and load the correct view controller in.
    UIStoryboard *storyboard;
    if (self.isOniPad) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPhone" bundle:nil];
    }
    return [storyboard instantiateViewControllerWithIdentifier:viewIdentifier];
    
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    // If we are less than 0, then we have hit the end, so return nil.
    if ((currentTutorialController-1)<0) {
        return nil;
    }
    // Get the correct view controller.
    NSString *viewIdentifier = [NSString stringWithFormat:@"tutorial%i", (currentTutorialController-1), nil];
    // Load it in from the storyboard.
    UIStoryboard *storyboard;
    if (self.isOniPad) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboardiPhone" bundle:nil];
    }
    return [storyboard instantiateViewControllerWithIdentifier:viewIdentifier];
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // We have a total of 7 view controllers, 0-6.
    return 7;
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // Return the index of the current view controller.
    return currentTutorialController;
}
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    // We have fully completed the transition.
    if (completed==YES&&pageViewController.viewControllers[0]!=nil) {
        // We are going forward, so increment the current index.
        if(((TutorialViewController *)pageViewController.viewControllers[0]).view.tag>((TutorialViewController *)previousViewControllers[0]).view.tag) {
            currentTutorialController++;
        } else if  (((TutorialViewController *)pageViewController.viewControllers[0]).view.tag<((TutorialViewController *)previousViewControllers[0]).view.tag) {
            // We are going back, so deincrement the current index.
            currentTutorialController--;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    // Pause the game if the view controller is our drawing view controller
    UINavigationController *naviController = (UINavigationController *) self.window.rootViewController;
    if ([naviController.topViewController isKindOfClass:[CoreGraphicsDrawingViewController class]]) {
        CoreGraphicsDrawingViewController *drawingController = (CoreGraphicsDrawingViewController *) naviController.topViewController;
        [drawingController pauseGame:self];
    }
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
}


@end
