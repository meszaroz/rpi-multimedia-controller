//
//  RMCListProxy.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 11..
//  Copyright © 2020. private. All rights reserved.
//

#import "MZProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMCListProxy : MZProxy

@property (nonatomic, copy) NSString *filter;

@end

@interface RMCListProxy(Filter)

- (NSArray*)filteredModel;

@end

NS_ASSUME_NONNULL_END
