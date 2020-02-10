//
//  RMCImage.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCImage.h"
#import "mimage.h"

@implementation RMCImage {
    ImageContainer *_cont;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _identifier = nil;
        _image      = nil;
        _cont       = 0;
    }
    
    return self;
}

- (instancetype)initWithBuffer:(Buffer*)buffer {
    self = [self init];
    
    if (self && buffer && buffer->mode == Image) {
        _cont = readImageContainerFromBuffer(buffer);
        if (_cont) {
            _identifier = [NSString stringWithUTF8String:_cont->name];
            _image      = [self.class imageFromContainer:_cont];
        }
    }
    
    return self;
}

- (instancetype)initWithIdentifier:(NSString*)identifier {
    self = [self init];
    
    if (self && identifier) {
        _identifier = identifier;
    }
    
    return self;
}

- (void)dealloc {
    if (_cont) {
        _cont = clearImageContainer(_cont);
    }
}

#pragma mark - support
+ (UIImage*)imageFromContainer:(ImageContainer*)cont {
    UIImage *out = nil;
    
    if (cont && cont->name) {
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,
                                                                  cont->image,
                                                                  cont->size,
                                                                  NULL);
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
        CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
        CGImageRef imageRef = CGImageCreate(cont->width,
                            cont->height,
                            8,
                            32,
                            4*cont->width,colorSpaceRef,
                            bitmapInfo,
                            provider,NULL,NO,renderingIntent);
        
        if (imageRef) {
            out = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
        }
    }
    
    return out;
}

@end
