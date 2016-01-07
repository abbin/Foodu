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

@end

@implementation FTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarView.frame = CGRectMake(0.0,
                                       self.view.frame.size.height - self.tabBarView.frame.size.height,
                                       [UIScreen mainScreen].bounds.size.width,
                                       55);
    int distance = 52;
    self.distanceBtwButtons.constant = distance;
    self.distanceBtwButtonsTwo.constant = distance;
    self.distanceBtwButtonsThree.constant = distance;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
