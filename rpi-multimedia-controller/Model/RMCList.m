//
//  RMCList.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCList.h"
#import "mlist.h"

@implementation RMCList

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _list = nil;
    }
    
    return self;
}

- (instancetype)initWithBuffer:(Buffer*)buffer {
    self = [self init];
    
    if (self && buffer && buffer->mode == List) {
        ListContainer *cont = readListContainerFromBuffer(buffer);
        if (cont) {
            _list = [self.class listFromContainer:cont];
            
            clearListContainer(cont);
        }
    }
    
    return self;
}

#pragma mark - support
+ (NSArray<NSString*>*)listFromContainer:(ListContainer*)cont {
    NSMutableArray<NSString*> *out = nil;
    
    if (cont) {
        out = [NSMutableArray arrayWithCapacity:cont->count];
        for (int i = 0; i < cont->count; ++i) {
            [out addObject:[NSString stringWithUTF8String:cont->list[i]]];
        }
    }
    
    return out ? [out copy] : nil;
}

@end
