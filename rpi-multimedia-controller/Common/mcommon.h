//
//  MCommon.h
//  RPIMultimediaController
//
//  Created by Zoltan Meszaros on 1/17/15.
//  Copyright (c) 2015 Zoltan Meszaros. All rights reserved.
//

#ifndef RPIMultimediaController_MCommon_h
#define RPIMultimediaController_MCommon_h

#include "mbuffer.h"

TSize headerSize();

Buffer* createBufferFromHeader(Buffer *buffer);
TPointer* bufferToStreamData(const Buffer* const buffer, TSize *size);

EMode readDataMode(Buffer *buffer);
TSize readDataSize(Buffer *buffer);
TPointer* readDataWithSizeAndAllocation(Buffer *buffer, const TSize size, const TSize alloc);
TPointer* readDataWithSize(Buffer *buffer, const TSize size);
bool writeDataWithSize(Buffer *buffer, const TPointer* const data, const TSize size);
char* readDataString(Buffer *buffer);
bool writeDataString(Buffer *buffer, const char* const str);
TDim readDataValue(Buffer *buffer);
bool writeDataValue(Buffer *buffer, const TDim val);
TGeneral readDataInt(Buffer *buffer,const TSize size);

bool copyString(char** to, const char* const from);

#endif
