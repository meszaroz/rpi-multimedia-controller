//
//  MZTextInputHandler.m
//  qboard
//
//  Created by Zoltan Meszaros on 7/8/17.
//  Copyright © 2017 Zoltan Meszaros. All rights reserved.
//

#import "MZTextInputHandler.h"

@interface MZTextInputHandler() <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation MZTextInputHandler {
    NSMutableArray<UIView*> *_mutableInputs;
    UITapGestureRecognizer *_tapGesture;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        _keyboardHandler = [MZKeyboardAutoScrollHandler new];
        _mutableInputs = [NSMutableArray array];
        _shouldInputsBecomeFirstRespondersAutomatically = NO;
    }
    return self;
}

- (void)validateInput:(UIView *)input {
    if ([_mutableInputs containsObject:input] && _validationHandler) {
        _validationHandler(input);
    }
}

- (BOOL)registerInput:(UIView *)input {
    BOOL out = ![_mutableInputs containsObject:input];
    if (out) {
        [_mutableInputs addObject:input];
        /**/ if ([input isKindOfClass:UITextField.class]) {
            ((UITextField*)input).delegate = self;
            [(UITextField*)input addTarget:self
                                    action:@selector(textFieldDidChanged:)
                          forControlEvents:UIControlEventEditingChanged];
        }
        else if ([input isKindOfClass:UITextView .class]) {
            ((UITextView *)input).delegate = self;
        }
    }
    return out;
}

- (BOOL)deregisterInput:(UIView *)input {
    BOOL out = [_mutableInputs containsObject:input];
    if (out) {
        [_mutableInputs removeObject:input];
        /**/ if ([input isKindOfClass:UITextField.class]) {
            [(UITextField*)input removeTarget:self
                                    action:@selector(textFieldDidChanged:)
                          forControlEvents:UIControlEventEditingChanged];
        }
        else if ([input isKindOfClass:UITextView .class]) {
        }
    }
    return out;
}

- (NSArray<UIView*>*)inputs {
    return [_mutableInputs copy];
}

#pragma mark - UITextField
- (void)textFieldDidChanged:(UITextField*)textField {
    [self validateInput:textField];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textInputHandler:didInputChange:)]) {
        [_delegate textInputHandler:self didInputChange:textField];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _keyboardHandler.targetView = textField;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(textInputHandler:didInputBeginEditing:)]) {
        [_delegate textInputHandler:self didInputBeginEditing:textField];
    }
    [self setTapGestureActive:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_shouldInputsBecomeFirstRespondersAutomatically
     /* only registered inputs can call this, so it is surely registered */
     && textField != _mutableInputs.lastObject) {
        NSInteger index = [_mutableInputs indexOfObject:textField];
        UIView *nextInput = [_mutableInputs objectAtIndex:index + 1];
        if (_delegate && [_delegate respondsToSelector:@selector(textInputHandler:willChangeFirstResponderFromInput:toInput:)]) {
            [_delegate textInputHandler:self willChangeFirstResponderFromInput:textField toInput:nextInput];
        }
        [nextInput becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self setTapGestureActive:NO];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(textInputHandler:didInputEndEditing:)]) {
        [_delegate textInputHandler:self didInputEndEditing:textField];
    }
}

#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView {
    [self validateInput:textView];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textInputHandler:didInputChange:)]) {
        [_delegate textInputHandler:self didInputChange:textView];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _keyboardHandler.targetView = textView;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (_delegate && [_delegate respondsToSelector:@selector(textInputHandler:didInputBeginEditing:)]) {
        [_delegate textInputHandler:self didInputBeginEditing:textView];
    }
    [self setTapGestureActive:YES];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self setTapGestureActive:NO];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_delegate && [_delegate respondsToSelector:@selector(textInputHandler:didInputEndEditing:)]) {
        [_delegate textInputHandler:self didInputEndEditing:textView];
    }
}

#pragma mark - support
- (void)dismissKeyboard {
    for (UIView *input in _mutableInputs) {
        [input resignFirstResponder];
    }
}

- (void)setTapGestureActive:(BOOL)active {
    if (_keyboardHandler && _keyboardHandler.mainView) {
        if (active) { [_keyboardHandler.mainView    addGestureRecognizer:_tapGesture]; }
        else        { [_keyboardHandler.mainView removeGestureRecognizer:_tapGesture]; }
    }
}

@end
