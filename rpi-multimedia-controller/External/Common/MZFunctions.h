//
//  MZFunctions.h
//
//  Created by Zoltan Meszaros on 2017. 06. 12..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import <Foundation/Foundation.h>

void dispatch_main_sync(dispatch_block_t block);

void swizzleMethod(Class c, SEL orig, SEL other);
void swizzleClassMethod(Class c, SEL orig, SEL other);
