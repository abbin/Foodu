//
//  FEmailSignUpPASSWORDViewController.m
//  Foodu
//
//  Created by Abbin on 28/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FEmailSignUpPASSWORDViewController.h"
#import "AppDelegate.h"
#import "FTabBarController.h"

NSInteger const enabledTag4 = 1;
NSInteger const disabledTag4 = 2;

@interface FEmailSignUpPASSWORDViewController ()
@property (weak, nonatomic) IBOutlet UILabel *whatispasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation FEmailSignUpPASSWORDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *fontname = @"";
    if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
        fontname = @".SFUIDisplay-Ultralight";
    }
    else{
        fontname = @".HelveticaNeueInterface-UltraLightP2";
    }
    [self.whatispasswordLabel setFont:[UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/9]];
    [self.whatispasswordLabel setText:@"You'll also need a password"];
    
    //self.passwordTextField.font = [UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/15];
    
    self.nextButton.layer.cornerRadius = self.nextButton.frame.size.height/4;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.backgroundColor = [UIColor lightTextColor];
    
    // Do any additional setup after loading the view.
}

-(void)becomeActive{
    [self.passwordTextField becomeFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:@selector(becomeActive) withObject:nil afterDelay:0.1];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height-3, self.passwordTextField.frame.size.width, 1.0f);
    bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                      alpha:1.0f].CGColor;
    [self.passwordTextField.layer addSublayer:bottomBorder2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SignUpPASSWORDClickedBack:withLocation:name:email:)]) {
        [self.delegate SignUpPASSWORDClickedBack:self withLocation:self.location name:self.name email:self.email];
    }
}

- (IBAction)nextClicked:(UIButton *)sender {
    if (sender.tag == enabledTag4) {
        if (self.passwordTextField.text.length>0){
            [self.passwordTextField endEditing:YES];
            self.nextButton.enabled = NO;
            [[FAlertView sharedHUD] showActivityIndicatorOnView:self.view];
            [FCurrentUser signUpUserWithName:self.name email:self.email password:self.passwordTextField.text andLocation:self.location success:^(BOOL success) {
                [[FAlertView sharedHUD]hideActivityIndicatorOnView];
                self.nextButton.enabled = YES;
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                FTabBarController*rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FTabBarController"];
                [appDelegate changeRootViewController:rootViewController];
            } failure:^(NSString *error) {
                self.nextButton.enabled = YES;
                [[FAlertView sharedHUD] showHUDOnView:self.view withText:error wait:5];
            }];

        }
        else{
            [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Enter a password" wait:5];
        }
    }
    else{
        [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Enter a password" wait:5];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self nextClicked:self.nextButton];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.passwordTextField.text.length>0) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.backgroundColor = [UIColor PinRed];
            
        } completion:^(BOOL finished) {
            self.nextButton.tag = enabledTag4;
        }];
    }
    else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.backgroundColor = [UIColor lightTextColor];
            
        } completion:^(BOOL finished) {
            self.nextButton.tag = disabledTag4;
        }];
    }
}
- (IBAction)textFieldDidChangeEditing:(UITextField *)sender {
    
    NSString *newString = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    sender.text = newString;
    
    if (sender.text.length>0) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.backgroundColor = [UIColor PinRed];
        } completion:^(BOOL finished) {
            self.nextButton.tag = enabledTag4;
        }];
    }
    if (sender.text.length==0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.backgroundColor = [UIColor lightTextColor];
        } completion:^(BOOL finished) {
            self.nextButton.tag = disabledTag4;
        }];
    }
}
- (IBAction)showPassword:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.passwordTextField endEditing:YES];
        [self.passwordTextField setSecureTextEntry:NO];
        [self.passwordTextField becomeFirstResponder];
        [sender setTitle:@"hide" forState:UIControlStateNormal];
        sender.tag = 1;
    }
    else{
        [self.passwordTextField endEditing:YES];
        [self.passwordTextField setSecureTextEntry:YES];
        [self.passwordTextField becomeFirstResponder];
        [sender setTitle:@"show" forState:UIControlStateNormal];
        sender.tag = 0;
    }
}

@end
