//
//  MZKeyboardAutoScrollHandler.m
//
//  Created by Zoltan Meszaros on 4/18/16.
//  Copyright (c) 2016 XL Solutions. All rights reserved.
//

#import "MZKeyboardAutoScrollHandler.h"

typedef NS_ENUM(NSUInteger, MZKeyboardState) {
    MZKeyboardStateNormal     = 0,
    MZKeyboardStateWillShow   = 1,
    MZKeyboardStateWillHide   = 2,
    MZKeyboardStateWillChange = 3,
    MZKeyboardStateIsShown    = 4,
    MZKeyboardStateIsHidden   = 5,
};

static const CGFloat kDefaultDistanceFromKeyboard = 10;

@implementation MZKeyboardAutoScrollHandler {
    BOOL _storedContentOffsetDisabled;
    UIInterfaceOrientation _storedInterfaceOrientation;
    
    CGSize _keyboardSize;
    CGFloat _lastContentOffset;
    MZKeyboardState _keyboardState;
    
    TargetRectBlock _targetRectBlock;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _storedContentOffsetDisabled = NO;
        _storedInterfaceOrientation  = UIInterfaceOrientationUnknown;
        
        _keyboardSize = CGSizeZero;
        _lastContentOffset = 0.0;
        _keyboardState = MZKeyboardStateNormal;
        [self registerKeyboardNotifications];
    }
    return self;
}

- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)deregisterKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidChangeFrameNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification*)notification {
}

- (void)keyboardDidChangeFrame:(NSNotification*)notification {
    //_lastContentOffset = 0.0;
    [self updateKeyboardWithNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardState = MZKeyboardStateWillHide;
}

- (void)keyboardDidHide:(NSNotification *)notification {
    _keyboardState = MZKeyboardStateNormal;
    [self hideKeyboardWithNotification:notification];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    _keyboardState = MZKeyboardStateWillShow;
}

- (void)keyboardDidShow:(NSNotification *)notification {
    _keyboardState = MZKeyboardStateNormal;
    [self updateKeyboardWithNotification:notification];
}

- (void)updateKeyboardWithNotification:(NSNotification*)notification {
    if (_keyboardState == MZKeyboardStateNormal) {
        NSDictionary* info = [notification userInfo];
        _keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        [self moveScrollView];
    }
}

- (void)hideKeyboardWithNotification:(NSNotification*)notification {
    if (_keyboardState == MZKeyboardStateNormal) {
        _keyboardSize = CGSizeZero;
        [self moveScrollView];
    }
}

- (void)moveScrollView {
    if (_scrollView) {
        if (CGSizeEqualToSize(_keyboardSize, CGSizeZero))
            [_scrollView setContentOffset:CGPointMake(0.0, self.storedContentOffsetDisabled ? self.defaultContentOffset : _lastContentOffset)
                                 animated:YES];
        else {
            UIView *mainView = _mainView ?
                _mainView :
                [UIApplication sharedApplication].keyWindow.rootViewController.view;
            
            CGRect targetRect = _targetRectBlock ?
                _targetRectBlock(self) :
                [_targetView convertRect:_targetView.frame toView:mainView];
            
            CGFloat mainHeight      = mainView.frame.size.height;
            CGFloat distanceFromTop = targetRect.origin.y;
            CGFloat keyboardHeight  = _keyboardSize.height;
            CGFloat currentOffset   = _scrollView.contentOffset.y;
            CGFloat targetHeight    = targetRect.size.height;
            BOOL isTargetBelowKeyboard = distanceFromTop > (mainHeight - keyboardHeight - kDefaultDistanceFromKeyboard - targetHeight);
            BOOL isTargetAboveMain = distanceFromTop < 0;
            
            if (isTargetBelowKeyboard || isTargetAboveMain) {
                CGPoint scrollPoint = CGPointMake(0.0,
                                                  currentOffset + distanceFromTop + kDefaultDistanceFromKeyboard + keyboardHeight + targetHeight - mainHeight);
                
                [_scrollView setContentOffset:scrollPoint animated:YES];
            }
        }
    }
}

- (void)setDefaultContentOffset:(CGFloat)defaultContentOffset {
    _defaultContentOffset = defaultContentOffset;
    _lastContentOffset = _defaultContentOffset;
}

- (void)setTargetView:(UIView *)targetView {
    _targetView = targetView;
    _targetRectBlock = nil;
    [self setTargetViewPrivate];
}

- (void)setTargetViewPrivate {
    _storedInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    _lastContentOffset = _scrollView.contentOffset.y;
    [self moveScrollView];
}

- (void)dealloc {
    [self deregisterKeyboardNotifications];
}

@end

@implementation MZKeyboardAutoScrollHandler(Convenience)

- (instancetype)initWithMainView:(UIView*)mainView scrollView:(UIScrollView*)scrollView  defaultContentOffset:(CGFloat)contentOffset targetView:(UIView*)targetView {
    self = [self init];
    if (self) {
        self.mainView   = mainView;
        self.scrollView = scrollView;
        self.defaultContentOffset = contentOffset;
        self.targetView = targetView;
    }
    return self;
}

@end

@implementation MZKeyboardAutoScrollHandler(Rect)

- (void)setTargetRectBlock:(TargetRectBlock)targetRectBlock {
    _targetView = nil;
    _targetRectBlock = targetRectBlock;
    [self setTargetViewPrivate];
}

- (TargetRectBlock)targetRectBlock {
    return _targetRectBlock;
}

@end

@implementation MZKeyboardAutoScrollHandler(ContentOffset)

- (void)setStoredContentOffsetDisabled:(BOOL)storedContentOffsetDisabled {
    _storedContentOffsetDisabled = storedContentOffsetDisabled;
}

- (BOOL)isStoredContentOffsetDisabled {
    return _storedContentOffsetDisabled
        || (   _storedInterfaceOrientation != [[UIApplication sharedApplication] statusBarOrientation]
            && _storedInterfaceOrientation != UIInterfaceOrientationUnknown)
        || (_scrollView && _mainView && _scrollView.contentSize.height <= _mainView.frame.size.height);
}

@end
