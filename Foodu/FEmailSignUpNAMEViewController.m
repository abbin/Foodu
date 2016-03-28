//
//  FEmailSignUpNAMEViewController.m
//  Foodu
//
//  Created by Abbin on 21/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FEmailSignUpNAMEViewController.h"

NSInteger const enabledTag2 = 1;
NSInteger const disabledTag2 = 2;

@interface FEmailSignUpNAMEViewController ()
@property (weak, nonatomic) IBOutlet UILabel *whtIsYourNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation FEmailSignUpNAMEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fontname = @"";
    if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
        fontname = @".SFUIDisplay-Ultralight";
    }
    else{
        fontname = @".HelveticaNeueInterface-UltraLightP2";
    }
    
    [self.whtIsYourNameLabel setFont:[UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/9]];
    [self.whtIsYourNameLabel setText:@"Hi!\nWhat's your name?"];
    self.nameTextField.font = [UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/15];
    
    self.nextButton.layer.cornerRadius = self.nextButton.frame.size.height/4;
    self.nextButton.layer.masksToBounds = YES;
    
    
    if (self.name) {
        self.nameTextField.text = self.name;
        self.nextButton.backgroundColor = [UIColor PinRed];
    }
    else{
        self.nextButton.backgroundColor = [UIColor lightTextColor];
    }
}

-(void)becomeActive{
    [self.nameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    bottomBorder2.frame = CGRectMake(0.0f, self.nameTextField.frame.size.height-3, self.nameTextField.frame.size.width, 1.0f);
    bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                      alpha:1.0f].CGColor;
    [self.nameTextField.layer addSublayer:bottomBorder2];
}
- (IBAction)backclicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SignUpNAMEClickedBack:)]) {
        [self.delegate SignUpNAMEClickedBack:self];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self nextClicked:self.nextButton];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.nameTextField.text.length>0) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.backgroundColor = [UIColor PinRed];
            
        } completion:^(BOOL finished) {
            self.nextButton.tag = enabledTag2;
        }];
    }
    else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.backgroundColor = [UIColor lightTextColor];
            
        } completion:^(BOOL finished) {
            self.nextButton.tag = disabledTag2;
        }];
    }
}

- (IBAction)nameTextFieldDidChange:(UITextField *)sender {
    if (sender.text.length>0) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.backgroundColor = [UIColor PinRed];
        } completion:^(BOOL finished) {
            self.nextButton.tag = enabledTag2;
        }];
    }
    if (sender.text.length==0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.backgroundColor = [UIColor lightTextColor];
        } completion:^(BOOL finished) {
            self.nextButton.tag = disabledTag2;
        }];
    }

}
- (IBAction)nextClicked:(UIButton *)sender {
    if (sender.tag == enabledTag2) {
        if (self.nameTextField.text.length>0){
            [self.nameTextField endEditing:YES];
            if ([self.delegate respondsToSelector:@selector(SignUpNAMEClickedNext:withLocation:andName:)]) {
                [self.delegate SignUpNAMEClickedNext:self withLocation:self.location andName:self.nameTextField.text];
            }
        }
        else{
            [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Enter a name" wait:5];
        }
    }
    else{
        [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Enter a name" wait:5];
    }
}

@end
