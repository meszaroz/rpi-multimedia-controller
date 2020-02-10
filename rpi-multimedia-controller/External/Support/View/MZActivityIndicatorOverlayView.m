//
//  MZActivityIndicatorOverlayView.m
//  qboard
//
//  Created by Zoltan Meszaros on 2017. 06. 21..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import "PureLayout.h"
#import "MZActivityIndicatorOverlayView.h"

@implementation MZActivityIndicatorOverlayView {
    UIActivityIndicatorView *_activityView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.hidesWhenStopped = NO;
    [self addSubview:_activityView];
    [_activityView autoCenterInSuperview];
    [_activityView startAnimating];
    
    self.alpha  = 0;
    self.hidden = YES;
}

- (void)dealloc {
    [_activityView stopAnimating];
}

@end

@implementation MZActivityIndicatorOverlayView(Convenience)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(void(^)(void))cmpl {
    if (hidden != self.hidden) {
        if (!hidden) {
            self.alpha  = 0;
            self.hidden = NO;
        }
        
        void(^animationBlock     )(void) = ^{ self.alpha = hidden ? 0 : 1; };
        void(^animationCompletion)(BOOL) = ^(BOOL finished) {
            if (hidden) { self.hidden = YES; }
            if (cmpl  ) { cmpl();            }
        };
        
        if (animated) {
            [UIView animateWithDuration:0.1
                             animations:animationBlock
                             completion:animationCompletion];
        }
        else {
            animationBlock();
            animationCompletion(YES);
        }
        
        [CATransaction flush];
    }
}

@end
