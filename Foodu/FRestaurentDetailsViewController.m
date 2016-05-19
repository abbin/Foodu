//
//  FRestaurentDetailsViewController.m
//  Foodu
//
//  Created by Abbin Varghese on 19/05/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FRestaurentDetailsViewController.h"


@interface FRestaurentDetailsViewController ()

@end

@implementation FRestaurentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    FRestaurantPickerViewController *picker = [[FRestaurantPickerViewController alloc]initWithNibName:@"FRestaurantPickerViewController" bundle:[NSBundle mainBundle]];
    picker.delegate = self;
    picker.providesPresentationContextTransitionStyle = YES;
    picker.definesPresentationContext = YES;
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:picker animated:YES completion:nil];
    return NO;
}
- (IBAction)addLocationClciked:(UIButton *)sender {
    FLocationPickerViewController *picker = [[FLocationPickerViewController alloc]initWithNibName:@"FLocationPickerViewController" bundle:[NSBundle mainBundle]];
    picker.delegate = self;
    picker.providesPresentationContextTransitionStyle = YES;
    picker.definesPresentationContext = YES;
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)FLocationPicker:(FLocationPickerViewController *)picker didFinishPickingPlace:(NSMutableDictionary *)location{
    
}

-(void)restaurantPicker:(FRestaurantPickerViewController *)picker didFinishPickingrestaurant:(id)restaurant{
    if ([restaurant isKindOfClass:[NSString class]]) {
        
    }
    else{
        
    }
}
@end
