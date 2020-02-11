//
//  RMCModelProtocol.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 11..
//  Copyright © 2020. private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mbuffer.h"

@protocol RMCBufferProtocol <NSObject>

/* create object with buffer */
- (id)initWithBuffer:(Buffer*)buffer;

/* setup object with buffer */
- (BOOL)setBuffer:(Buffer*)buffer;

/* generate buffer from object */
- (Buffer*)buffer;

@end

