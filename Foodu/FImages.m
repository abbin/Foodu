//
//  FImages.m
//  Foodu
//
//  Created by Abbin Varghese on 09/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FImages.h"
#import "PFObject+Subclass.h"

@implementation FImages

@dynamic thumbnail1x;
@dynamic thumbnail2x;
@dynamic itemImage;

+(void)load{
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"images";
}

@end
