//
//  RMCImage.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMCImage : NSObject <NSSecureCoding, RMCBufferProtocol>

@property (strong, nonatomic) UIImage  *image;
@property (strong, nonatomic) NSString *identifier;

- (instancetype)initWithIdentifier:(NSString*)identifier;

@end

NS_ASSUME_NONNULL_END
