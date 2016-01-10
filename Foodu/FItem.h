//
//  FItem.h
//  Foodu
//
//  Created by Abbin on 04/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <Parse/Parse.h>

@interface FItem : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic,strong) NSString *itemTitle;
@property (nonatomic,strong) NSString *itemDescription;
@property (nonatomic,strong) NSString *itemAddress;
@property (nonatomic,strong) FRestaurants *restaurent;
@property (nonatomic,strong) NSNumber *itemRating;
@property (nonatomic,strong) FImages *itemImage;
@property (nonatomic,strong) NSNumber *itemPrice;
@property(nonatomic, strong) PFFile *thumbNail2x;
@property(nonatomic, strong) PFFile *thumbNail3x;

@end
