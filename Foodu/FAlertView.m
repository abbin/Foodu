//
//  FAlertView.m
//  Foodu
//
//  Created by Abbin on 04/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FAlertView.h"

@interface FAlertView ()

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,assign) BOOL shown;
@property(nonatomic,weak) UIActivityIndicatorView *activityIndicator;
@end


@implementation FAlertView

static FAlertView *sharedHUD = nil;

+ (FAlertView*)sharedHUD {
    if (sharedHUD == nil) {
        sharedHUD = [[FAlertView alloc]init];
    }
    return sharedHUD;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 0, 0)];
        self.titleLabel.textColor = [UIColor whiteColor];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.frame = CGRectMake(10, 7, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
        activityIndicator.hidesWhenStopped = YES;
        self.activityIndicator = activityIndicator;
        [self addSubview:self.activityIndicator];
        
        self.backgroundColor = [UIColor PinRed];
        NSString *textfont = @"";
        if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
            textfont = @".SFUIText-Light";
        }
        else{
            textfont = @".HelveticaNeueInterface-UltraLightP2";
        }
        self.titleLabel.font = [UIFont fontWithName:textfont size:[UIScreen mainScreen].bounds.size.height/50];
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(void)showActivityIndicatorOnView:(UIView*)view{

    if (self.shown == NO) {
        self.titleLabel.hidden = YES;
        [self.activityIndicator startAnimating];
        self.frame = CGRectMake(view.frame.size.width,
                                view.frame.size.height/15,
                                self.activityIndicator.frame.size.width+40,
                                self.activityIndicator.frame.size.height+15);
        
        
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = YES;
        
        [view addSubview:self];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake(self.frame.origin.x-self.frame.size.width+20, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            self.shown = YES;
        }];
    }
    else{
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            self.shown = NO;
            [self removeFromSuperview];
            [self showActivityIndicatorOnView:view];
        }];

    }
}

-(void)hideActivityIndicatorOnView{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.shown = NO;
        [self.activityIndicator stopAnimating];
        [self removeFromSuperview];
    }];
}

-(void)showHUDOnView:(UIView*)view withText:(NSString*)text wait:(NSInteger)time{
    self.titleLabel.hidden = NO;
    [self.activityIndicator stopAnimating];
    
    if (self.shown == NO) {
        self.titleLabel.text = text;
        [self.titleLabel sizeToFit];
        self.frame = CGRectMake(view.frame.size.width,
                                view.frame.size.height/15,
                                self.titleLabel.frame.size.width+40,
                                self.titleLabel.frame.size.height+15);
        
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = YES;
        
        [view addSubview:self];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake(self.frame.origin.x-self.frame.size.width+20, self.frame.origin.y, self.titleLabel.frame.size.width+40, self.titleLabel.frame.size.height+14);
        } completion:^(BOOL finished) {
            self.shown = YES;
            if (time>0) {
                [self hideHUDWithText:text wait:time];
            }
        }];
    }
    else{
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            self.shown = NO;
            [self removeFromSuperview];
            [self showHUDOnView:view withText:text wait:time];
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
        self.shown = NO;
        [self removeFromSuperview];
    }];
    
}


@end
