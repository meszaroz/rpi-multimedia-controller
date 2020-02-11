//
//  RMCListProxy.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 11..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCListProxy.h"
#import "MZProxyDefaults.h"
#import "RMCImage.h"

@implementation RMCListProxy

- (instancetype)initWithModel:(NSArray *)model andView:(UIView *)view {
    self = [super initWithModel:model andView:view];
    if (self) {
        self.predicate  = self.defaultPredicate;
        self.comparator = self.defaultComparator;
    }
    return self;
}

- (void)setFilter:(NSString *)filter {
    _filter = [filter copy];
    [self invalidate];
}

#pragma mark - support
- (NSPredicate*)defaultPredicate {
    __weak typeof(self) weakSelf = self;
    return [NSPredicate predicateWithBlock:^BOOL(RMCImage* item, NSDictionary<NSString *,id> * _Nullable bindings) {
        return !weakSelf || [MZProxyFilters defaultFilterString:item.identifier withKey:weakSelf.filter];
    }];
}

- (NSComparator)defaultComparator {
    return ^NSComparisonResult(RMCImage* item1, RMCImage* item2) {
        return [item1.identifier.lastPathComponent compare:item2.identifier.lastPathComponent];
    };
}

@end

@implementation RMCListProxy(Filter)

- (NSArray*)filteredModel {
    return (NSArray*)self.output;
}

@end


