//
//  MZProxyItem.h
//  qboard
//
//  Created by Zoltan Meszaros on 2017. 07. 11..
//  Copyright © 2017. Zoltan Meszaros. All rights reserved.
//

#import "MZMutableArray.h"
#import "MZProxyItemProtocol.h"

@interface MZProxyItem : NSObject <MZMutableArrayDelegate, MZProxyItemProtocol>

/* identification and custom data */
@property (strong, nonatomic) NSString *name;

/* input and output - input.output is filtered/sorted and set as output */
@property (weak  , nonatomic          ) MZProxyItem *input; /* weak: input from parent proxy item, root has no input */
@property (strong, nonatomic, readonly) NSArray     *output;

/* chain descendent items - uses output of parent to filter/sort further
* Note: new items can be added by calling addObject on _items */
@property (strong, nonatomic, readonly) MZMutableArray *items;

/* filter/sort functions */
@property (strong, nonatomic) NSPredicate  *predicate; /* can be overridden */
@property (strong, nonatomic) NSComparator comparator; /* can be overridden */

+ (instancetype)itemWithName:(NSString*)name
                       input:(MZProxyItem*)input
                   predicate:(NSPredicate*)predicate
                  comparator:(NSComparator)comparator;
- (instancetype)initWithName:(NSString*)name
                       input:(MZProxyItem*)input
                   predicate:(NSPredicate*)predicate
                  comparator:(NSComparator)comparator;

- (void)invalidate;

@end

@interface MZProxyItem(Convenience)

+ (instancetype)itemWithName:(NSString*)name
                   predicate:(NSPredicate*)predicate
                  comparator:(NSComparator)comparator;

@end

/* wrapper */
@interface MZProxyItemWrapper : NSObject

@property (strong, nonatomic) MZProxyItem *item;
@property (strong, nonatomic) MZProxyItem *activeItem;

- (instancetype)initWithItem:(MZProxyItem*)item;

@end

@class MZProxy;

@interface MZProxyItemWrapper(Proxy)

@property (strong, nonatomic, readonly) MZProxy *proxy;
@property (strong, nonatomic, readonly) NSArray *output;
@property (strong, nonatomic, readonly) NSString *activeName;

- (void)setActiveItemWithName:(NSString*)name;
- (void)setActiveItemAtIndex:(NSInteger)index;

@end


