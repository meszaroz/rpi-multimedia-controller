//
//  MImage.c
//  RPIMultimediaController
//
//  Created by Zoltan Meszaros on 1/18/15.
//  Copyright (c) 2015 Zoltan Meszaros. All rights reserved.
//

#include "mimage.h"

static TSize containerSize(const ImageContainer* const cont) {
    TSize out = 0;
    if (cont && cont->name) {
        out += strlen(cont->name  ) + 1;
        out += sizeof(cont->width );
        out += sizeof(cont->height);
        out += cont->size;
    }
    return out;
}

static bool writeDataToBuffer(Buffer *buffer, ImageContainer *cont) {
    bool out = buffer && cont && isBufferAtBeginning(buffer);
    if (out && cont->name) {
        out = writeDataString(buffer,cont->name)                                && out;
        out = writeDataWithSize(buffer,(TPointer*)(&cont->width ),sizeof(TDim)) && out;
        out = writeDataWithSize(buffer,(TPointer*)(&cont->height),sizeof(TDim)) && out;
        out = writeDataWithSize(buffer,cont->image,cont->size)                  && out;
    }
    return out;
}

static void initImageContainer(ImageContainer *cont) {
    if (cont) {
        cont->name   = 0;
        cont->image  = 0;
        cont->width  = 0;
        cont->height = 0;
        cont->size   = 0;
    }
}

static bool createImage(ImageContainer *cont, const TSize size) {
    bool out = cont != 0;
    if (out && size > 0) {
        cont->image = (TPointer*)calloc(size,sizeof(TPointer));
        out = cont->image;
        if (out) {
            cont->size = size;
        }
    }
    return out;
}

static void clearData(ImageContainer *cont) {
    if (cont) {
        free(cont->name );
        free(cont->image);
    }
    initImageContainer(cont);
}

ImageContainer* readImageContainerFromBuffer(Buffer *buffer) {
    ImageContainer *out = buffer && buffer->size > 0 && isBufferAtBeginning(buffer) ?
       createImageContainer(0,0) :
       0;
    if (out) {
        out->name   = readDataString(buffer);
        out->width  = readDataValue(buffer);
        out->height = readDataValue(buffer);
        out->size   = buffer->size-buffer->pos;
        out->image  = readDataWithSize(buffer,out->size);
    }
    return out;
}

Buffer* writeImageContainerToBuffer(ImageContainer *cont) {
    Buffer *out = 0;
    TSize size = containerSize(cont);
    out = createBuffer(Image, size);
    if (out) {
        writeDataToBuffer(out,cont);
    }
    return out;
}

ImageContainer* clearImageContainer(ImageContainer *cont) {
    if (cont) {
        clearData(cont);
        free(cont);
        cont = 0;
    }
    return cont;
}

ImageContainer* createImageContainer(const char* const name, const TSize size) {
    ImageContainer *out = (ImageContainer*)malloc(sizeof(ImageContainer));
    if (out) {
        initImageContainer(out);

        if (!createImage(out,size)) {
            free(out);
            out = 0;
        }

        if (out) {
            copyString(&out->name,name);
        }
    }
    return out;
}

ImageContainer* copyImageContainer(const ImageContainer* const cont) {
    ImageContainer *out = cont ?
        createImageContainer(cont->name,cont->size) :
        0;
    if (out) {
        out->width  = cont->width;
        out->height = cont->height;
        memmove(out->image,cont->image,cont->size);
    }
    return out;
}
