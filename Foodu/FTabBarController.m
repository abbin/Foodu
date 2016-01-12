//
//  FTabBarController.m
//  Foodu
//
//  Created by Abbin on 07/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FTabBarController.h"
#import "UIColor+FColours.h"

@interface FTabBarController ()

@property (strong, nonatomic) IBOutlet UIView *tabBarView;

@property (weak, nonatomic) IBOutlet UIButton *pinButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *geoListButton;
@property (weak, nonatomic) IBOutlet UIButton *bookMarkButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *pinImageView;
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *geoListImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bookMarkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;


@end

@implementation FTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarView.frame = CGRectMake(0.0,
                                       self.view.frame.size.height - self.tabBarView.frame.size.height,
                                       [UIScreen mainScreen].bounds.size.width,
                                       55);
    
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

- (IBAction)pinButtonClicked:(UIButton *)sender {
//    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
//    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
//    basicAnimation.springBounciness=2;    // value between 0-20 default at 4
//    basicAnimation.springSpeed=40;
//    basicAnimation.toValue=[NSValue valueWithCGPoint:self.pinButton.center];
//    [self.backView pop_addAnimation:basicAnimation forKey:@"WhatEverNameYouWant"];
//    self.backView.backgroundColor = [UIColor grapeFruit];
//    [self.pinImageView setImage:[UIImage imageNamed:@"pinSelected"]];
}

- (IBAction)homeButtonClicked:(UIButton *)sender {
    [self setSelectedIndex:0];
    [self.geoListImageView setImage:[UIImage imageNamed:@"geoList"]];
    [self.bookMarkImageView setImage:[UIImage imageNamed:@"bookMarks"]];
    [self.profileImageView setImage:[UIImage imageNamed:@"profile"]];
    
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    basicAnimation.springBounciness=7;    // value between 0-20 default at 4
    basicAnimation.springSpeed=40;
    basicAnimation.toValue=[NSValue valueWithCGPoint:self.homeButton.center];
    [self.backView pop_addAnimation:basicAnimation forKey:@"WhatEverNameYouWant"];
    self.backView.backgroundColor = [UIColor mint];
    [self.homeImageView setImage:[UIImage imageNamed:@"homeSelected"]];
}

- (IBAction)geoListButtonClicked:(UIButton *)sender {
    [self setSelectedIndex:1];
    [self.bookMarkImageView setImage:[UIImage imageNamed:@"bookMarks"]];
    [self.profileImageView setImage:[UIImage imageNamed:@"profile"]];
    [self.homeImageView setImage:[UIImage imageNamed:@"home"]];
    
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    basicAnimation.springBounciness=7;    // value between 0-20 default at 4
    basicAnimation.springSpeed=40;
    basicAnimation.toValue=[NSValue valueWithCGPoint:self.geoListButton.center];
    [self.backView pop_addAnimation:basicAnimation forKey:@"WhatEverNameYouWant"];
    
    self.backView.backgroundColor = [UIColor pinkRose];
    [self.geoListImageView setImage:[UIImage imageNamed:@"geoListSelected"]];
}

- (IBAction)bookMarkButtonCLiked:(UIButton *)sender {
    [self setSelectedIndex:2];
    [self.geoListImageView setImage:[UIImage imageNamed:@"geoList"]];
    [self.profileImageView setImage:[UIImage imageNamed:@"profile"]];
    [self.homeImageView setImage:[UIImage imageNamed:@"home"]];
    
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    basicAnimation.springBounciness=7;    // value between 0-20 default at 4
    basicAnimation.springSpeed=40;
    basicAnimation.toValue=[NSValue valueWithCGPoint:self.bookMarkButton.center];
    [self.backView pop_addAnimation:basicAnimation forKey:@"WhatEverNameYouWant"];
    self.backView.backgroundColor = [UIColor sunFlower];
    [self.bookMarkImageView setImage:[UIImage imageNamed:@"bookMarkSelected"]];
}

- (IBAction)profileButtonClicked:(UIButton *)sender {
    [self setSelectedIndex:3];
    [self.geoListImageView setImage:[UIImage imageNamed:@"geoList"]];
    [self.bookMarkImageView setImage:[UIImage imageNamed:@"bookMarks"]];
    [self.homeImageView setImage:[UIImage imageNamed:@"home"]];
    
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    basicAnimation.springBounciness=2;    // value between 0-20 default at 4
    basicAnimation.springSpeed=40;
    basicAnimation.toValue=[NSValue valueWithCGPoint:self.profileButton.center];
    [self.backView pop_addAnimation:basicAnimation forKey:@"WhatEverNameYouWant"];
    self.backView.backgroundColor = [UIColor lavender];
    [self.profileImageView setImage:[UIImage imageNamed:@"profileSelected"]];
}

@end
