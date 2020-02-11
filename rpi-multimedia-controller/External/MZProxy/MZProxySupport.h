//
//  MZProxySupport.h
//  MZProxy
//
//  Created by Zoltan Meszaros on 2018. 11. 23..
//

#import <Foundation/Foundation.h>

@interface NSArray (FilterSort)

/* general filter sort function */
+ (NSArray*)filteredSortedArray:(NSArray*)array
                  withPredicate:(NSPredicate*)predicate
                  andComparator:(NSComparator)comparator;

@end
