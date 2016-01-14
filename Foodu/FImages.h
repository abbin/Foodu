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
@property(nonatomic ,strong) PFFile *thumbnail1x;
@property(nonatomic ,strong) PFFile *thumbnail2x;

@end
