//
//  MZTextInputHandler.h
//  qboard
//
//  Created by Zoltan Meszaros on 7/8/17.
//  Copyright © 2017 Zoltan Meszaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZKeyboardAutoScrollHandler.h"

typedef void (^ValidationHandler)(UIView *input);

@class MZTextInputHandler;

@protocol MZTextInputHandlerDelegate <NSObject>

@optional
- (void)textInputHandler:(MZTextInputHandler*)handler didInputChange:(UIView*)input;
- (void)textInputHandler:(MZTextInputHandler*)handler didInputBeginEditing:(UIView*)input;
- (void)textInputHandler:(MZTextInputHandler*)handler didInputEndEditing:(UIView*)input;
- (void)textInputHandler:(MZTextInputHandler*)handler willChangeFirstResponderFromInput:(UIView*)inputFrom toInput:(UIView*)inputTo;

@end

@interface MZTextInputHandler : NSObject

@property (strong, nonatomic, readonly) MZKeyboardAutoScrollHandler *keyboardHandler;
@property (strong, nonatomic, readonly) NSArray<UIView*> *inputs;

@property (        nonatomic) BOOL shouldInputsBecomeFirstRespondersAutomatically;
@property (strong, nonatomic) ValidationHandler validationHandler;

@property (weak  , nonatomic) id<MZTextInputHandlerDelegate> delegate;

- (void)validateInput:(UIView*)input;
- (BOOL)registerInput:(UIView*)input;
- (BOOL)deregisterInput:(UIView*)input;

@end
