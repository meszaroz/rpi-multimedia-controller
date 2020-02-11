//
//  MZProxyItemProtocol.h
//  MZProxy
//
//  Created by Zoltan Meszaros on 2019. 10. 03..
//

#import <Foundation/Foundation.h>

typedef NSComparisonResult (^NSComparator)(id, id);

@protocol MZProxyItemProtocol <NSObject>

/* input and output - input.output is filtered/sorted and set as output */
@property (weak  , nonatomic, readonly) id<MZProxyItemProtocol> input;
@property (strong, nonatomic, readonly) NSArray               *output;

/* filter/sort */
@property (strong, nonatomic          ) NSPredicate  *predicate;
@property (strong, nonatomic          ) NSComparator comparator; 

/* reset */
- (void)invalidate;

@end
