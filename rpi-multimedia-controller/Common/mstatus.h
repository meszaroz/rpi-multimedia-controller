//
//  MStatus.h
//  RPIMultimediaController
//
//  Created by Zoltan Meszaros on 1/27/15.
//  Copyright (c) 2015 Zoltan Meszaros. All rights reserved.
//

#ifndef __RPIMultimediaController__MStatus__
#define __RPIMultimediaController__MStatus__

#include "mcommon.h"

typedef struct StatusContainer {
    char     *act;
    TBool     play;
    TDuration dura;
    TSeek     pos;
    TVolume   vol;
} StatusContainer;

StatusContainer* readStatusContainerFromBuffer(Buffer *buffer);
Buffer* writeStatusContainerToBuffer(StatusContainer *cont);

StatusContainer* createStatusContainer();
StatusContainer* clearStatusContainer(StatusContainer *cont);
StatusContainer* copyStatusContainer(const StatusContainer* const cont);

#ifdef QT
#include <QMetaType>
Q_DECLARE_METATYPE(StatusContainer);
#endif

#endif /* defined(__RPIMultimediaController__MStatus__) */
