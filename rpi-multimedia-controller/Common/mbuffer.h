//
//  MBuffer.h
//  RPIMultimediaController
//
//  Created by Zoltan Meszaros on 1/17/15.
//  Copyright (c) 2015 Zoltan Meszaros. All rights reserved.
//

#ifndef RPIMultimediaController_MBuffer_h
#define RPIMultimediaController_MBuffer_h

#include "mtypes.h"

typedef enum EMode {
    Kill,
    List,
    Status,
    Image,
    Check,
    Error,
    Invalid
} EMode;

typedef struct Buffer {
    EMode    mode;
    uint8_t *data;
    uint32_t size;
    uint32_t pos;
} Buffer;

bool canExtractDataWithSize(const Buffer* const buffer, const TSize size);
bool isBufferValid(const Buffer* const buffer);
bool isBufferAtBeginning(const Buffer* const buffer);
bool isBufferAtEnd(const Buffer* const buffer);
TPointer* dataAtBufferPos(Buffer *buffer);
void moveBufferPos(Buffer *buffer, const TPos offset);
void initBuffer(Buffer *buffer);
void resetBuffer(Buffer *buffer);
void rewindBuffer(Buffer *buffer);
Buffer* createBuffer(const EMode mode, const TSize size);
Buffer* clearBuffer(Buffer *buffer);

#endif
