//
//  UIBar+Separator.m
//  qboard
//
//  Created by Zoltan Meszaros on 2017. 07. 08..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import <objc/runtime.h>
#import "UIBar+Separator.h"

static UIImageView* findSeparatorImageViewUnder(UIView *view) {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
        return (UIImageView *)view;
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = findSeparatorImageViewUnder(subview);
        if (imageView)
            return imageView;
    }
    return nil;
}

static UIImageView* separatorViewIn(UIView *view, const void *key) {
    UIImageView *out = objc_getAssociatedObject(view, &key);
    if (!out) {
        out = findSeparatorImageViewUnder(view);
        objc_setAssociatedObject(view, &key, out, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return out;
}

static void *UINavigationBarResultKey;

@implementation UINavigationBar(Separator)

- (UIImageView*)separatorView {
    return separatorViewIn(self, UINavigationBarResultKey);
}

@end

static void *UITabBarResultKey;

@implementation UITabBar(Separator)

- (UIImageView*)separatorView {
    return separatorViewIn(self, UITabBarResultKey);
}

@end

