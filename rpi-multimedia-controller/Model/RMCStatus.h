//
//  RMCStatus.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMCStatus : NSObject <NSSecureCoding, RMCBufferProtocol>

@property (strong, nonatomic) NSString *act;
@property (        nonatomic) BOOL      play;
@property (        nonatomic) NSInteger dura;
@property (        nonatomic) NSInteger pos;
@property (        nonatomic) NSInteger vol;

- (instancetype)initWithAct:(nullable NSString*)act play:(BOOL)play dura:(NSInteger)dura pos:(NSInteger)pos vol:(NSInteger)vol;

@end

NS_ASSUME_NONNULL_END
