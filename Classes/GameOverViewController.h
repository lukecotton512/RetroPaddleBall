//
//  GameOverViewController.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 2/16/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameOverViewController : UIViewController <UIAlertViewDelegate> {
	IBOutlet UILabel *scoreTextView;
	IBOutlet UITextField *highScoreAlertField;
	NSMutableArray *highScores;
	int score;
	//int i;
}
@property (nonatomic, strong) IBOutlet UILabel *scoreTextView;
@property (nonatomic, strong) UITextField *highScoreAlertField;
@property (nonatomic, assign) int score;
//@property (nonatomic, assign) int i;
@property (nonatomic, strong) NSMutableArray *highScores;
-(void)updateScore;
-(IBAction)playAgain:(id)sender;
@end
