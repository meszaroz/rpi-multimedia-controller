//
//  MBuffer.c
//  RPIMultimediaController
//
//  Created by Zoltan Meszaros on 1/17/15.
//  Copyright (c) 2015 Zoltan Meszaros. All rights reserved.
//

#include "mbuffer.h"

bool canExtractDataWithSize(const Buffer* const buffer, const TSize size) {
    return buffer && buffer->pos + size <= buffer->size;
}

bool isBufferValid(const Buffer* const buffer) {
    return buffer
       && (   ( buffer->data &&  buffer->size)
           || (!buffer->data && !buffer->size));
}

bool isBufferAtBeginning(const Buffer* const buffer) {
    return !isBufferValid(buffer) || buffer->pos == 0;
}

bool isBufferAtEnd(const Buffer* const buffer) {
    return  isBufferValid(buffer) && buffer->size == buffer->pos;
}

TPointer* dataAtBufferPos(Buffer* buffer) {
    return buffer && buffer->data ? buffer->data + buffer->pos : 0;
}

void moveBufferPos(Buffer *buffer, const TPos offset) {
    // can read past end
    if (buffer && offset > 0) {
        buffer->pos += offset;
    }
}

void initBuffer(Buffer *buffer) {
    if (buffer) {
        buffer->data = 0;
        resetBuffer(buffer);
    }
}

void resetBuffer(Buffer *buffer) {
    if (buffer) {
        buffer->mode = Invalid;
        buffer->size = 0;
        rewindBuffer(buffer);
    }
}

void rewindBuffer(Buffer *buffer) {
    if (buffer) {
        buffer->pos = 0;
    }
}

static bool createData(Buffer *buffer, const TSize size) {
    bool out = buffer != 0;
    if (out && size > 0) {
        buffer->data = (TPointer*)calloc(size,sizeof(TPointer));
        out = buffer->data != 0;
        if (out) {
            resetBuffer(buffer);
            buffer->size = size;
        }
    }
    return out;
}

Buffer* createBuffer(const EMode mode, const TSize size) {
    Buffer *out = (Buffer*)malloc(sizeof(Buffer));
    if (out) {
        initBuffer(out);

        if (!createData(out,size)) {
            free(out);
            out = 0;
        }

        if (out) {
            out->mode = mode;
        }
    }
    return out;
}

static void clearData(Buffer *buffer) {
    if (buffer) {
        if (buffer->data) {
            free(buffer->data);
            buffer->data = 0;
        }
        resetBuffer(buffer);
    }
}

Buffer* clearBuffer(Buffer *buffer) {
    if (buffer) {
        clearData(buffer);
        free(buffer);
        buffer = 0;
    }
    return buffer;
}
