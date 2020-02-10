//
//  RMCCommunication.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCCommunication.h"
#import "GCDAsyncSocket.h"
#import "mcommon.h"

@interface RMCCommunication() <GCDAsyncSocketDelegate>
@end

@implementation RMCCommunication {
    Buffer *_serverBuffer;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _serverBuffer = 0;
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return self;
}

- (BOOL)connectToHost:(NSString *)host onPort:(uint16_t)port error:(NSError *__autoreleasing  _Nullable *)errPtr {
    return [_socket connectToHost:host onPort:port error:errPtr];
}

- (void)disconnect {
    if (_socket.isConnected) {
        [_socket disconnect];
    }
}

- (void)dealloc {
    _socket.delegate = nil;
    [self disconnect];
}

#pragma mark - Interface
- (BOOL)writeData:(Buffer*)data {
    BOOL out = _socket.isConnected && data;
    
    if (out) {
        /* collect data from buffer */
        TSize     size;
        TPointer *bytes = bufferToStreamData(data, &size);
        
        /* write to socket */
        [_socket writeData:[NSData dataWithBytes:bytes length:size]
               withTimeout:-1
                       tag:data->mode];
        
        /* cleanup data */
        free(bytes);
    }
    
    return out;
}

#pragma mark - Socket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    [sock performBlock:^{ [sock enableBackgroundingOnSocket]; }];
    
    /* start listening */
    [sock readDataToLength:headerSize()
               withTimeout:-1
                       tag:SocketDataTypeHeader];
    
    /* notify delegate */
    if (_delegate && [_delegate respondsToSelector:@selector(communication:didConnectToHost:port:)]) {
        [_delegate communication:self didConnectToHost:host port:port];
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    if (_delegate && [_delegate respondsToSelector:@selector(communication:didDisconnectWithError:)]) {
        [_delegate communication:self didDisconnectWithError:err];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    switch (tag) {
        case SocketDataTypeHeader: [self processHeader:data socket:sock]; break;
        case SocketDataTypeData  : [self processBuffer:data socket:sock]; break;
    }
}

- (void)processHeader:(NSData*)data socket:(GCDAsyncSocket*)socket {
    if (data && socket) {
        Buffer tmp = {
                        Invalid,
                        (TPointer*)data.bytes,
                        (TSize    )data.length,
                        0
                     };
        _serverBuffer = createBufferFromHeader(&tmp);
        
        /* if created and data available, wait for data */
        if (_serverBuffer && _serverBuffer->size > 0) {
            [socket readDataToLength:_serverBuffer->size
                         withTimeout:-1
                                 tag:SocketDataTypeData];
        }
        /* else wait for header again */
        else {
            [socket readDataToLength:headerSize()
                         withTimeout:-1
                                 tag:SocketDataTypeHeader];
        }
    }
}
    
- (void)processBuffer:(NSData*)data socket:(GCDAsyncSocket*)socket  {
    if (data) {
        if (_serverBuffer && data.length == _serverBuffer->size) {
            memmove(_serverBuffer->data, data.bytes, _serverBuffer->size);
            
            /* notify delegate */
            if (_delegate && [_delegate respondsToSelector:@selector(communication:didReceiveData:)]) {
                [_delegate communication:self didReceiveData:_serverBuffer];
            }
        }
        
        /* clear buffer */
        _serverBuffer = clearBuffer(_serverBuffer);
    }
    
    /* wait for header again */
    if (socket) {
        [socket readDataToLength:headerSize()
                     withTimeout:-1
                             tag:SocketDataTypeHeader];
    }
}




@end
