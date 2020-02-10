//
//  RMCStatus.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCStatus.h"
#import "mstatus.h"

@implementation RMCStatus

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _act  = nil;
        _play = NO;
        _dura = 0;
        _pos  = 0;
        _vol  = 0;
    }
    
    return self;
}

- (instancetype)initWithBuffer:(Buffer*)buffer {
    self = [self init];
    
    if (self && buffer && buffer->mode == Status) {
        StatusContainer *cont = readStatusContainerFromBuffer(buffer);
        if (cont) {
            if (cont->act) {
                _act  = [NSString stringWithUTF8String:cont->act];
                _play = cont->play;
                _dura = cont->dura;
                _pos  = cont->pos;
                _vol  = cont->vol;
            }
            
            clearStatusContainer(cont);
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:  _act   forKey:@"act" ];
    [aCoder encodeObject:@(_play) forKey:@"play"];
    [aCoder encodeObject:@(_dura) forKey:@"dura"];
    [aCoder encodeObject:@(_pos ) forKey:@"pos" ];
    [aCoder encodeObject:@(_vol ) forKey:@"vol" ];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _act  = [aDecoder decodeObjectForKey:@"act" ];
        _play = ((NSNumber*)[aDecoder decodeObjectForKey:@"play"]).boolValue;
        _dura = ((NSNumber*)[aDecoder decodeObjectForKey:@"dura"]).intValue;
        _pos  = ((NSNumber*)[aDecoder decodeObjectForKey:@"pos" ]).intValue;
        _vol  = ((NSNumber*)[aDecoder decodeObjectForKey:@"vol" ]).intValue;
    }
    
    return self;
}

@end

@implementation RMCStatus(Buffer)

- (Buffer*)buffer {
    Buffer *out = 0;
    
    if (_act) {
        /* set data*/
        StatusContainer *cont = createStatusContainer();
        cont->act  = strdup(_act.UTF8String);
        cont->play = _play;
        cont->dura = _dura;
        cont->pos  = _pos;
        cont->vol  = _vol;
        
        /* write to buffer */
        out = writeStatusContainerToBuffer(cont);
        
        /* cleanup */
        cont = clearStatusContainer(cont);
    }
    
    return out;
}

@end
