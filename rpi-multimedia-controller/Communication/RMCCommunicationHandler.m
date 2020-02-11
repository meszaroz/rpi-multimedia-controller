//
//  RMCCommunicationHandler.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCCommunicationHandler.h"
#import "mlist.h"
#import "mstatus.h"
#import "mimage.h"

@implementation RMCCommunicationHandler

- (void)requestList {
    [self sendObject:[RMCList new]];
}

- (void)requestImage:(RMCImage *)obj {
    if (obj && obj.identifier && !obj.image) {
        [self sendObject:obj];
    }
}

- (void)requestStatus {
    [self sendObject:[RMCStatus new]];
}

- (void)sendStatus:(RMCStatus*)obj {
    [self sendObject:obj];
}

#pragma mark - Communication Delegate
- (void)communication:(RMCCommunication*)communication didConnectToHost:(NSString *)host port:(uint16_t)port {
    if (_delegate && [_delegate respondsToSelector:@selector(handler:didConnectToHost:port:)]) {
        [_delegate handler:self didConnectToHost:host port:port];
    }
}

- (void)communication:(RMCCommunication*)communication didDisconnectWithError:(nullable NSError *)err {
    if (_delegate && [_delegate respondsToSelector:@selector(handler:didDisconnectWithError:)]) {
        [_delegate handler:self didDisconnectWithError:err];
    }
}

- (void)communication:(RMCCommunication*)communication didReceiveData:(Buffer *)data {
    if (data && _delegate) {
        switch (data->mode) {
            case Image : { if ([_delegate respondsToSelector:@selector(handler:didReceiveImage: )]) { [_delegate handler:self didReceiveImage :[[RMCImage  alloc] initWithBuffer:data]]; } break; }
            case List  : { if ([_delegate respondsToSelector:@selector(handler:didReceiveList:  )]) { [_delegate handler:self didReceiveList  :[[RMCList   alloc] initWithBuffer:data]]; } break; }
            case Status: { if ([_delegate respondsToSelector:@selector(handler:didReceiveStatus:)]) { [_delegate handler:self didReceiveStatus:[[RMCStatus alloc] initWithBuffer:data]]; } break; }
            case Error : { if ([_delegate respondsToSelector:@selector(handler:didReceiveError: )]) { [_delegate handler:self didReceiveError :[[RMCError  alloc] initWithBuffer:data]]; } break; }
            default: break;
        }
    }
}

#pragma mark - support
- (void)sendObject:(id<RMCBufferProtocol>)obj {
    if (_interface && obj) {
        Buffer *buffer = obj.buffer;
        [_interface writeData:buffer];
        buffer = clearBuffer(buffer);
    }
}

@end
