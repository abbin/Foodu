//
//  NSIndexSet+NSIndexSet_Convenience.m
//  Save
//
//  Created by Abbin on 03/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

@import UIKit;
#import "NSIndexSet+NSIndexSet_Convenience.h"

@implementation NSIndexSet (NSIndexSet_Convenience)

- (NSArray *)aapl_indexPathsFromIndexesWithSection:(NSUInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}

@end
