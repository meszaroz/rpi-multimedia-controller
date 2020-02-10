//
//  RMCCollection.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCCollection.h"

@implementation RMCCollection

- (instancetype)initWithItems:(NSArray<RMCImage*>*)items {
    self = [super init];
    
    if (self) {
        _items = [items copy];
    }
    
    return self;
}

- (BOOL)updateItem:(RMCImage *)item {
    BOOL out = item != nil;
    
    if (out) {
        /* find in list */
        NSInteger index = [_items indexOfObjectPassingTest:^BOOL(RMCImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.identifier isEqualToString:item.identifier];
        }];
        
        /* update output */
        out = index != NSNotFound;
        
        /* update image */
        if (out) {
            [_items objectAtIndex:index].image = item.image;
        }
    }
    
    return out;
}

@end

@implementation RMCCollection (Convenience)

- (instancetype)initWithList:(NSArray<NSString*>*)list {
    return [self initWithItems:[self.class itemsFromList:list]];
}

+ (NSArray<RMCImage*>*)itemsFromList:(NSArray<NSString*>*)list {
    NSMutableArray *out = nil;
    
    if (list) {
        out = [NSMutableArray array];
        
        for (NSString *name in list) {
            if (name.length > 0) {
                /* check if already in list */
                NSInteger index = [out indexOfObjectPassingTest:^BOOL(RMCImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    return [obj.identifier isEqualToString:name];
                }];
                
                /* new item */
                if (index == NSNotFound) {
                    [out addObject:[[RMCImage alloc] initWithIdentifier:name]];
                }
            }
        }
    }
    
    return out ? [out copy] : nil;
}

- (void)mergeWithItems:(NSArray<RMCImage *> *)items {
    if (items) {
        for (RMCImage *item in items) {
            if (item.image) {
                [self updateItem:item];
            }
        }
    }
}

@end
