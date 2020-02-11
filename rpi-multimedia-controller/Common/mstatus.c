//
//  MStatus.c
//  RPIMultimediaController
//
//  Created by Zoltan Meszaros on 1/27/15.
//  Copyright (c) 2015 Zoltan Meszaros. All rights reserved.
//

#include "mstatus.h"

static void initStatusContainer(StatusContainer *cont) {
    if (cont) {
        cont->act  = 0;
        cont->play = 0;
        cont->dura =-1;
        cont->pos  =-1;
        cont->vol  =-1;
    }
}

static void clearStatus(StatusContainer *cont) {
    if (cont) {
        free(cont->act);
    }
    initStatusContainer(cont);
}

/* if no actual file, size is 0 */
static TSize containerSize(const StatusContainer* const cont) {
    TSize out = 0;
    if (cont && cont->act) {
        out += strlen(cont->act ) + 1;
        out += sizeof(cont->play);
        out += sizeof(cont->dura);
        out += sizeof(cont->pos );
        out += sizeof(cont->vol );
    }
    return out;
}

static bool writeDataToBuffer(Buffer *buffer, StatusContainer *cont) {
    bool out = buffer && cont && isBufferAtBeginning(buffer);
    if (out && cont->act) {
        out = writeDataString(buffer, cont->act) && out;
        out = writeDataWithSize(buffer,(TPointer*)(&cont->play),sizeof(TBool    )) && out;
        out = writeDataWithSize(buffer,(TPointer*)(&cont->dura),sizeof(TDuration)) && out;
        out = writeDataWithSize(buffer,(TPointer*)(&cont->pos ),sizeof(TSeek    )) && out;
        out = writeDataWithSize(buffer,(TPointer*)(&cont->vol ),sizeof(TVolume  )) && out;
    }
    return out;
}

StatusContainer* readStatusContainerFromBuffer(Buffer *buffer) {
    StatusContainer *out = buffer && isBufferAtBeginning(buffer) ?
       createStatusContainer() :
       0;
    if (out) {
        out->act  = readDataString(buffer);
        out->play = (TBool    )readDataInt(buffer,sizeof(TBool    ));
        out->dura = (TDuration)readDataInt(buffer,sizeof(TDuration));
        out->pos  = (TSeek    )readDataInt(buffer,sizeof(TSeek    ));
        out->vol  = (TVolume  )readDataInt(buffer,sizeof(TVolume  ));
    }
    return out;
}

Buffer* writeStatusContainerToBuffer(StatusContainer *cont) {
    Buffer *out = 0;
    TSize size = containerSize(cont);
    out = createBuffer(Status,size);
    if (out) {
        writeDataToBuffer(out,cont);
    }
    return out;
}

StatusContainer* clearStatusContainer(StatusContainer *cont) {
    if (cont) {
        clearStatus(cont);
        free(cont);
        cont = 0;
    }
    return cont;
}

StatusContainer* createStatusContainer() {
    StatusContainer *out = (StatusContainer*)malloc(sizeof(StatusContainer));
    if (out) {
        initStatusContainer(out);
    }
    return out;
}

StatusContainer* copyStatusContainer(const StatusContainer* const cont) {
    StatusContainer *out = cont ?
        createStatusContainer() :
        0;
    if (out) {
        out->play = cont->play;
        out->dura = cont->dura;
        out->pos  = cont->pos;
        out->vol  = cont->vol;
        copyString(&out->act,cont->act);
    }
    return out;
}
