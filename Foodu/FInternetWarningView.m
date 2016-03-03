//
//  FInternetWarningView.m
//  Foodu
//
//  Created by Abbin on 03/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FInternetWarningView.h"

@implementation FInternetWarningView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = frame.size.height/2;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = NO;
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, frame.size.width, frame.size.height)];
        self.label.text = @"No internet";
        self.label.textColor = [UIColor whiteColor];
        
        NSString *textfont = @"";
        if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
            textfont = @".SFUIText-Light";
        }
        else{
            textfont = @".HelveticaNeueInterface-UltraLightP2";
        }
        
        self.label.font = [UIFont fontWithName:textfont size:frame.size.height/2.5];
        [self addSubview:self.label];
    }
    return self;
}

@end