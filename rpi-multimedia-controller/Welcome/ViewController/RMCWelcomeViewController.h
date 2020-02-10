//
//  RMCWelcomeViewController.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/* server selector view */
@class RMCWelcomeInputView;

@interface RMCWelcomeServerSelectorView : UIView

@property (strong, nonatomic) IBOutlet RMCWelcomeInputView *serverInput;
@property (strong, nonatomic) IBOutlet RMCWelcomeInputView *portInput;

@end

/* welcome view controller */
@class MZActivityIndicatorOverlayView;

@interface RMCWelcomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton                       *startButton;
@property (strong, nonatomic) IBOutlet MZActivityIndicatorOverlayView *activityView;
@property (strong, nonatomic) IBOutlet RMCWelcomeServerSelectorView   *serverSelectorView;

@end

NS_ASSUME_NONNULL_END
