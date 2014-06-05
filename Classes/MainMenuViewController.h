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
-(IBAction)goToBeginning:(UIStoryboardSegue *)unwindSegue;
-(void)hideAds;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet ADBannerView *bannerAd;
@end
