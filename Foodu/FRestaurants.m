//
//  FRestaurants.m
//  Foodu
//
//  Created by Abbin Varghese on 09/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FRestaurants.h"
#import "PFObject+Subclass.h"

@implementation FRestaurants

@dynamic name;
@dynamic location;
@dynamic phoneNumber;
@dynamic workingHours;
@dynamic address;

+(void)load{
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"restaurants";
}

@end
