//
//  RMCList.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMCList : NSObject <NSSecureCoding, RMCBufferProtocol>

@property (strong, nonatomic) NSArray<NSString*> *list;

- (instancetype)initWithList:(nullable NSArray<NSString*>*)list;

@end

NS_ASSUME_NONNULL_END
