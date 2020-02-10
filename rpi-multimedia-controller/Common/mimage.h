//
//  MImage.h
//  RPIMultimediaController
//
//  Created by Zoltan Meszaros on 1/18/15.
//  Copyright (c) 2015 Zoltan Meszaros. All rights reserved.
//

#ifndef __RPIMultimediaController__MImage__
#define __RPIMultimediaController__MImage__

#include "mcommon.h"

typedef struct ImageContainer {
    char     *name;
    TDim      width;
    TDim      height;
    TPointer *image;
    TSize     size;
} ImageContainer;

ImageContainer* readImageContainerFromBuffer(Buffer *buffer);
Buffer* writeImageContainerToBuffer(ImageContainer *cont);

ImageContainer* createImageContainer(const char* const name, const TSize size);
ImageContainer* clearImageContainer(ImageContainer *cont);
ImageContainer* copyImageContainer(const ImageContainer* const cont);

#ifdef QT
#include <QMetaType>
Q_DECLARE_METATYPE(ImageContainer);
#endif

#endif /* defined(__RPIMultimediaController__MImage__) */
