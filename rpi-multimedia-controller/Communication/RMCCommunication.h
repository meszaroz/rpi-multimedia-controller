//
//  RMCCommunication.h
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mbuffer.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SocketDataType) {
    SocketDataTypeHeader,
    SocketDataTypeData
};

@class RMCCommunication;

@protocol RMCCommunicationDelegate <NSObject>

- (void)communication:(RMCCommunication*)communication didConnectToHost:(NSString *)host port:(uint16_t)port;
- (void)communication:(RMCCommunication*)communication didDisconnectWithError:(nullable NSError *)err;
- (void)communication:(RMCCommunication*)communication didReceiveData:(Buffer *)data;

@end

@protocol RMCCommunicationInterface <NSObject>

@required
- (BOOL)writeData:(Buffer*)data;

@end

@class GCDAsyncSocket;

@interface RMCCommunication : NSObject <RMCCommunicationInterface>

@property (strong, nonatomic) GCDAsyncSocket              *socket;
@property (weak  , nonatomic) id<RMCCommunicationDelegate> delegate;

- (BOOL)connectToHost:(NSString*)host onPort:(uint16_t)port error:(NSError **)errPtr;
- (void)disconnect;

@end

NS_ASSUME_NONNULL_END
