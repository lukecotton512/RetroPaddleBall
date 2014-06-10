//
//  TutorialViewController.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 12/19/13.
//
//

#import <UIKit/UIKit.h>
@interface TutorialViewController : UIViewController {
}
-(IBAction)goBack:(UIStoryboardSegue *)unwindSegue;
@property (nonatomic, strong) IBOutlet UIView *ballView2;
@property (nonatomic, strong) IBOutlet UIView *paddleView2;
@property (nonatomic, strong) IBOutlet UIView *topOfScreen;
@property (nonatomic, strong) NSTimer *viewTimer;
@property (nonatomic, assign) int stageNumber;
-(void)animateView2:(NSTimer *)theTimer;
-(void)animateView3:(NSTimer *)theTimer;
@end
