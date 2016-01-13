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

@property(nonatomic ,strong) PFFile *itemImage;
@property(nonatomic ,strong) PFFile *iOS3X;
@property(nonatomic ,strong) PFFile *iOS2X;
@property(nonatomic ,strong) PFFile *android3X;
@property(nonatomic ,strong) PFFile *android2X;

@end
