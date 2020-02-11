//
//  MZProxyItem.h
//  qboard
//
//  Created by Zoltan Meszaros on 2017. 07. 11..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import "MZProxyItem.h"

@interface MZProxyItem(Private)

@property (strong, nonatomic) NSArray *output;

- (void)rebuildOutput;

@end

