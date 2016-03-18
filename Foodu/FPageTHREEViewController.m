//
//  FPageTHREEViewController.m
//  Foodu
//
//  Created by Abbin on 17/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FPageTHREEViewController.h"
#import "FLocationPickerViewController.h"

@interface FPageTHREEViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *autoButton;
@property (weak, nonatomic) IBOutlet UIButton *manualButton;

@end

@implementation FPageTHREEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fontname = @"";
    NSString *fontTwo = @"";
    NSString *textfont = @"";
    if ([UIFont fontWithName:@".SFUIDisplay-Thin" size:10]) {
        fontname = @".SFUIDisplay-Thin";
        fontTwo = @".SFUIDisplay-Light";
        textfont = @".SFUIText-Light";
    }
    else{
        fontTwo = @".HelveticaNeueInterface-Thin";
        fontname = @".HelveticaNeueInterface-UltraLightP2";
        textfont = @".HelveticaNeueInterface-UltraLightP2";
    }
    
    [self.label setFont:[UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/18]];
    
    self.label.text = @"To get started, please set your location\n(or let us do it for you)";
    
    [self.autoButton.titleLabel setFont:[UIFont fontWithName:textfont size:[UIScreen mainScreen].bounds.size.width/25]];
    [self.view layoutIfNeeded];
    self.autoButton.layer.cornerRadius = self.autoButton.frame.size.height/2;
    self.autoButton.layer.masksToBounds = YES;
    
    
    [self.manualButton.titleLabel setFont:[UIFont fontWithName:textfont size:[UIScreen mainScreen].bounds.size.width/25]];
    [self.view layoutIfNeeded];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)autoButtonClicked:(UIButton *)sender {
    [FCurrentUser sharedUser];
}
- (IBAction)manualButtonClicked:(UIButton *)sender {
//    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
//    acController.delegate = self;
//    [self presentViewController:acController animated:YES completion:nil];
    FLocationPickerViewController *picker = [[FLocationPickerViewController alloc]initWithNibName:@"FLocationPickerViewController" bundle:[NSBundle mainBundle]];
    picker.providesPresentationContextTransitionStyle = YES;
    picker.definesPresentationContext = YES;
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
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
