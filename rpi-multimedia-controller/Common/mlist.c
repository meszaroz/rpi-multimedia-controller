//
//  MList.c
//  RPIMultimediaController
//
//  Created by Zoltan Meszaros on 1/24/15.
//  Copyright (c) 2015 Zoltan Meszaros. All rights reserved.
//

#include "mlist.h"

static void initListContainer(ListContainer *cont) {
    if (cont != 0) {
        cont->list  = 0;
        cont->count = 0;
    }
}

static bool createList(ListContainer *cont, const TSize count) {
    bool out = cont != 0; // isInit
    if (out && count > 0) {
        cont->list = (char**)malloc(count*sizeof(char*));
        out = cont->list;
        if (out) {
            for (TSize i = 0; i < count; ++i) {
                cont->list[i] = 0;
            }
            cont->count = count;
        }
    }
    return out;
}

static void clearList(ListContainer *cont) {
    if (cont && cont->list) {
        for (TSize i = 0; i < cont->count; ++i) {
            free(cont->list[i]);
        }
        free(cont->list);
    }
    initListContainer(cont);
}

static TSize containerSize(const ListContainer* const cont) {
    TSize out = 0;
    if (cont && cont->count > 0 && cont->list) {
        out = sizeof(TSize);
        for (TSize i = 0; i < cont->count; ++i) {
            out += cont->list[i] ? strlen(cont->list[i]) + 1 : 0;
        }
    }
    return out;
}

static bool writeDataToBuffer(Buffer *buffer, ListContainer *cont) {
    bool out = buffer && cont && isBufferAtBeginning(buffer);
    if (out && cont->count > 0 && cont->list) {
        out = writeDataWithSize(buffer,(TPointer*)(&cont->count),sizeof(TSize)) && out;
        for (TSize i = 0; i < cont->count; ++i) {
            out = writeDataString(buffer,cont->list[i]) && out;
        }
    }
    return out;
}

ListContainer* readListContainerFromBuffer(Buffer *buffer) {
    ListContainer *out = canExtractDataWithSize(buffer,sizeof(TSize)) && isBufferAtBeginning(buffer) ?
       createListContainer(readDataSize(buffer)) :
       0;
    if (out) {
        TPos pos = 0;
        while (!isBufferAtEnd(buffer)) {
            char *tmp = readDataString(buffer);
            out->list[pos++] = tmp ? tmp : 0;
        }
    }
    return out;
}

Buffer* writeListContainerToBuffer(ListContainer *cont) {
    Buffer *out = 0;
    TSize size = containerSize(cont);
    out = createBuffer(List,size);
    if (out) {
        writeDataToBuffer(out,cont);
    }
    return out;
}

ListContainer* clearListContainer(ListContainer *cont)
{
    if (cont) {
        clearList(cont);
        free(cont);
        cont = 0;
    }
    return cont;
}

ListContainer* createListContainer(const TSize count) {
    ListContainer *out = (ListContainer*)malloc(sizeof(ListContainer));
    if (out) {
        initListContainer(out);

        // if size is 0 leave data as 0 pointer (without data)
        if (!createList(out,count)) {
            free(out);
            out = 0;
        }
    }
    return out;
}

ListContainer* copyListContainer(const ListContainer* const cont) {
    ListContainer *out = cont ?
        createListContainer(cont->count) :
        0;
    if (out) {
        for (TPos i = 0; i < cont->count; ++i) {
            copyString(&out->list[i],cont->list[i]);
        }
    }
    return out;
}
