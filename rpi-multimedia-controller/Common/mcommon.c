//
//  MCommon.c
//  RPIMultimediaController
//
//  Created by Zoltan Meszaros on 1/17/15.
//  Copyright (c) 2015 Zoltan Meszaros. All rights reserved.
//

#include "mcommon.h"

TSize headerSize() {
    return sizeof(TMode)+sizeof(TSize);
}

Buffer* createBufferFromHeader(Buffer *buffer) {
    Buffer *out = 0;
    if (buffer && isBufferValid(buffer) && isBufferAtBeginning(buffer)) {
        EMode mode = readDataMode(buffer);
        TSize size = readDataSize(buffer);
        if (mode < Invalid) {
            out = createBuffer(mode,size);
        }
    }
    return out;
}

TPointer* bufferToStreamData(const Buffer* const buffer, TSize *size) {
    TPointer *out = buffer && size && isBufferValid(buffer) ?
        (TPointer*)calloc(headerSize() + buffer->size, sizeof(TPointer)) :
        0;

    if (out) {
        TPos tmpPos = 0; TSize tmpSize = 0;
        tmpSize = sizeof(TMode); if (tmpSize > 0) { memmove(out+tmpPos,(TPointer*)(&buffer->mode),tmpSize); tmpPos += tmpSize; }
        tmpSize = sizeof(TSize); if (tmpSize > 0) { memmove(out+tmpPos,(TPointer*)(&buffer->size),tmpSize); tmpPos += tmpSize; }
        tmpSize = buffer->size;  if (tmpSize > 0) { memmove(out+tmpPos,             buffer->data ,tmpSize); tmpPos += tmpSize; }
        *size = tmpPos;
    }

    return out;
}

EMode readDataMode(Buffer *buffer) {
    TGeneral tmp = readDataInt(buffer,sizeof(TMode));
    return tmp != -1 ? (EMode)tmp : Invalid;
}

TSize readDataSize(Buffer *buffer) {
    TGeneral tmp = readDataInt(buffer,sizeof(TSize));
    return tmp != -1 ? (TSize)tmp : 0;
}

TPointer* readDataWithSizeAndAllocation(Buffer *buffer, const TSize size, const TSize alloc) {
    TPointer* out = 0;
    if (size > 0 && alloc >= size && canExtractDataWithSize(buffer,size)) {
        TPointer *tmp = dataAtBufferPos(buffer);
        if (tmp) {
            out = (TPointer*)calloc(alloc,sizeof(TPointer));
            if (out) {
                memmove(out,tmp,size);
            }
            moveBufferPos(buffer,size);
        }
    }
    return out;
}

TPointer* readDataWithSize(Buffer *buffer, const TSize size) {
    return readDataWithSizeAndAllocation(buffer,size,size);
}

bool writeDataWithSize(Buffer *buffer, const TPointer* const data, const TSize size) {
    bool out = buffer && data && canExtractDataWithSize(buffer,size);
    if (out) {
        TPointer *tmp = dataAtBufferPos(buffer);
        if (tmp && size > 0) {
            memmove(tmp,data,size);
            moveBufferPos(buffer,size);
        }
    }
    return out;
}

char* readDataString(Buffer *buffer) {
    char *out = 0;
    if (buffer) {
        char *tmp = (char*)dataAtBufferPos(buffer);
        if (tmp) {
            TSize size = (TSize)strlen(tmp) + 1; // include terminating string
            if (size > 1) {
                out = (char*)calloc(size,sizeof(char));
                if (out) {
                    memmove(out,tmp,size);
                }
                moveBufferPos(buffer,size);
            }
        }
    }
    return out;
}

bool writeDataString(Buffer *buffer, const char* const str) {
    bool out = buffer && str;
    if (out) {
        TSize size = (TSize)strlen(str) + 1; // include terminating string
        out = size > 1 && canExtractDataWithSize(buffer,size);
        if (out) {
            TPointer *tmp = dataAtBufferPos(buffer);
            if (tmp) {
                memmove(tmp,str,size);
                moveBufferPos(buffer,size);
            }
        }
    }
    return out;
}

TValue readDataValue(Buffer *buffer) {
    static const TSize size = sizeof(TValue);
    TDim out = 0;
    if (canExtractDataWithSize(buffer,size)) {
        TValue *tmp = (TValue*)(dataAtBufferPos(buffer));
        if (tmp) {
            out = *tmp;
            moveBufferPos(buffer,size);
        }
    }
    return out;
}

bool writeDataValue(Buffer *buffer, const TValue val) {
    static const TSize size = sizeof(TValue);
    bool out = buffer && canExtractDataWithSize(buffer,size);
    if (out) {
        TPointer* tmp = dataAtBufferPos(buffer);
        if (tmp) {
            memmove(tmp,(TPointer*)(&val),size);
            moveBufferPos(buffer,size);
        }
    }
    return out;
}

TGeneral readDataInt(Buffer *buffer,const TSize size) {
    TGeneral out = -1;
    TPointer *tmp = readDataWithSizeAndAllocation(buffer,size,sizeof(TGeneral));
    if (tmp) {
        out = *(TGeneral*)tmp;
        free(tmp);
    }
    return out;
}

bool copyString(char** to, const char* const from) {
    bool out = from && to && !*to;
    if (out) {
        TSize size = (TSize)strlen(from) + 1;
        out = size > 0;
        if (out) {
            *to = (char*)calloc(size,sizeof(char));
            out = *to;
            if (out) {
                memmove(*to,from,size);
            }
        }
    }
    return out;
}
