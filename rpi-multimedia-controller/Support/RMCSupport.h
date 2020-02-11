//
//  RMCSupport.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMCConstants : NSObject

@property (class, readonly) CGFloat maximalScreenDimension;
@property (class, readonly) CGFloat minimalScreenDimension;

@property (class, readonly) CGSize  collectionCellSize;
@property (class, readonly) CGFloat collectionCellDistance;

+ (CGSize)sizeForOrientation:(UIInterfaceOrientation)orientation;

@end

@interface RMCSupport : NSObject

+ (void)showWarning:(NSString*)message inViewController:(UIViewController*)vc;

@end
