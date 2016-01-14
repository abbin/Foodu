//
//  FItem.m
//  Foodu
//
//  Created by Abbin on 04/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FItem.h"
#import <PFObject+Subclass.h>

@implementation FItem

@dynamic itemTitle;
@dynamic itemDescription;
@dynamic restaurent;
@dynamic itemRating;
@dynamic itemImageArray;
@dynamic itemPrice;

+(void)load{
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"items";
}

@end
