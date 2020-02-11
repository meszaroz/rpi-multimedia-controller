//
//  RMCStatus.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCStatus.h"
#import "mstatus.h"

static NSString * const kActKey  = @"act";
static NSString * const kPlayKey = @"play";
static NSString * const kDuraKey = @"dura";
static NSString * const kPosKey  = @"pos";
static NSString * const kVolKey  = @"vol";

@implementation RMCStatus

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithAct:(nullable NSString*)act play:(BOOL)play dura:(NSInteger)dura pos:(NSInteger)pos vol:(NSInteger)vol {
    self = [super init];
    
    if (self) {
        _act  = act;
        _play = play;
        _dura = dura;
        _pos  = pos;
        _vol  = vol;
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithAct:nil play:NO dura:0 pos:0 vol:0];
}

- (instancetype)initWithBuffer:(Buffer*)buffer {
    self = [self init];
    
    if (self) {
        self.buffer = buffer;
    }
    
    return self;
}

- (BOOL)isValid {
    return _act && _act.length > 0;
}

#pragma mark - Secure Coder Protocol
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:  _act   forKey:kActKey ];
    [aCoder encodeObject:@(_play) forKey:kPlayKey];
    [aCoder encodeObject:@(_dura) forKey:kDuraKey];
    [aCoder encodeObject:@(_pos ) forKey:kPosKey ];
    [aCoder encodeObject:@(_vol ) forKey:kVolKey ];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _act  = [aDecoder decodeObjectForKey:kActKey];
        _play = ((NSNumber*)[aDecoder decodeObjectForKey:kPlayKey]).boolValue;
        _dura = ((NSNumber*)[aDecoder decodeObjectForKey:kDuraKey]).intValue;
        _pos  = ((NSNumber*)[aDecoder decodeObjectForKey:kPosKey ]).intValue;
        _vol  = ((NSNumber*)[aDecoder decodeObjectForKey:kVolKey ]).intValue;
    }
    
    return self;
}

#pragma mark - Buffer Protocol
- (BOOL)setBuffer:(Buffer *)buffer {
    BOOL out = buffer && buffer->mode == Status;
    
    if (out) {
        StatusContainer *cont = readStatusContainerFromBuffer(buffer);
        
        if (out) {
            _act  = cont->act ? [NSString stringWithUTF8String:cont->act] : 0;
            _play = cont->play;
            _dura = cont->dura;
            _pos  = cont->pos;
            _vol  = cont->vol;
        }
            
        clearStatusContainer(cont);
    }
    
    return out;
}

- (Buffer*)buffer {
    Buffer *out = 0;
    
    /* set data */
    StatusContainer *cont = createStatusContainer();
    if (cont) {
        if (_act) {
            copyString(&cont->act, _act.UTF8String);
            cont->play = _play;
            cont->dura = _dura;
            cont->pos  = _pos;
            cont->vol  = _vol;
        }
            
        /* write to buffer */
        out = writeStatusContainerToBuffer(cont);
        
        /* cleanup */
        cont = clearStatusContainer(cont);
    }
    
    return out;
}

@end

