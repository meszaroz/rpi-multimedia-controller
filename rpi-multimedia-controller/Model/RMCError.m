//
//  RMCError.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCError.h"
#import "merror.h"

@implementation RMCError

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _message = nil;
    }
    
    return self;
}

- (instancetype)initWithBuffer:(Buffer*)buffer {
    self = [self init];
    
    if (self && buffer && buffer->mode == Error) {
        ErrorContainer *cont = readErrorContainerFromBuffer(buffer);
        if (cont) {
            _message = [NSString stringWithUTF8String:cont->message];
            
            clearErrorContainer(cont);
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_message forKey:@"message"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _message = [aDecoder decodeObjectForKey:@"message"];
    }
    
    return self;
}

@end
