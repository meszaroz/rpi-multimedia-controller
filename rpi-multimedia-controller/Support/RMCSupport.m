//
//  RMCSupport.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCSupport.h"

@implementation RMCConstants

+ (CGFloat)collectionCellDistance {
    return 6.0;
}

+ (CGFloat)maximalScreenDimension {
    CGSize tmp = [UIScreen mainScreen].bounds.size;
    return MAX(tmp.height,tmp.width);
}

+ (CGFloat)minimalScreenDimension {
    CGSize tmp = [UIScreen mainScreen].bounds.size;
    return MIN(tmp.height,tmp.width);
}

+ (CGSize)collectionCellSize {
    static CGSize size = { 0, 0 };
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        const CGSize cellDefaultSize = CGSizeMake(75.0, 100.0);
        const CGFloat cellDistance = RMCConstants.collectionCellDistance;
        const CGFloat cellAspect   = 1;
        const CGFloat screenWidth  = [self sizeForOrientation:UIInterfaceOrientationPortrait].width;
        const CGFloat cellWidthWithDistance = cellDefaultSize.width + cellDistance;
        const CGFloat adjustedScreenWidth   = screenWidth - cellDistance;
        
        NSUInteger cellCount = (NSUInteger)(adjustedScreenWidth / cellWidthWithDistance);
        CGFloat overallCellWidth  = cellCount * cellWidthWithDistance;
        CGFloat adjustedCellWidth = cellDefaultSize.width + (CGFloat)((adjustedScreenWidth - overallCellWidth) / (CGFloat)cellCount);
        
        size = CGSizeMake(adjustedCellWidth, adjustedCellWidth / cellAspect);
    });
    return size;
}

+ (CGSize)sizeForOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsLandscape(orientation) ?
        CGSizeMake(RMCConstants.maximalScreenDimension, RMCConstants.maximalScreenDimension) :
        CGSizeMake(RMCConstants.minimalScreenDimension, RMCConstants.maximalScreenDimension);
}


@end

@implementation RMCSupport

+ (void)showWarning:(NSString*)message inViewController:(UIViewController*)vc {
    if (message && vc) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Warning" message:message preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [vc presentViewController:controller animated:YES completion:nil];
    }
}

@end
