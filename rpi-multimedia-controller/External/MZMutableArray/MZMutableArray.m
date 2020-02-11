//
//  MZMutableArray.m
//  qboard
//
//  Created by Zoltan Meszaros on 2017. 07. 11..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import "MZMutableArray.h"
#import "MZMutableArray_p.h"

NSString * const MZMutableArrayChangeNotification = @"MZMutableArrayChangeNotification";

static NSString * const MZMutableArrayDataKey = @"MZMutableArrayDataKey";

@implementation MZMutableArray {
    NSMutableArray *_data;
    BOOL _batchUpdateActive;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - coding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
        _data = [aDecoder decodeObjectForKey:MZMutableArrayDataKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_data forKey:MZMutableArrayDataKey];
}

#pragma mark - copy
- (id)copyWithZone:(NSZone *)zone {
    return [_data copyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    MZMutableArray *out = [[MZMutableArray allocWithZone:zone] init];
    out->_data = [_data mutableCopyWithZone:zone];
    return out;
}

#pragma mark - enumeration
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained _Nullable [_Nonnull])buffer count:(NSUInteger)len {
    return [_data countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - array
- (NSUInteger)count {
    return [_data count];
}

- (id)objectAtIndex:(NSUInteger)index {
    return [_data objectAtIndex:index];
}

#pragma mark - mutable array
- (void)addObject:(id)anObject {
    [_data addObject:anObject];
    [self handleChangeIfAllowed];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [_data insertObject:anObject atIndex:index];
    [self handleChangeIfAllowed];
}

- (void)removeLastObject {
    [_data removeLastObject];
    [self handleChangeIfAllowed];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [_data removeObjectAtIndex:index];
    [self handleChangeIfAllowed];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [_data replaceObjectAtIndex:index withObject:anObject];
    [self handleChangeIfAllowed];
}

#pragma mark - support
- (BOOL)handleChangeIfAllowed {
    BOOL out = !_batchUpdateActive;
    if (out) {
        [self handleChange];
    }
    return out;
}

#pragma mark - private
- (void)setData:(NSMutableArray *)data {
    if (data && _data != data) {
        _data = data;
    }
}

- (NSMutableArray*)data {
    return _data;
}

- (void)initialize {
    _data = [NSMutableArray array];
    _batchUpdateActive = NO;
}

- (BOOL)handleChange {
    if (_delegate) {
        [_delegate mutableArrayDidChange:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MZMutableArrayChangeNotification
                                                        object:self];
    
    return YES;
}

@end

@implementation MZMutableArray(Extension)

- (void)setObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    if (index == NSNotFound) { [self addObject:object]; }
    else                     { [self replaceObjectAtIndex:index withObject:object]; }
}

- (void)removeObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    if (index != NSNotFound) {
        [self removeObjectAtIndex:index];
    }
}

@end

@implementation MZMutableArray(Batch)

- (BOOL)beginBatchUpdate {
    BOOL out = !_batchUpdateActive;
    if (out) {
        _batchUpdateActive = YES;
    }
    return out;
}

- (BOOL)endBatchUpdate {
    BOOL out = _batchUpdateActive;
    if (out) {
        _batchUpdateActive = NO;
        out = [self handleChange];
    }
    return out;
}

@end
