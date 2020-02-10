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
    if (_interface) {
        /* collect data */
        ListContainer *cont = createListContainer(0);
        Buffer *buffer = writeListContainerToBuffer(cont);
        
        /* send */
        [_interface writeData:buffer];
        
        /* cleanup */
        buffer = clearBuffer(buffer);
        cont   = clearListContainer(cont);
    }
}

- (void)requestImage:(RMCImage *)image {
    if (_interface && image && image.identifier && !image.image) {
        /* collect data */
        ImageContainer *cont = createImageContainer(image.identifier.UTF8String, 0);
        Buffer *buffer = writeImageContainerToBuffer(cont);
        
        /* send */
        [_interface writeData:buffer];
        
        /* cleanup */
        buffer = clearBuffer(buffer);
        cont   = clearImageContainer(cont);
    }
}

- (void)requestStatus {
    if (_interface) {
        /* collect data */
        StatusContainer *cont = createStatusContainer();
        Buffer *buffer = writeStatusContainerToBuffer(cont);
        
        /* send */
        [_interface writeData:buffer];
        
        /* cleanup */
        buffer = clearBuffer(buffer);
        cont   = clearStatusContainer(cont);
    }
}

- (void)sendStatus:(RMCStatus*)status {
    if (_interface && status) {
        /* collect data */
        Buffer *buffer = status.buffer;
        
        /* send */
        [_interface writeData:buffer];
        
        /* cleanup */
        buffer = clearBuffer(buffer);
    }
}

#pragma mark - Communication Delegate
- (void)communication:(RMCCommunication*)communication didConnectToHost:(NSString *)host port:(uint16_t)port {
    [self requestList  ];
    [self requestStatus];
}

- (void)communication:(RMCCommunication*)communication didDisconnectWithError:(nullable NSError *)err {
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

@end
