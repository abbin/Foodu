//
//  FImages.h
//  Foodu
//
//  Created by Abbin Varghese on 09/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <Parse/Parse.h>

@interface FImages : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property(nonatomic ,strong) NSArray *iOS3X;
@property(nonatomic ,strong) NSArray *iOS2X;
@property(nonatomic ,strong) NSArray *android3X;
@property(nonatomic ,strong) NSArray *android2X;
@property(nonatomic, strong) PFFile *thumbNail2x;
@property(nonatomic, strong) PFFile *thumbNail3x;

@end
