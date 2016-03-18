//
//  FPageONEViewController.m
//  Foodu
//
//  Created by Abbin on 15/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FPageONEViewController.h"

@interface FPageONEViewController ()

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuudLabel;
@property (weak, nonatomic) IBOutlet UIButton *GetStartedButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getStartedY;

@end

@implementation FPageONEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *fontname = @"";
    NSString *fontTwo = @"";
    NSString *textfont = @"";
    if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
        fontname = @".SFUIDisplay-Ultralight";
        fontTwo = @".SFUIDisplay-Thin";
        textfont = @".SFUIText-Light";
    }
    else{
        fontTwo = @".HelveticaNeueInterface-Thin";
        fontname = @".HelveticaNeueInterface-UltraLightP2";
        textfont = @".HelveticaNeueInterface-UltraLightP2";
    }
    
    if (IS_IPHONE_4s) {
        self.welcomeLabel.font = [UIFont fontWithName:fontname size:44];
        self.onLabel.font = [UIFont fontWithName:fontname size:44];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:44];
    }
    else if (IS_IPHONE_5){
        self.welcomeLabel.font = [UIFont fontWithName:fontname size:44];
        self.onLabel.font = [UIFont fontWithName:fontname size:44];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:44];
    }
    else if (IS_IPHONE_6){
        self.welcomeLabel.font = [UIFont fontWithName:fontname size:50];
        self.onLabel.font = [UIFont fontWithName:fontname size:50];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:50];
    }
    else{
        self.welcomeLabel.font = [UIFont fontWithName:fontname size:56];
        self.onLabel.font = [UIFont fontWithName:fontname size:56];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:56];
    }
    
    [self.GetStartedButton.titleLabel setFont:[UIFont fontWithName:textfont size:[UIScreen mainScreen].bounds.size.width/25]];
    [self.view layoutIfNeeded];
    self.GetStartedButton.layer.cornerRadius = self.GetStartedButton.frame.size.height/2;
    self.GetStartedButton.layer.masksToBounds = YES;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.2 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.welcomeLabel.alpha = 1;
        self.onLabel.alpha = 1;
        self.fuudLabel.alpha = 1;
    } completion:^(BOOL finished) {
        self.getStartedY.constant = -self.GetStartedButton.frame.size.height-[UIScreen mainScreen].bounds.size.height/5;
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];

    }];
}

- (IBAction)getStartedClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ONEClickedNext:)]) {
        [self.delegate ONEClickedNext:self];
    }
}

@end
