//
//  HighScoreViewController.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 4/23/11.
//  Copyright 2011  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighScoreViewController : UIViewController <UIAlertViewDelegate> {
	IBOutlet UILabel *name1;
	IBOutlet UILabel *name2;
	IBOutlet UILabel *name3;
	IBOutlet UILabel *name4;
	IBOutlet UILabel *name5;
	IBOutlet UILabel *name6;
	IBOutlet UILabel *name7;
	IBOutlet UILabel *name8;
	IBOutlet UILabel *name9;
	IBOutlet UILabel *name10;
	IBOutlet UILabel *score1;
	IBOutlet UILabel *score2;
	IBOutlet UILabel *score3;
	IBOutlet UILabel *score4;
	IBOutlet UILabel *score5;
	IBOutlet UILabel *score6;
	IBOutlet UILabel *score7;
	IBOutlet UILabel *score8;
	IBOutlet UILabel *score9;
	IBOutlet UILabel *score10;
	NSMutableArray *highScores;
}
-(IBAction)showMainMenu:(id)sender;
-(IBAction)resetHighScores:(id)sender;
-(void)loadHighScores;
@property (nonatomic, retain) IBOutlet UILabel *name1;
@property (nonatomic, retain) IBOutlet UILabel *name2;
@property (nonatomic, retain) IBOutlet UILabel *name3;
@property (nonatomic, retain) IBOutlet UILabel *name4;
@property (nonatomic, retain) IBOutlet UILabel *name5;
@property (nonatomic, retain) IBOutlet UILabel *name6;
@property (nonatomic, retain) IBOutlet UILabel *name7;
@property (nonatomic, retain) IBOutlet UILabel *name8;
@property (nonatomic, retain) IBOutlet UILabel *name9;
@property (nonatomic, retain) IBOutlet UILabel *name10;
@property (nonatomic, retain) IBOutlet UILabel *score1;
@property (nonatomic, retain) IBOutlet UILabel *score2;
@property (nonatomic, retain) IBOutlet UILabel *score3;
@property (nonatomic, retain) IBOutlet UILabel *score4;
@property (nonatomic, retain) IBOutlet UILabel *score5;
@property (nonatomic, retain) IBOutlet UILabel *score6;
@property (nonatomic, retain) IBOutlet UILabel *score7;
@property (nonatomic, retain) IBOutlet UILabel *score8;
@property (nonatomic, retain) IBOutlet UILabel *score9;
@property (nonatomic, retain) IBOutlet UILabel *score10;
@property (nonatomic, retain) NSMutableArray *highScores;
@end