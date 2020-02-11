//
//  UIImage+Color.m
//  TotalGym
//
//  Created by Mészáros Zoltán on 15/08/15.
//  Copyright © 2015 XL Solutions. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage(Color)
+ (UIImage*)imageFromColor:(UIColor*)color {
    return [self imageFromColor:color forSize:CGSizeMake(1.0,1.0)];
}

+ (UIImage*)imageFromColor:(UIColor*)color forSize:(CGSize)size {
    return [self imageFromColor:color withAlpha:1.0 forSize:size];
}

+ (UIImage*)imageFromColor:(UIColor*)color withAlpha:(CGFloat)alpha forSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(context, alpha);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation UIImage(TintAlpha)
- (UIImage*)tintedImageUsingColor:(UIColor*)tintColor andAlpha:(CGFloat)alpha {
    return [[self tintedImageUsingColor:tintColor] imageByApplyingAlpha:alpha];
}

- (UIImage*)tintedImageUsingColor:(UIColor*)tintColor {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:drawRect];
    [tintColor set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceAtop);
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}
- (UIImage*)imageByApplyingAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -drawRect.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, drawRect, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
