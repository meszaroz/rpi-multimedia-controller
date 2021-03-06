//
//  RMCCommunicationController.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import <Foundation/Foundation.h>

// Notifications
extern NSString * const kCommunicationControllerConnectNotification;
extern NSString * const kCommunicationControllerDisconnectNotification;

extern NSString * const kCommunicationControllerDidConnectNotification;
extern NSString * const kCommunicationControllerDidDisconnectNotification;

extern NSString * const kCommunicationControllerDidReceiveErrorNotification;
extern NSString * const kCommunicationControllerDidReceiveListNotification;
extern NSString * const kCommunicationControllerDidReceiveImageNotification;
extern NSString * const kCommunicationControllerDidReceiveStatusNotification;

extern NSString * const kCommunicationControllerRequestListNotification;
extern NSString * const kCommunicationControllerRequestImageNotification;
extern NSString * const kCommunicationControllerRequestStatusNotification;

extern NSString * const kCommunicationControllerSendStatusNotification;

// Fields
extern NSString * const kUserInfoHostKey;
extern NSString * const kUserInfoPortKey;
extern NSString * const kUserInfoErrorKey;
extern NSString * const kUserInfoObjectKey;

// Controller
@interface RMCCommunicationController : NSObject

@property (copy, nonatomic, readonly) NSString *host;
@property (      nonatomic, readonly) uint16_t  port;

+ (RMCCommunicationController*)defaultController;

@end
