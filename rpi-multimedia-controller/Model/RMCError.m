//
//  RMCError.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCError.h"
#import "merror.h"

static NSString * const kMessageKey = @"message";

@implementation RMCError

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithMessage:(nullable NSString*)message {
    self = [super init];
    
    if (self) {
        _message = message;
    }
    
    return self;
}

- (instancetype)init {
   return [self initWithMessage:nil];
}

- (instancetype)initWithBuffer:(Buffer*)buffer {
    self = [self init];
    
    if (self) {
        self.buffer = buffer;
    }
    
    return self;
}

- (BOOL)isValid {
    return _message && _message.length > 0;
}

#pragma mark - Secure Coder Protocol
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_message forKey:kMessageKey];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _message = [aDecoder decodeObjectForKey:kMessageKey];
    }
    
    return self;
}

#pragma mark - Buffer Protocol
- (BOOL)setBuffer:(Buffer *)buffer {
    BOOL out = buffer && buffer->mode == Error;
    
    if (out) {
       ErrorContainer *cont = readErrorContainerFromBuffer(buffer);
        
        out = cont != nil;
        if (out) {
            _message = [NSString stringWithUTF8String:cont->message];
        }
        
        clearErrorContainer(cont);
    }
    
    return out;
}

- (Buffer*)buffer {
    Buffer *out = 0;
    
    /* set data */
    ErrorContainer *cont = createErrorContainer();
    if (cont) {
        /* pack data into container */
        copyString(&cont->message, _message.UTF8String);
        
        /* write to buffer */
        out = writeErrorContainerToBuffer(cont);
        
        /* cleanup */
        cont = clearErrorContainer(cont);
    }
    
    return out;
}

@end
