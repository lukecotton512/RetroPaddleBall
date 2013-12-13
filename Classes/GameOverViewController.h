//
//  GameOverViewController.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 2/16/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface GameOverViewController : UIViewController <UIAlertViewDelegate> {
    IBOutlet ADBannerView *bannerView;
	IBOutlet UILabel *scoreTextView;
	IBOutlet UITextField *highScoreAlertField;
	NSMutableArray *highScores;
	int score;
	//int i;
}
@property (nonatomic, retain) IBOutlet UILabel *scoreTextView;
@property (nonatomic, retain) IBOutlet UITextField *highScoreAlertField;
@property (nonatomic, assign) int score;
@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;
//@property (nonatomic, assign) int i;
@property (nonatomic, retain) NSMutableArray *highScores;
-(IBAction)playAgain:(id)sender;
-(IBAction)showMainMenu:(id)sender;
-(void)updateScore;
-(IBAction)showHighScores:(id)sender;
@end
