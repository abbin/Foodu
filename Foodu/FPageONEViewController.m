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

@end

@implementation FPageONEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *fontname = @"";
    NSString *fontTwo = @"";
 //   NSString *textfont = @"";
    if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
        fontname = @".SFUIDisplay-Ultralight";
        fontTwo = @".SFUIDisplay-Thin";
 //       textfont = @".SFUIText-Light";
    }
    else{
        fontTwo = @".HelveticaNeueInterface-Thin";
        fontname = @".HelveticaNeueInterface-UltraLightP2";
  //      textfont = @".HelveticaNeueInterface-UltraLightP2";
    }
    
    if (IS_IPHONE_4s) {
        self.welcomeLabel.font = [UIFont fontWithName:fontname size:44];
        self.onLabel.font = [UIFont fontWithName:fontname size:44];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:44];
//        [self.facebookButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        [self.signUpWithEmailButton.titleLabel setFont:[UIFont fontWithName:textfont size:17]];
//        [self.changeToLoginViewButton.titleLabel setFont:[UIFont fontWithName:textfont size:12]];
        
    }
    else if (IS_IPHONE_5){
        self.welcomeLabel.font = [UIFont fontWithName:fontname size:44];
        self.onLabel.font = [UIFont fontWithName:fontname size:44];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:44];
//        [self.facebookButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        [self.signUpWithEmailButton.titleLabel setFont:[UIFont fontWithName:textfont size:17]];
//        
//        [self.changeToLoginViewButton.titleLabel setFont:[UIFont fontWithName:textfont size:12]];
    }
    else if (IS_IPHONE_6){
        self.welcomeLabel.font = [UIFont fontWithName:fontname size:50];
        self.onLabel.font = [UIFont fontWithName:fontname size:50];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:50];
//        [self.facebookButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
//        [self.signUpWithEmailButton.titleLabel setFont:[UIFont fontWithName:textfont size:19]];
//        
//        [self.changeToLoginViewButton.titleLabel setFont:[UIFont fontWithName:textfont size:13]];
    }
    else{
        self.welcomeLabel.font = [UIFont fontWithName:fontname size:56];
        self.onLabel.font = [UIFont fontWithName:fontname size:56];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:56];
//        [self.facebookButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
//        [self.signUpWithEmailButton.titleLabel setFont:[UIFont fontWithName:textfont size:21]];
//        
//        [self.changeToLoginViewButton.titleLabel setFont:[UIFont fontWithName:textfont size:15]];
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.welcomeLabel.alpha = 1;
        self.onLabel.alpha = 1;
        self.fuudLabel.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}


@end
