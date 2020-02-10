//
//  RMCError.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mbuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMCError : NSObject

@property (strong, nonatomic) NSString *message;

- (instancetype)initWithBuffer:(Buffer*)buffer;

@end

NS_ASSUME_NONNULL_END
