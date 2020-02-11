//
//  MZProxyDefaults.m
//  qboard
//
//  Created by Zoltan Meszaros on 2019. 04. 09..
//  Copyright © 2019. Zoltan Meszaros. All rights reserved.
//

#import "MZProxyDefaults.h"

@implementation MZProxyFilters

+ (BOOL)defaultFilterString:(NSString*)string withKey:(NSString*)key {
    if (string && key) {
        NSArray *filters = key ?
            [key componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceCharacterSet] :
            nil;
        
        for (NSString *filter in filters) {
            if (filter.length > 0 && ![string.lowercaseString containsString:filter.lowercaseString]) {
                return NO;
            }
        }
    }
    
    return YES;
}

@end

@implementation MZProxyCompares

+ (NSComparisonResult)defaultCompareString:(NSString*)string1 withString:(NSString*)string2 {
    return [string1 compare:string2];
}

@end
