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

@end
