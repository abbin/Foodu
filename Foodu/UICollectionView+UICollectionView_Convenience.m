//
//  UICollectionView+UICollectionView_Convenience.m
//  Save
//
//  Created by Abbin on 03/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "UICollectionView+UICollectionView_Convenience.h"

@implementation UICollectionView (UICollectionView_Convenience)

- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

@end
