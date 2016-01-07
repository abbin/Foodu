//
//  UIColor+FColours.m
//  Foodu
//
//  Created by Abbin on 07/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "UIColor+FColours.h"

@implementation UIColor (FColours)


+ (UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(UIColor *)blueJeans{
    return [UIColor colorFromHexString:@"#4A89DC"];
}

+(UIColor *)grapeFruit{
    return [UIColor colorFromHexString:@"#DA4453"];
}

+(UIColor *)bitterSweet{
    return [UIColor colorFromHexString:@"#E9573F"];
}

+(UIColor *)sunFlower{
    return [UIColor colorFromHexString:@"#F6BB42"];
}

+(UIColor *)grass{
    return [UIColor colorFromHexString:@"#8CC152"];
}

+(UIColor *)mint{
    return [UIColor colorFromHexString:@"#37BC9B"];
}

+(UIColor *)aqua{
    return [UIColor colorFromHexString:@"#3BAFDA"];
}

+(UIColor *)pinkRose{
    return [UIColor colorFromHexString:@"#D770AD"];
}

+(UIColor *)lavender{
    return [UIColor colorFromHexString:@"#967ADC"];
}

+(UIColor *)randomColour{
    int rand = [self randomFloatBetween:0 and:9];
    switch (rand) {
        case 0:
            return [UIColor grapeFruit];
            break;
        case 1:
            return [UIColor bitterSweet];
            break;
        case 2:
            return [UIColor sunFlower];
            break;
        case 3:
            return [UIColor grass];
            break;
        case 4:
            return [UIColor mint];
            break;
        case 5:
            return [UIColor aqua];
            break;
        case 6:
            return [UIColor blueJeans];
            break;
        case 7:
            return [UIColor lavender];
            break;
        case 8:
            return [UIColor pinkRose];
            break;
            
        default:
            return nil;
            break;
    }
}

+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}



@end
