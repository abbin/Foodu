//
//  FTabBarController.m
//  Foodu
//
//  Created by Abbin on 07/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FTabBarController.h"

@interface FTabBarController ()

@property (strong, nonatomic) IBOutlet UIView *tabBarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceBtwButtons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceBtwButtonsTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceBtwButtonsThree;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceBtwButtonsFour;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceBtwButtonsFive;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewVidth;

@property (weak, nonatomic) IBOutlet UIButton *pinButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *geoListButton;
@property (weak, nonatomic) IBOutlet UIButton *bookMarkButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation FTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarView.frame = CGRectMake(0.0,
                                       self.view.frame.size.height - self.tabBarView.frame.size.height,
                                       [UIScreen mainScreen].bounds.size.width,
                                       55);
    
    self.backView.center = self.homeButton.center;
    
    int distance;
    
    if (IS_IPHONE_4s) {
        distance = 34;
        self.backViewVidth.constant = 63;
    }
    else if (IS_IPHONE_5){
        distance = 34;
        self.backViewVidth.constant = 63;
        
    }
    else if (IS_IPHONE_6){
        distance = 45;
        self.backViewVidth.constant = 73;
    }
    else if (IS_IPHONE_6Plus){
        distance = 53;
        self.backViewVidth.constant = 83;
    }
    
    self.distanceBtwButtons.constant = distance/2;
    self.distanceBtwButtonsTwo.constant = distance;
    self.distanceBtwButtonsThree.constant = distance;
    self.distanceBtwButtonsFour.constant = distance;
    self.distanceBtwButtonsFive.constant = distance;
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.tabBarView.frame.size.width, 0.3f);
    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.tabBarView.layer addSublayer:topBorder];
    
    [self.view addSubview:self.tabBarView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeButtonClicked:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^(void){
        self.backView.center = self.homeButton.center;
    }];
}

- (IBAction)pinButtonClicked:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^(void){
        self.backView.center = self.pinButton.center;
    }];
}

- (IBAction)geoListButtonClicked:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^(void){
        self.backView.center = self.geoListButton.center;
    }];
}

- (IBAction)bookMarkButtonCLiked:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^(void){
        self.backView.center = self.bookMarkButton.center;
    }];
}

- (IBAction)profileButtonClicked:(UIButton *)sender {
[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    self.backView.center = self.profileButton.center;
} completion:^(BOOL finished) {
    
}];
}

@end
