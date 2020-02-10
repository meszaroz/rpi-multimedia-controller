//
//  RMCList.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mbuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMCList : NSObject <NSSecureCoding>

@property (strong, nonatomic) NSArray<NSString*> *list;

- (instancetype)initWithBuffer:(Buffer*)buffer;

@end

NS_ASSUME_NONNULL_END
