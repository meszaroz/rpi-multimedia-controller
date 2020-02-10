//
//  RMCCollectionViewController.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RMCCommunicationHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMCCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel     *title;

@end

@class RMCCollection;

@interface RMCCollectionViewController : UICollectionViewController

@property (strong, nonatomic, readonly) RMCCollection *collection;

@end

NS_ASSUME_NONNULL_END
