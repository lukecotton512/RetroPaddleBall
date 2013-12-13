//
//  MainMenuViewController.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 2/11/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "CoreGraphicsDrawingViewController.h"
//#import "CoreGraphicsDrawingAppDelegate.h"
@interface MainMenuViewController : UIViewController {
	//CoreGraphicsDrawingViewController *gameController;
	IBOutlet UIWindow *window;
    IBOutlet ADBannerView *bannerAd;
}
-(IBAction)playGame:(id)sender;
-(IBAction)showSettings:(id)sender;
-(IBAction)showHighScores:(id)sender;
-(IBAction)showHowToPlay:(id)sender;
-(void)hideAds;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ADBannerView *bannerAd;
@end
