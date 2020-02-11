//
//  RMCImage.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCImage.h"
#import "mimage.h"

static NSString * const kIdentifierKey = @"id";
static NSString * const kImageKey      = @"image";

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
    
    if (self) {
        self.buffer = buffer;
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

#pragma mark - Secure Coder Protocol
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_identifier forKey:kIdentifierKey];
    [aCoder encodeObject:_image      forKey:kImageKey     ];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _identifier = [aDecoder decodeObjectForKey:kIdentifierKey];
        _image      = [aDecoder decodeObjectForKey:kImageKey     ];
    }
    
    return self;
}

#pragma mark - Buffer Protocol
- (BOOL)setBuffer:(Buffer *)buffer {
    BOOL out = buffer && buffer->mode == Image;
    
    if (out) {
        ImageContainer *cont = readImageContainerFromBuffer(buffer);
        
        out = cont != nil;
        if (out) {
            _identifier = [NSString stringWithUTF8String:cont->name];
            _image      = [self.class imageFromContainer:cont];
        }
        
        clearImageContainer(cont);
    }
    
    return out;
}

- (Buffer*)buffer {
    Buffer *out = 0;
    
    if (_identifier && _identifier.length > 0) {
        /* get data */
        NSData *data = self.imageData;
        
        /* pack data into container */
        ImageContainer *cont = createImageContainer(_identifier.UTF8String, (TSize)data.length);
        if (cont) {
            memmove(cont->image, data.bytes, data.length);
            cont->width  = _image ? _image.size.width  : 0;
            cont->height = _image ? _image.size.height : 0;
            
            /* write to buffer */
            out = writeImageContainerToBuffer(cont);
        }
        
        /* cleanup */
        cont = clearImageContainer(cont);
    }
    
    return out;
}

#pragma mark - support
- (NSData*)imageData {
    NSData *out = nil;
    
    if (_image) {
        CGDataProviderRef provider = CGImageGetDataProvider(_image.CGImage);
        out = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
    }
    
    return out;
}

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
