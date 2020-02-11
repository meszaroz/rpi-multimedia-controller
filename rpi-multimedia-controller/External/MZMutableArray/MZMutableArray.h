//
//  MZMutableArray.h
//  qboard
//
//  Created by Zoltan Meszaros on 2017. 07. 11..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MZMutableArrayChangeNotification;

@class MZMutableArray;

@protocol MZMutableArrayDelegate <NSObject>

- (void)mutableArrayDidChange:(MZMutableArray*)array;

@end

@interface MZMutableArray<ObjectType> : NSMutableArray<ObjectType>

@property (weak, nonatomic) id<MZMutableArrayDelegate> delegate;

@end

@interface MZMutableArray<ObjectType>(Extension)

- (void)setObject:(ObjectType)object;
- (void)removeObject:(ObjectType)object;

@end

@interface MZMutableArray<ObjectType>(Batch)

- (BOOL)beginBatchUpdate;
- (BOOL)endBatchUpdate;

@end
