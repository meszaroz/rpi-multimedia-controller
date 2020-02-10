//
//  RMCStatus.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mbuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMCStatus : NSObject <NSSecureCoding>

@property (strong, nonatomic) NSString *act;
@property (        nonatomic) BOOL      play;
@property (        nonatomic) NSInteger dura;
@property (        nonatomic) NSInteger pos;
@property (        nonatomic) NSInteger vol;

- (instancetype)initWithBuffer:(Buffer*)buffer;

@end

@interface RMCStatus(Buffer)

@property (nonatomic, readonly) Buffer *buffer;

@end

NS_ASSUME_NONNULL_END
