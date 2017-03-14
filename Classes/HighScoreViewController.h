//
//  HighScoreViewController.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 4/23/11.
//  Copyright 2011  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighScoreViewController : UIViewController <UIAlertViewDelegate> {
	NSMutableArray *highScores;
}
-(IBAction)resetHighScores:(id)sender;
-(void)loadHighScores;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *nameFields;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *scoreFields;
@property (nonatomic, strong) NSMutableArray *highScores;
@end
