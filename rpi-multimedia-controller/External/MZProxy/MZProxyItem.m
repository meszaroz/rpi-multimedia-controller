//
//  MZProxyItem.m
//  qboard
//
//  Created by Zoltan Meszaros on 2017. 07. 11..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import "MZProxySupport.h"
#import "MZProxyItem_p.h"
#import "MZProxyItem.h"
#import "MZProxy.h"

@implementation MZProxyItem {
    __weak   MZProxyItem *_input;
    __strong NSArray     *_output;
}

+ (instancetype)itemWithName:(NSString*)name
                       input:(MZProxyItem*)input
                   predicate:(NSPredicate*)predicate
                  comparator:(NSComparator)comparator {
    return [[self alloc] initWithName:name input:input predicate:predicate comparator:comparator];
}

- (instancetype)initWithName:(NSString*)name
                       input:(MZProxyItem*)input
                   predicate:(NSPredicate*)predicate
                  comparator:(NSComparator)comparator {
    self = [self init];
    if (self) {
        _name       = name;
        _input      = input;
        _predicate  = predicate;
        _comparator = comparator;
        [self invalidate];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [MZMutableArray new];
        _items.delegate = self;        
    }
    return self;
}

- (void)setPredicate:(NSPredicate *)predicate {
    if (_predicate != predicate) {
        _predicate = predicate;
        [self invalidate];
    }
}

- (void)setComparator:(NSComparator)comparator {
    if (_comparator != comparator) {
        _comparator = comparator;
        [self invalidate];
    }
}

- (void)setInput:(MZProxyItem*)input {
    if (_input != input) {
        _input = input;
        [self invalidate];
    }
}

- (void)setOutput:(NSArray*)output {
    _output = output;
}

/* optimization - multiple invalidation can happen before rebuild */
- (id)output {
    if (!_output) {
        [self rebuildOutput];
    }
    return _output;
}

#pragma mark - support
- (void)invalidate {
    [_items makeObjectsPerformSelector:@selector(invalidate)];
    _output = nil;
}

- (void)mutableArrayDidChange:(MZMutableArray *)array {
    /* if items list changed, update their input to point to the model - will invalidate only if model different */
    if (array == _items) {
        [array makeObjectsPerformSelector:@selector(setInput:) withObject:self];
    }
    
    /* force invalidate - will invalidate twice if model changed - but rebuilding of output will happen only on read */
    [self invalidate];
}

- (void)rebuildOutput {
    if (_input) {
        self.output = [NSArray filteredSortedArray:_input.output
                                     withPredicate:self.predicate
                                     andComparator:self.comparator];
    }
}

@end

@implementation MZProxyItem(Convenience)

+ (instancetype)itemWithName:(NSString*)name
                   predicate:(NSPredicate*)predicate
                  comparator:(NSComparator)comparator {
    return [self itemWithName:name input:nil predicate:predicate comparator:comparator];
}

@end

@implementation MZProxyItemWrapper

- (instancetype)initWithItem:(MZProxyItem *)item {
    self = [super init];
    if (self) {
        self.item = item;
    }
    return self;
}

- (void)setItem:(MZProxyItem *)item {
    _item = item;
    self.activeItem = nil;
}

@end

@implementation MZProxyItemWrapper(Proxy)

- (MZProxy*)proxy {
    return [_item isKindOfClass:MZProxy.class] ?
        (MZProxy*)_item :
        nil;
}

- (NSArray*)output {
    return _activeItem ?
        _activeItem.output :
        _item.output;
}

- (NSString*)activeName {
    return _activeItem ?
        _activeItem.name :
        _item.name;
}

- (void)setActiveItemWithName:(NSString *)name {
    if (_item) {
        NSInteger index = [_item.items indexOfObjectPassingTest:^BOOL(MZProxyItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return name && [obj.name isEqualToString:name];
        }];
        [self setActiveItemAtIndex:index];
    }
}

- (void)setActiveItemAtIndex:(NSInteger)index {
    if (_item && index != NSNotFound) {
        self.activeItem = _item.items[index];
    }
}

@end
