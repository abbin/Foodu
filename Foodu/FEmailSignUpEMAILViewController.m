//
//  FEmailSignUpEMAILViewController.m
//  Foodu
//
//  Created by Abbin on 22/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FEmailSignUpEMAILViewController.h"

NSInteger const enabledTag3 = 1;
NSInteger const disabledTag3 = 2;

@interface FEmailSignUpEMAILViewController ()

@property (weak, nonatomic) IBOutlet UILabel *whatIsLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation FEmailSignUpEMAILViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fontname = @"";
    if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
        fontname = @".SFUIDisplay-Ultralight";
    }
    else{
        fontname = @".HelveticaNeueInterface-UltraLightP2";
    }
    
    
    NSString *string = @"Your email?\n We wont spam. Pinky promise :)";
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:string];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/9]
                  range:NSMakeRange(0, string.length)];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/16]
                  range:NSMakeRange(12, 31)];
    
    self.whatIsLabel.attributedText = hogan;
    
    self.emailTextField.font = [UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/15];
    
    self.nextButton.layer.cornerRadius = self.nextButton.frame.size.height/4;
    self.nextButton.layer.masksToBounds = YES;
    

    if (self.email) {
        self.emailTextField.text = self.email;
        self.nextButton.backgroundColor = [UIColor PinRed];
    }
    else{
        self.nextButton.backgroundColor = [UIColor lightTextColor];
    }
}

-(void)becomeActive{
    [self.emailTextField becomeFirstResponder];
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
    bottomBorder2.frame = CGRectMake(0.0f, self.emailTextField.frame.size.height-3, self.emailTextField.frame.size.width, 1.0f);
    bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                      alpha:1.0f].CGColor;
    [self.emailTextField.layer addSublayer:bottomBorder2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextClicked:(UIButton *)sender {
    if (sender.tag == enabledTag3) {
        if ([self stringIsValidEmail:self.emailTextField.text]){
            [self.emailTextField endEditing:YES];
            [[FAlertView sharedHUD] showActivityIndicatorOnView:nil];
            self.nextButton.enabled = NO;
            PFQuery *query = [PFUser query];
            [query whereKey:@"email" equalTo:self.emailTextField.text];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                self.nextButton.enabled = YES;
                if (objects.count == 0) {
                    [[FAlertView sharedHUD] hideActivityIndicatorOnView];
                    self.nextButton.tag = enabledTag3;
                    if ([self.delegate respondsToSelector:@selector(SignUpEMAILClickedNext:withLocation:name:andEmail:)]){
                        [self.delegate SignUpEMAILClickedNext:self withLocation:self.location name:self.name andEmail:self.emailTextField.text];
                    }
                }
                else{
                    [[FAlertView sharedHUD] showHUDOnView:self.view withText:@"Email already registered" wait:5];
                    [self.nextButton setBackgroundColor:[UIColor lightTextColor]];
                    [self.emailTextField becomeFirstResponder];
                }
            }];
        }
        else{
            [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Enter a valid email" wait:5];
        }
    }
    else{
        [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Enter a valid email" wait:5];
    }
}

- (IBAction)emailTextFieldDidChangeEditing:(UITextField *)sender {
    
    NSString *newString = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.emailTextField.text = newString;
    
    if ([self stringIsValidEmail:self.emailTextField.text]) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.backgroundColor = [UIColor PinRed];
        } completion:^(BOOL finished) {
            self.nextButton.tag = enabledTag3;
        }];
    }
    if ([self stringIsValidEmail:self.emailTextField.text] == NO) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.backgroundColor = [UIColor lightTextColor];
        } completion:^(BOOL finished) {
            self.nextButton.tag = disabledTag3;
        }];
    }
}

- (IBAction)backButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SignUpEMAILClickedBack:withLocation:andName:)]) {
        [self.delegate SignUpEMAILClickedBack:self withLocation:self.location andName:self.name];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self nextClicked:self.nextButton];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self stringIsValidEmail:self.emailTextField.text]) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.backgroundColor = [UIColor PinRed];
            
        } completion:^(BOOL finished) {
            self.nextButton.tag = enabledTag3;
        }];
    }
    else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.backgroundColor = [UIColor lightTextColor];
            
        } completion:^(BOOL finished) {
            self.nextButton.tag = disabledTag3;
        }];
    }
}

- (BOOL)stringIsValidEmail:(NSString *)checkString{
    
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
    
}

@end
