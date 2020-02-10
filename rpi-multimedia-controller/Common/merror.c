//
//  MError.c
//  RPIMultimediaController
//
//  Created by Zoltan Meszaros on 1/27/15.
//  Copyright (c) 2015 Zoltan Meszaros. All rights reserved.
//

#include "merror.h"

static void initErrorContainer(ErrorContainer *cont) {
    if (cont) {
        cont->message = 0;
    }
}

static void clearError(ErrorContainer *cont) {
    if (cont) {
        free(cont->message);
    }
    initErrorContainer(cont);
}

static TSize containerSize(const ErrorContainer* const cont) {
    TSize out = 0;
    if (cont) {
        out += cont->message ? strlen(cont->message) + 1 : sizeof(char);
    }
    return out;
}

static bool writeDataToBuffer(Buffer *buffer, ErrorContainer *cont) {
    bool out = buffer && cont && isBufferAtBeginning(buffer);
    if (out) {
        out = writeDataString(buffer, cont->message ? cont->message : cont->message) && out;
    }
    return out;
}

ErrorContainer* readErrorContainerFromBuffer(Buffer *buffer) {
    ErrorContainer *out = buffer && isBufferAtBeginning(buffer) ?
       createErrorContainer() :
       0;
    if (out) {
        out->message = readDataString(buffer);
    }
    return out;
}

Buffer* writeErrorContainerToBuffer(ErrorContainer *cont) {
    Buffer *out = 0;
    TSize size = containerSize(cont);
    out = createBuffer(Status,size);
    if (out) {
        writeDataToBuffer(out,cont);
    }
    return out;
}

ErrorContainer* clearErrorContainer(ErrorContainer *cont) {
    if (cont) {
        clearError(cont);
        free(cont);
        cont = 0;
    }
    return cont;
}

ErrorContainer* createErrorContainer() {
    ErrorContainer *out = (ErrorContainer*)malloc(sizeof(ErrorContainer));
    if (out) {
        initErrorContainer(out);
    }
    return out;
}

ErrorContainer* copyErrorContainer(const ErrorContainer* const cont) {
    ErrorContainer *out = cont ?
        createErrorContainer() :
        0;
    if (out) {
        copyString(&out->message,cont->message);
    }
    return out;
}
