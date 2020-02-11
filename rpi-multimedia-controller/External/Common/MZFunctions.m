//
//  MZFunctions.m
//
//  Created by Zoltan Meszaros on 2017. 06. 12..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import "MZFunctions.h"

void dispatch_main_sync(dispatch_block_t block) {
    if (block) {
        if ([NSThread isMainThread]) {
            block();
        }
        else {
            dispatch_sync(dispatch_get_main_queue(),block);
        }
    }
}

#pragma mark - exchange methods
#import <objc/runtime.h>
#import <objc/message.h>

void swizzleMethod(Class c, SEL orig, SEL other) {
    Method origMethod  = class_getInstanceMethod(c, orig );
    Method otherMethod = class_getInstanceMethod(c, other);
    
    if(class_addMethod(c, orig, method_getImplementation(otherMethod), method_getTypeEncoding(otherMethod))) {
        class_replaceMethod(c, other, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else {
        method_exchangeImplementations(origMethod, otherMethod);
    }
}

void swizzleClassMethod(Class c, SEL orig, SEL other) {
    Method origMethod  = class_getClassMethod(c, orig );
    Method otherMethod = class_getClassMethod(c, other);
    
    c = object_getClass((id)c);
    
    if(class_addMethod(c, orig, method_getImplementation(otherMethod), method_getTypeEncoding(otherMethod))) {
        class_replaceMethod(c, other, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else {
        method_exchangeImplementations(origMethod, otherMethod);
    }
}
