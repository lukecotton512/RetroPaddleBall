//
//  CoreGraphicsDrawingAppDelegate.h
//  CoreGraphicsDrawing
//
//  Created by Luke Cotton on 2/5/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreGraphicsDrawingViewController.h"
@class MainMenuViewController;
@class GameOverViewController;
@class SettingsViewController;
@class HighScoreViewController;
@class HighScoreDocument;
@interface CoreGraphicsDrawingAppDelegate : NSObject <UIApplicationDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    UIWindow *window;
	NSUserDefaults *userDefaults;
	NSDictionary *defaults;
	NSMutableArray *highScores;
    NSURL *ubiq;
    NSMetadataQuery *query;
    HighScoreDocument *highScoreDoc;
    BOOL icloudEnabled;
    BOOL databaseCreated;
    int currentTutorialController;
	int score;
    BOOL highScoresEnabled;
    BOOL alreadyChecked;
    BOOL soundIsOn;
	double difficultyMultiplier;
    BOOL isDone;
    BOOL isOniPad;
}
+(CoreGraphicsDrawingAppDelegate*)sharedAppDelegate;
@property (nonatomic, getter=getPathToSave, readonly, copy) NSString *pathToSave;
-(void)saveHighScores;
-(void)loadData:(NSMetadataQuery *)query2;
-(void)queryDidFinishGathering:(NSNotification *)notification;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) HighScoreDocument *highScoreDoc;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int currentTutorialController;
@property (nonatomic, assign) BOOL soundIsOn;
@property (nonatomic, assign) BOOL highScoresEnabled;
@property (nonatomic, assign) BOOL isDone;
@property (nonatomic, assign) BOOL alreadyChecked;
@property (nonatomic, assign) double difficultyMultiplier;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSDictionary *defaults;
@property (nonatomic, strong) NSMutableArray *highScores;
@property (nonatomic, strong) NSURL *ubiq;
@property (nonatomic, assign) BOOL icloudEnabled;
@property (nonatomic, strong) NSMetadataQuery *query;
@property (nonatomic, assign) BOOL isOniPad;
@property (nonatomic, assign) BOOL databaseCreated;
@end

