//
//  RMCImage.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCImage.h"
#import "mimage.h"

@implementation RMCImage

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _identifier = nil;
        _image      = nil;
    }
    
    return self;
}

- (instancetype)initWithBuffer:(Buffer*)buffer {
    self = [self init];
    
    if (self && buffer && buffer->mode == Image) {
        ImageContainer *cont = readImageContainerFromBuffer(buffer);
        if (cont) {
            _identifier = [NSString stringWithUTF8String:cont->name];
            _image      = [self.class imageFromContainer:cont];
            
            clearImageContainer(cont);
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

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_identifier forKey:@"id"   ];
    [aCoder encodeObject:_image      forKey:@"image"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _identifier = [aDecoder decodeObjectForKey:@"id"   ];
        _image      = [aDecoder decodeObjectForKey:@"image"];
    }
    
    return self;
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
