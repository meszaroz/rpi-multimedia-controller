//
//  MZKeyboardAutoScrollHandler.h
//
//  Created by Zoltan Meszaros on 4/18/16.
//  Copyright (c) 2016 XL Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZKeyboardAutoScrollHandler : NSObject

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIView       *mainView;
@property (weak, nonatomic) UIView       *targetView;
@property (      nonatomic) CGFloat       defaultContentOffset;

- (void)registerKeyboardNotifications;
- (void)deregisterKeyboardNotifications;
- (void)moveScrollView;

@end

@interface MZKeyboardAutoScrollHandler(Convenience)

- (instancetype)initWithMainView:(UIView*)mainView scrollView:(UIScrollView*)scrollView defaultContentOffset:(CGFloat)contentOffset targetView:(UIView*)targetView;

@end

typedef CGRect(^TargetRectBlock)(MZKeyboardAutoScrollHandler*);

@interface MZKeyboardAutoScrollHandler(Rect)

@property (strong, nonatomic) TargetRectBlock targetRectBlock;

@end

@interface MZKeyboardAutoScrollHandler(ContentOffset)

@property (nonatomic, getter=isStoredContentOffsetDisabled) BOOL storedContentOffsetDisabled;

@end
