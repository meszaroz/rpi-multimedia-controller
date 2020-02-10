//
//  RMCCommunicationHandler.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RMCStatus.h"
#import "RMCImage.h"
#import "RMCList.h"
#import "RMCError.h"

#import "RMCCommunication.h"

NS_ASSUME_NONNULL_BEGIN

@class RMCCommunicationHandler;

@protocol RMCCommunicationHandlerDelegate <NSObject>

- (void)handler:(RMCCommunicationHandler*)handler didConnectToHost:(NSString *)host port:(uint16_t)port;
- (void)handler:(RMCCommunicationHandler*)handler didDisconnectWithError:(nullable NSError *)err;

- (void)handler:(RMCCommunicationHandler*)handler didReceiveError :(RMCError *)error;
- (void)handler:(RMCCommunicationHandler*)handler didReceiveList  :(RMCList  *)list;
- (void)handler:(RMCCommunicationHandler*)handler didReceiveImage :(RMCImage *)image;
- (void)handler:(RMCCommunicationHandler*)handler didReceiveStatus:(RMCStatus*)status;

@end

@interface RMCCommunicationHandler : NSObject <RMCCommunicationDelegate>

@property (weak  , nonatomic) id<RMCCommunicationHandlerDelegate> delegate;
@property (weak  , nonatomic) id<RMCCommunicationInterface      > interface;

/* Requests */
- (void)requestList;
- (void)requestImage:(RMCImage*)image;
- (void)requestStatus;

/* Send */
- (void)sendStatus:(RMCStatus*)status;

@end

NS_ASSUME_NONNULL_END
