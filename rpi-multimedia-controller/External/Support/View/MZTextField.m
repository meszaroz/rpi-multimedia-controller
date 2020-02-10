//
//  MZTextField.m
//  qboard
//
//  Created by Zoltan Meszaros on 2019. 10. 15..
//  Copyright © 2019. Zoltan Meszaros. All rights reserved.
//

#import "MZTextField.h"

@implementation MZTextField

- (void)drawPlaceholderInRect:(CGRect)rect {
    UIColor *color = [self.textColor colorWithAlphaComponent:0.5];

    if ([self.placeholder respondsToSelector:@selector(drawInRect:withAttributes:)]) {
        NSDictionary *attributes = @{NSForegroundColorAttributeName: color, NSFontAttributeName: self.font};
        CGRect boundingRect = [self.placeholder boundingRectWithSize:rect.size options:0 attributes:attributes context:nil];
        [self.placeholder drawAtPoint:CGPointMake(0, (rect.size.height / 2) - boundingRect.size.height / 2) withAttributes:attributes];
    }
}

@end
