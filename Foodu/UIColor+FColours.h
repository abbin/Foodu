//
//  UIColor+FColours.h
//  Foodu
//
//  Created by Abbin on 07/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FColours)

+ (UIColor *) colorFromHexString:(NSString *)hexString;

+(UIColor*)PinRed;
+(UIColor*)HomeGreen;
+(UIColor*)ProfileBlue;
+(UIColor*)GeoListPink;
+(UIColor*)BookMarkBrown;
+(UIColor *)TableBackground;

@end
