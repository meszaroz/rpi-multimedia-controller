//
//  MZProxy.h
//  qboard
//
//  Created by Zoltan Meszaros on 2017. 07. 11..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZProxyItem.h"

@class MZMutableArray;
@class MZProxyItem;

@interface MZProxy : MZProxyItem

@property (strong, nonatomic) NSArray *model;
@property (strong, nonatomic) UIView  *view;

- (instancetype)initWithModel:(NSArray*)model andView:(UIView*)view;

/* root item: no input */
- (void) __unavailable setInput:(MZProxyItem *)input;

@end

@interface MZMutableProxy : MZProxy

@property (strong, nonatomic) MZMutableArray *mutableModel;

- (instancetype)initWithMutableModel:(MZMutableArray*)model andView:(UIView*)view;

@end
