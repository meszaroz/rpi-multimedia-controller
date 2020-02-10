//
//  MZActivityIndicatorOverlayView.h
//  qboard
//
//  Created by Zoltan Meszaros on 2017. 06. 21..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZActivityIndicatorOverlayView : UIView
@end

@interface MZActivityIndicatorOverlayView (Convenience)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(void(^)(void))cmpl;

@end
