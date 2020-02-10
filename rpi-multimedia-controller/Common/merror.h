//
//  MError.h
//  RPIMultimediaController
//
//  Created by Zoltan Meszaros on 1/27/15.
//  Copyright (c) 2015 Zoltan Meszaros. All rights reserved.
//

#ifndef __RPIMultimediaController__MError__
#define __RPIMultimediaController__MError__

#include "mcommon.h"

typedef struct ErrorContainer {
    char *message;
} ErrorContainer;

ErrorContainer* readErrorContainerFromBuffer(Buffer *buffer);
Buffer* writeErrorContainerToBuffer(ErrorContainer *cont);

ErrorContainer* createErrorContainer();
ErrorContainer* clearErrorContainer(ErrorContainer *cont);
ErrorContainer* copyErrorContainer(const ErrorContainer* const cont);

#ifdef QT
#include <QMetaType>
Q_DECLARE_METATYPE(ErrorContainer);
#endif

#endif /* defined(__RPIMultimediaController__MError__) */
