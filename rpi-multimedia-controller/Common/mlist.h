//
//  MList.h
//  RPIMultimediaController
//
//  Created by Zoltan Meszaros on 1/24/15.
//  Copyright (c) 2015 Zoltan Meszaros. All rights reserved.
//

#ifndef __RPIMultimediaController__MList__
#define __RPIMultimediaController__MList__

#include "mcommon.h"

typedef struct ListContainer {
    char **list;
    TSize  count;
} ListContainer;

ListContainer* readListContainerFromBuffer(Buffer *buffer);
Buffer* writeListContainerToBuffer(ListContainer *cont);

ListContainer* createListContainer(const TSize count);
ListContainer* clearListContainer(ListContainer *cont);
ListContainer* copyListContainer(const ListContainer* const cont);

#ifdef QT
#include <QMetaType>
Q_DECLARE_METATYPE(ListContainer);
#endif

#endif /* defined(__RPIMultimediaController__MList__) */
