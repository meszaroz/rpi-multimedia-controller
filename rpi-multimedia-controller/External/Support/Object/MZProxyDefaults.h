//
//  MZProxyDefaults.h
//  qboard
//
//  Created by Zoltan Meszaros on 2019. 04. 09..
//  Copyright © 2019. Zoltan Meszaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZProxyFilters : NSObject

+ (BOOL)defaultFilterString:(NSString*)string withKey:(NSString*)key;

@end

@interface MZProxyCompares : NSObject

+ (NSComparisonResult)defaultCompareString:(NSString*)string1 withString:(NSString*)string2;

@end

