//
//  GameOverViewController.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 2/16/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface GameOverViewController : UIViewController <UIAlertViewDelegate, ADBannerViewDelegate> {
    IBOutlet ADBannerView *bannerView;
	IBOutlet UILabel *scoreTextView;
	IBOutlet UITextField *highScoreAlertField;
	NSMutableArray *highScores;
	int score;
	//int i;
}
@property (nonatomic, strong) IBOutlet UILabel *scoreTextView;
@property (nonatomic, strong) UITextField *highScoreAlertField;
@property (nonatomic, assign) int score;
@property (nonatomic, strong) IBOutlet ADBannerView *bannerView;
//@property (nonatomic, assign) int i;
@property (nonatomic, strong) NSMutableArray *highScores;
-(void)updateScore;
-(IBAction)playAgain:(id)sender;
@end
