//
//  RMCCommunicationController.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCCommunicationController.h"
#import "RMCCommunication.h"
#import "RMCCommunicationHandler.h"
#import "GCDAsyncSocket.h"

// Notification
NSString * const kCommunicationControllerConnectNotification          = @"kCommunicationControllerConnectNotification";
NSString * const kCommunicationControllerDisconnectNotification       = @"kCommunicationControllerDisconnectNotification";

NSString * const kCommunicationControllerDidConnectNotification       = @"kCommunicationControllerDidConnectNotification";
NSString * const kCommunicationControllerDidDisconnectNotification    = @"kCommunicationControllerDidDisconnectNotification";

NSString * const kCommunicationControllerDidReceiveErrorNotification  = @"kCommunicationControllerDidReceiveErrorNotification";
NSString * const kCommunicationControllerDidReceiveListNotification   = @"kCommunicationControllerDidReceiveListNotification";
NSString * const kCommunicationControllerDidReceiveImageNotification  = @"kCommunicationControllerDidReceiveImageNotification";
NSString * const kCommunicationControllerDidReceiveStatusNotification = @"kCommunicationControllerDidReceiveStatusNotification";

NSString * const kCommunicationControllerRequestListNotification      = @"kCommunicationControllerRequestListNotification";
NSString * const kCommunicationControllerRequestImageNotification     = @"kCommunicationControllerRequestImageNotification";
NSString * const kCommunicationControllerRequestStatusNotification    = @"kCommunicationControllerRequestStatusNotification";

NSString * const kCommunicationControllerSendStatusNotification       = @"kCommunicationControllerSendStatusNotification";

// Fields
NSString * const kUserInfoHostKey   = @"host";
NSString * const kUserInfoPortKey   = @"port";
NSString * const kUserInfoErrorKey  = @"error";
NSString * const kUserInfoObjectKey = @"object";

// Controller
@interface RMCCommunicationController() <RMCCommunicationHandlerDelegate>
@end

@implementation RMCCommunicationController {
    RMCCommunication        *_communication;
    RMCCommunicationHandler *_handler;
}

+ (RMCCommunicationController*)defaultController {
    static RMCCommunicationController* controller = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        controller = [RMCCommunicationController new];
    });
    return controller;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _handler       = [RMCCommunicationHandler new];
        _communication = [RMCCommunication        new];
        
        _handler      .interface = _communication;
        _handler      .delegate  = self;
        _communication.delegate  = _handler;
        
        [self registerNotifications];
    }
    
    return self;
}

- (void)dealloc {
    [self deregisterNotifications];
}

#pragma mark - Communication Handler Delegate
- (void)handler:(RMCCommunicationHandler*)handler didConnectToHost:(NSString *)host port:(uint16_t)port {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerDidConnectNotification
                                                        object:self
                                                      userInfo:@{ kUserInfoHostKey : host, kUserInfoPortKey : @(port)}];
}

- (void)handler:(RMCCommunicationHandler*)handler didDisconnectWithError:(nullable NSError *)err {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerDidDisconnectNotification
                                                        object:self
                                                      userInfo:err ? @{ kUserInfoErrorKey : err } : nil];
}

- (void)handler:(RMCCommunicationHandler*)handler didReceiveError:(RMCError*)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerDidReceiveErrorNotification
                                                        object:self
                                                      userInfo:@{ kUserInfoObjectKey : error }];
}

- (void)handler:(RMCCommunicationHandler*)handler didReceiveList:(RMCList*)list {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerDidReceiveListNotification
                                                        object:self
                                                      userInfo:@{ kUserInfoObjectKey : list }];
}

- (void)handler:(RMCCommunicationHandler*)handler didReceiveImage:(RMCImage*)image {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerDidReceiveImageNotification
                                                        object:self
                                                      userInfo:@{ kUserInfoObjectKey : image }];
}

- (void)handler:(RMCCommunicationHandler*)handler didReceiveStatus:(RMCStatus*)status {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerDidReceiveStatusNotification
                                                        object:self
                                                      userInfo:@{ kUserInfoObjectKey : status }];
}

#pragma mark - Notification
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connect:      ) name:kCommunicationControllerConnectNotification       object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnect:   ) name:kCommunicationControllerDisconnectNotification    object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestList:  ) name:kCommunicationControllerRequestListNotification   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestImage: ) name:kCommunicationControllerRequestImageNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestStatus:) name:kCommunicationControllerRequestStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendStatus:   ) name:kCommunicationControllerSendStatusNotification    object:nil];
}

- (void)deregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerConnectNotification       object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerDisconnectNotification    object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerRequestListNotification   object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerRequestImageNotification  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerRequestStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerSendStatusNotification    object:nil];
}

#pragma mark - Proxy
- (void)connect:(NSNotification*)notification {
    if (notification.userInfo) {
        NSString *host = notification.userInfo[kUserInfoHostKey];
        NSNumber *port = notification.userInfo[kUserInfoPortKey];
        
        if (host && port) {
            NSError *error;
            if (![_communication connectToHost:host onPort:port.integerValue error:&error]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerDidDisconnectNotification
                                                                    object:self
                                                                  userInfo:@{ kUserInfoErrorKey : error }];
            }
        }
    }
}

- (void)disconnect:(NSNotification*)notification {
    if (_communication.socket.isConnected) {
        [_communication disconnect];
    }
    else {
        [self handler:_handler didDisconnectWithError:nil];
    }
}

- (void)requestList:(NSNotification*)notification {
    [_handler requestList];
}

- (void)requestImage:(NSNotification*)notification {
    if (notification.userInfo) {
        RMCImage *image = notification.userInfo[kUserInfoObjectKey];
        
        if (image) {
            [_handler requestImage:image];
        }
    }
}

- (void)requestStatus:(NSNotification*)notification {
    [_handler requestStatus];
}

- (void)sendStatus:(NSNotification*)notification {
    if (notification.userInfo) {
        RMCStatus *status = notification.userInfo[kUserInfoObjectKey];
        
        if (status) {
            [_handler sendStatus:status];
        }
    }
}

@end
