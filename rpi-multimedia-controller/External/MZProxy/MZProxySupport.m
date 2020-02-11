//
//  MZProxySupport.m
//  MZProxy
//
//  Created by Zoltan Meszaros on 2018. 11. 23..
//

#import "MZProxySupport.h"

@implementation NSArray (FilterSort)

+ (NSArray*)filteredSortedArray:(NSArray*)array
                  withPredicate:(NSPredicate*)predicate
                  andComparator:(NSComparator)comparator {
    NSArray *out = nil;
    
    if (array) {
        out = [array copy];
        if (predicate ) { out = [out filteredArrayUsingPredicate:predicate ]; }
        if (comparator) { out = [out sortedArrayUsingComparator :comparator]; }
    }
    
    return out;
}

@end
