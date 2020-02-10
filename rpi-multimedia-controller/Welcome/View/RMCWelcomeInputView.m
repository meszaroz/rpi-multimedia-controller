//
//  RMCWelcomeInputView.m
//  qboard
//
//  Created by Zoltan Meszaros on 2017. 06. 16..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import "PureLayout.h"
#import "RMCWelcomeInputView.h"

@implementation RMCWelcomeInputView {
    UIView *_separator;
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
    _textField = [MZTextField new];
    _textField.font                   = [UIFont fontWithName:@"HelveticaNeue" size:14];
    _textField.borderStyle            = UITextBorderStyleNone;
    _textField.textAlignment          = NSTextAlignmentNatural;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.autocorrectionType     = UITextAutocorrectionTypeNo;
    
    // Disables the password autoFill accessory view.
    if (@available(iOS 11.0, *)) {
        _textField.textContentType = @"";
    }
    
    [self addSubview:_textField];
    [_textField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    _separator = [UIView new];
    [self addSubview:_separator];
    [_separator autoPinEdge:ALEdgeLeading  toEdge:ALEdgeLeading  ofView:_textField];
    [_separator autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_textField];
    [_separator autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_separator autoSetDimension:ALDimensionHeight toSize:0.5];
    
    self.tintColor = self.tintColor;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    _textField.textColor       = tintColor;
    _separator.backgroundColor = tintColor;
}

@end
