//
//  FHUD.m
//  Foodu
//
//  Created by Abbin on 03/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FHUD.h"

@implementation FHUD

-(instancetype)initWithView:(UIView*)view{
    self = [super init];
    if (self) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 0, 0)];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = [UIColor whiteColor];
        
        NSString *textfont = @"";
        if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
            textfont = @".SFUIText-Light";
        }
        else{
            textfont = @".HelveticaNeueInterface-UltraLightP2";
        }
        self.titleLabel.font = [UIFont fontWithName:textfont size:view.frame.size.height/50];
        [self.titleLabel sizeToFit];
        self.frame = CGRectMake(view.frame.size.width,
                                view.frame.size.height/15,
                                self.titleLabel.frame.size.width+50,
                                self.titleLabel.frame.size.height+15);
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = YES;
        [self addSubview:self.titleLabel];
    }
    [view addSubview:self];
    return self;
}

-(void)showHUDWithText:(NSString*)text{
    self.titleLabel.text = text;
    [self.titleLabel sizeToFit];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(self.center.x-self.titleLabel.frame.size.width-15, self.center.y);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideHUDWithText:(NSString*)text{
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    [self.titleLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];
    self.titleLabel.text = text;
    
    [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(self.center.x+self.titleLabel.frame.size.width+15, self.center.y);
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
