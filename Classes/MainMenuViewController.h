//
//  MainMenuViewController.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 2/11/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreGraphicsDrawingViewController.h"

@interface MainMenuViewController : UIViewController {
	IBOutlet UIWindow *window;
}
-(IBAction)goToBeginning:(UIStoryboardSegue *)unwindSegue;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@end
