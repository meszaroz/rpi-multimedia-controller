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

// Controller
@interface RMCCommunicationController : NSObject

+ (RMCCommunicationController*)defaultController;

@end
