//
//  UIImage+Color.h
//  TotalGym
//
//  Created by Mészáros Zoltán on 15/08/15.
//  Copyright © 2015 XL Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Color)
+ (UIImage*)imageFromColor:(UIColor*)color;
+ (UIImage*)imageFromColor:(UIColor*)color forSize:(CGSize)size;
+ (UIImage*)imageFromColor:(UIColor*)color withAlpha:(CGFloat)alpha forSize:(CGSize)size;
@end

@interface UIImage(TintAlpha)
- (UIImage*)tintedImageUsingColor:(UIColor*)tintColor andAlpha:(CGFloat)alpha;
- (UIImage*)tintedImageUsingColor:(UIColor*)tintColor;
- (UIImage*)imageByApplyingAlpha:(CGFloat)alpha;
@end
