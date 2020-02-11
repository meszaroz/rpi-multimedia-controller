//
//  RMCList.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCList.h"
#import "mlist.h"

static NSString * const kListKey = @"list";

@implementation RMCList

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithList:(nullable NSArray<NSString*>*)list {
    self = [super init];
    
    if (self) {
        _list = list;
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithList:nil];
}

- (instancetype)initWithBuffer:(Buffer*)buffer {
    self = [self init];
    
    if (self) {
        self.buffer = buffer;
    }
    
    return self;
}

#pragma mark - Secure Coder Protocol
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_list forKey:kListKey];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _list = [aDecoder decodeObjectForKey:kListKey];
    }
    
    return self;
}

#pragma mark - Buffer Protocol
- (BOOL)setBuffer:(Buffer *)buffer {
    BOOL out = buffer && buffer->mode == List;
    
    if (out) {
        ListContainer *cont = readListContainerFromBuffer(buffer);
        
        out = cont != nil;
        if (cont) {
            _list = [self.class listFromContainer:cont];
        }
        
        clearListContainer(cont);
    }
    
    return out;
}

- (Buffer*)buffer {
    Buffer *out = 0;
    
    /* set data */
    ListContainer *cont = createListContainer(_list ? (TSize)_list.count : 0);
    if (cont) {
        /* pack data into container */
        for (NSUInteger i = 0; _list && i < _list.count; ++i) {
            copyString(&cont->list[i], [_list objectAtIndex:i].UTF8String);
        }
        
        /* write to buffer */
        out = writeListContainerToBuffer(cont);
        
        /* cleanup */
        cont = clearListContainer(cont);
    }
    
    return out;
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
