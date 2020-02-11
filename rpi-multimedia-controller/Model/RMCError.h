//
//  RMCError.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMCError : NSObject <NSSecureCoding, RMCBufferProtocol>

@property (        nonatomic, getter=isValid) BOOL valid;

@property (strong, nonatomic) NSString *message;

- (instancetype)initWithMessage:(nullable NSString*)message;

@end

NS_ASSUME_NONNULL_END
