//
//  MZMutableArray_p.h
//  qboard
//
//  Created by Zoltan Meszaros on 2017. 07. 11..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import "MZMutableArray.h"

@interface MZMutableArray<ObjectType>(Private)

@property (strong, nonatomic, nonnull) NSMutableArray *data;

- (void)initialize;
- (BOOL)handleChange;

@end
