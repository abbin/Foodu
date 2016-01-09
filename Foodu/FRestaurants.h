//
//  FRestaurants.h
//  Foodu
//
//  Created by Abbin Varghese on 09/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <Parse/Parse.h>

@interface FRestaurants : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSMutableArray *phoneNumber;
@property (nonatomic, strong) NSMutableArray *workingHours;
@property (nonatomic, strong) NSString *address;

@end
