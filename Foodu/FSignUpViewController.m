//
//  FSignUpViewController.m
//  Foodu
//
//  Created by Abbin Varghese on 09/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FSignUpViewController.h"

@interface FSignUpViewController ()
@property (weak, nonatomic) IBOutlet UIButton *one;
@property (weak, nonatomic) IBOutlet UIButton *two;
@property (weak, nonatomic) IBOutlet UIButton *three;

@end

@implementation FSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.one.layer.cornerRadius = 10; // this value vary as per your desire
    self.one.clipsToBounds = YES;
    
    self.two.layer.cornerRadius = 10; // this value vary as per your desire
    self.two.clipsToBounds = YES;
    
    self.three.layer.cornerRadius = 10; // this value vary as per your desire
    self.three.clipsToBounds = YES;
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
