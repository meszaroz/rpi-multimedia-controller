//
//  MZProxy.m
//  qboard
//
//  Created by Zoltan Meszaros on 2017. 07. 11..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import "MZCommon.h"
#import "MZProxySupport.h"
#import "MZProxy.h"
#import "MZProxyItem.h"
#import "MZProxyItem_p.h"

NSArray *arrayObject(id object) {
    return [object isKindOfClass:NSArray.class] ? (NSArray*)object : nil;
}

@interface MZProxy() <MZMutableArrayDelegate>

- (void)setModelPrivate;

@end

@implementation MZProxy

- (instancetype)initWithModel:(NSArray*)model andView:(UIView*)view {
    self = [super init];
    if (self) {
        self.view  = view;
        self.model = model;
    }
    return self;
}

- (void)setModel:(NSArray *)model {
    if (_model != model) {
        _model = model;
        [self setModelPrivate];
    }
}

- (void)setModelPrivate {
    if (_model) {
        [self invalidate];
    }
}

- (void)setView:(UITableView *)view {
    if (_view != view) {
        _view = view;
        [self setViewPrivate];
    }
}

- (void)setViewPrivate {
    __weak UIView *view = _view;
    if (_model && view && [view respondsToSelector:@selector(reloadData)]) {
        dispatch_main_sync(^{ [view performSelector:@selector(reloadData)]; });
    }
}

- (void)invalidate {
    [super invalidate];
    [self setViewPrivate];
}

- (void)rebuildOutput {
    if (_model) {
        self.output = [NSArray filteredSortedArray:_model
                                     withPredicate:self.predicate
                                     andComparator:self.comparator];
    }
}

@end

@implementation MZMutableProxy

- (void)setMutableModel:(MZMutableArray *)mutableModel {
    self.model = mutableModel;
}

- (MZMutableArray*)mutableModel {
    return (MZMutableArray*)self.model;
}

- (void)setModelPrivate {
    MZMutableArray *model = self.mutableModel;
    if (model) {
        model.delegate = self;
        [self.items makeObjectsPerformSelector:@selector(setInput:) withObject:self];
    }
    [super setModelPrivate];
}

- (instancetype)initWithMutableModel:(MZMutableArray*)model andView:(UIView*)view {
    return [super initWithModel:model andView:view];
}

@end

