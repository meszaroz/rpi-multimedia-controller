//
//  RMCCollection.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RMCImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMCCollection : NSObject

@property (nonatomic, copy) NSArray<RMCImage*> *items;

- (instancetype)initWithItems:(NSArray<RMCImage*>*)items;

/* update available one or append to items */
- (BOOL)updateItem:(RMCImage*)item;

@end

@interface RMCCollection (Convenience)

/* init with list */
- (instancetype)initWithList :(NSArray<NSString*>*)list ;

/* create items from list */
+ (NSArray<RMCImage*>*)itemsFromList:(NSArray<NSString*>*)list;

/* set items and reuse old item images */
- (void)setItemsMerged:(NSArray<RMCImage*>*)items;

@end

NS_ASSUME_NONNULL_END
