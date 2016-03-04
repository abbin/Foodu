//
//  FAlertView.m
//  Foodu
//
//  Created by Abbin on 04/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FAlertView.h"

@implementation FAlertView

{
    BOOL shown;
}

-(instancetype)initWithView:(UIView*)view{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

    self = [super initWithEffect:blurEffect];
    if (self) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 0, 0)];
        self.titleLabel.textColor = [UIColor whiteColor];
        
        NSString *textfont = @"";
        if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
            textfont = @".SFUIText-Light";
        }
        else{
            textfont = @".HelveticaNeueInterface-UltraLightP2";
        }
        self.backgroundColor = [UIColor redColor];
        self.titleLabel.font = [UIFont fontWithName:textfont size:view.frame.size.height/50];
        [self.titleLabel sizeToFit];
        self.frame = CGRectMake(view.frame.size.width,
                                view.frame.size.height/15,
                                self.titleLabel.frame.size.width+50,
                                self.titleLabel.frame.size.height+15);
        [self addSubview:self.titleLabel];
    }
    [view addSubview:self];
    return self;
}

-(void)showHUDWithText:(NSString*)text wait:(NSInteger)time{
    if (shown == NO) {
        self.titleLabel.text = text;
        [self.titleLabel sizeToFit];
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.titleLabel.frame.size.width+40,
                                self.titleLabel.frame.size.height+14);
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = YES;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake(self.frame.origin.x-self.frame.size.width+20, self.frame.origin.y, self.titleLabel.frame.size.width+40, self.titleLabel.frame.size.height+14);
        } completion:^(BOOL finished) {
            shown = YES;
            if (time>0) {
                [self hideHUDWithText:text wait:time];
            }
        }];
    }
    else{
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            shown = NO;
            [self showHUDWithText:text wait:time];
        }];
    }
}

-(void)hideHUDWithText:(NSString*)text wait:(NSInteger)time;{
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    [self.titleLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];
    self.titleLabel.text = text;
    
    [self.titleLabel sizeToFit];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-self.titleLabel.frame.size.width-20,
                                self.frame.origin.y,
                                self.titleLabel.frame.size.width+40,
                                self.titleLabel.frame.size.height+14);
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = YES;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.3 delay:time options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        shown = NO;
    }];
    
}


@end
