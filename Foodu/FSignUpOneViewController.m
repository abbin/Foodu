//
//  FSignUpOneViewController.m
//  Foodu
//
//  Created by Abbin Varghese on 19/02/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FSignUpOneViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "FTabBarController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


NSInteger const enabledTag = 1;
NSInteger const disabledTag = 2;

NSInteger const faceBookTag = 1;
NSInteger const emailTag = 2;

@interface FSignUpOneViewController ()

#pragma mark -
#pragma mark UIVIEWS

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UIView *facebookButtonContainerView;
@property (weak, nonatomic) IBOutlet UIView *signInView;
@property (weak, nonatomic) IBOutlet UIView *signUpView;
@property (weak, nonatomic) IBOutlet UIView *facebookContainerView;

#pragma mark -
#pragma mark UITEXTFIELDS

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *signInEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *signInPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *passwordShow;
@property (weak, nonatomic) IBOutlet UIButton *signInSignUpSwitchButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *changeToLoginViewButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpWithEmailButton;

#pragma mark -
#pragma mark UILABELS

@property (weak, nonatomic) IBOutlet UILabel *whtIsYourNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuudLabel;

#pragma mark -
#pragma mark CONSTRAINS

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showPasswordWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signInEmailLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signInPasswordHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signChangeConstrain;

#pragma mark -
#pragma mark KEYBORRD METHODS

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *signInEmail;
@property (strong, nonatomic) NSString *signInPassword;

#pragma mark -
#pragma mark OTHERS

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIImageView *facebookImageView;

@property (nonatomic, strong) AVPlayer *avplayer;

@end

@implementation FSignUpOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signUpScreen = SignUpOne;
    
    [self initVideoBackground];
    
    if (self.viewType == SignUpView) {
        [self drawSignUpNameScreenAnimated:NO];
    }
    else if (self.viewType == SignInView){
        [self drawSignInScreenAnimated:NO];
    }
    else{
        [self drawFacebookScreenAnimated:NO];
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardNotScreen:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.facebookButtonContainerView.layer.cornerRadius = self.signUpWithEmailButton.frame.size.height/4;
    self.facebookButtonContainerView.layer.masksToBounds = YES;
    
    self.signUpWithEmailButton.layer.cornerRadius = self.signUpWithEmailButton.frame.size.height/4;
    self.signUpWithEmailButton.layer.masksToBounds = YES;
    
    self.nextButton.layer.cornerRadius = self.nextButton.frame.size.height/4;
    self.nextButton.layer.masksToBounds = YES;
    
    self.signInButton.layer.cornerRadius = self.signInButton.frame.size.height/4;
    self.signInButton.layer.masksToBounds = YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.avplayer pause];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.avplayer play];
    if (self.viewType == SignInView) {
        [self.signInEmailTextField becomeFirstResponder];
    }
    else if (self.viewType == SignUpView){
        [self.nameTextField becomeFirstResponder];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

/////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark KEYBORRD METHODS

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 1) {  //NAME TEXTFIELD FROM SIGNUP VIEW
        if (self.nextButton.tag == enabledTag) {
            [self.nameTextField endEditing:YES];
            if (self.nameTextField.text.length>0) {
                switch (self.signUpScreen) {
                    case SignUpOne:
                        self.signUpScreen = SignUpTwo;
                        self.name = self.nameTextField.text;
                        [self drawSignUpEmailScreenAnimated:YES];
                        break;
                    case SignUpTwo:{
                        [[FAlertView sharedHUD] showActivityIndicatorOnView:self.view];
                        self.nextButton.enabled = NO;
                        PFQuery *query = [PFUser query];
                        [query whereKey:@"email" equalTo:self.nameTextField.text]; // find all the women
                        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                            self.nextButton.enabled = YES;
                            if (objects.count == 0) {
                                [[FAlertView sharedHUD] hideActivityIndicatorOnView];
                                self.signUpScreen = SignUpThree;
                                self.email = self.nameTextField.text;
                                [self drawSignUpPasswordScreenAnimated:YES];
                                self.nextButton.tag = enabledTag;
                            }
                            else{
                                [[FAlertView sharedHUD] showHUDOnView:self.view withText:@"Email already registered" wait:5];
                                [self.nextButton setBackgroundColor:[UIColor lightTextColor]];
                            }
                        }];
                    }
                        break;
                    case SignUpThree:
                        self.password = self.nameTextField.text;
                        [self registerUser];
                        break;
                    default:
                        break;
                }
            }
        }
        else{
            switch (self.signUpScreen) {
                case SignUpOne:
                    [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Enter a name" wait:5];
                    break;
                case SignUpTwo:{
                    [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Enter a valid email" wait:5];
                }
                    break;
                case SignUpThree:{
                    [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Enter a password" wait:5];
                }
                    break;
                default:
                    break;
            }
        }
    }
    else if (textField.tag == 2){  //EMAIL TEXTFIELD FROM SIGNIN VIEW
        [self.signInPasswordTextField becomeFirstResponder];
    }
    else{  //PASSWORD TEXTFIELD FROM SIGNIN VIEW
        [self signIn:nil];
    }

    return YES;
}

- (void)keyboardNotScreen:(NSNotification *)notification{
    
    self.signChangeConstrain.constant = 0;
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (void)keyboardOnScreen:(NSNotification *)notification{
    
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    self.signChangeConstrain.constant = keyboardFrame.size.height;
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    if (self.signUpScreen == SignUpTwo) {
        if ([self stringIsValidEmail:self.nameTextField.text]) {
            [UIView animateWithDuration:0.3 animations:^{
                self.nextButton.backgroundColor = [UIColor PinRed];
                self.nextButton.tag = enabledTag;
            }];
        }
        else{
            [UIView animateWithDuration:0.3 animations:^{
                self.nextButton.backgroundColor = [UIColor lightTextColor];
                self.nextButton.tag = disabledTag;
            }];
        }
    }
    else{
        if (self.nameTextField.text.length>0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.nextButton.backgroundColor = [UIColor PinRed];
                self.nextButton.tag = enabledTag;
            }];
        }
        else{
            [UIView animateWithDuration:0.3 animations:^{
                self.nextButton.backgroundColor = [UIColor lightTextColor];
                self.nextButton.tag = disabledTag;
            }];
        }
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark IB ACTIONS

- (IBAction)nameLabelDidChangeEditing:(UITextField *)sender {

    if (self.signUpScreen == SignUpTwo) {
        NSString *newString = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.nameTextField.text = newString;
        if ([self stringIsValidEmail:self.nameTextField.text]) {
            [UIView animateWithDuration:0.3 animations:^{
                self.nextButton.backgroundColor = [UIColor PinRed];
                self.nextButton.tag = enabledTag;
                [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
            }];
        }
        if (![self stringIsValidEmail:self.nameTextField.text]) {
            [UIView animateWithDuration:0.3 animations:^{
                self.nextButton.backgroundColor = [UIColor lightTextColor];
                self.nextButton.tag = disabledTag;
            }];
        }
    }
    else if (self.signUpScreen == SignUpThree){
        NSString *newString = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.nameTextField.text = newString;
        if (sender.text.length>0) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.nextButton.backgroundColor = [UIColor PinRed];
                self.nextButton.tag = enabledTag;
            } completion:^(BOOL finished) {
                
            }];
        }
        if (sender.text.length==0) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.nextButton.backgroundColor = [UIColor lightTextColor];
                self.nextButton.tag = disabledTag;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else{
        if (sender.text.length>0) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.nextButton.backgroundColor = [UIColor PinRed];
                self.nextButton.tag = enabledTag;
            } completion:^(BOOL finished) {
                
            }];
        }
        if (sender.text.length==0) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.nextButton.backgroundColor = [UIColor lightTextColor];
                self.nextButton.tag = disabledTag;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
}

- (IBAction)signinEmailFieldDidChange:(UITextField *)sender {
    NSString *newString = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    sender.text = newString;
    if ([self stringIsValidEmail:sender.text] && self.signInPasswordTextField.text.length>0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.signInButton.backgroundColor = [UIColor PinRed];
            self.signInButton.tag = enabledTag;
        }];
    }
    if (![self stringIsValidEmail:sender.text] && self.signInPasswordTextField.text.length==0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.signInButton.backgroundColor = [UIColor lightTextColor];
            self.signInButton.tag = disabledTag;
        }];
    }
    
}

- (IBAction)signInPasswordFieldDidChange:(UITextField *)sender {
    NSString *newString = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    sender.text = newString;
    if (sender.text.length>0 && [self stringIsValidEmail:self.signInEmailTextField.text]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.signInButton.backgroundColor = [UIColor PinRed];
            self.signInButton.tag = enabledTag;
        }];
    }
    if (sender.text.length==0 || ![self stringIsValidEmail:self.signInEmailTextField.text]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.signInButton.backgroundColor = [UIColor lightTextColor];
            self.signInButton.tag = disabledTag;
        }];
    }
    
}

- (IBAction)nextClicked:(UIButton *)sender {
    if (sender.tag == enabledTag) {
        [self.nameTextField endEditing:YES];
        if (self.nameTextField.text.length>0) {
            switch (self.signUpScreen) {
                case SignUpOne:
                    self.signUpScreen = SignUpTwo;
                    self.name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    [self drawSignUpEmailScreenAnimated:YES];
                    break;
                case SignUpTwo:{
                    [[FAlertView sharedHUD] showActivityIndicatorOnView:self.view];
                    self.nextButton.enabled = NO;
                    PFQuery *query = [PFUser query];
                    [query whereKey:@"email" equalTo:self.nameTextField.text];
                    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                        self.nextButton.enabled = YES;
                        if (objects.count == 0) {
                            [[FAlertView sharedHUD] hideActivityIndicatorOnView];
                            self.signUpScreen = SignUpThree;
                            self.email = self.nameTextField.text;
                            [self drawSignUpPasswordScreenAnimated:YES];
                            self.nextButton.tag = enabledTag;
                        }
                        else{
                            [[FAlertView sharedHUD] showHUDOnView:self.view withText:@"Email already registered" wait:5];
                            [self.nextButton setBackgroundColor:[UIColor lightTextColor]];
                        }
                    }];
                }
                    break;
                case SignUpThree:
                    self.password = self.nameTextField.text;
                    [self registerUser];
                    break;
                default:
                    break;
            }
        }
    }
    else{
            switch (self.signUpScreen) {
                case SignUpOne:
                    [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Enter a name" wait:5];
                    break;
                case SignUpTwo:{
                   [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Enter a valid email" wait:5];
                }
                    break;
                case SignUpThree:{
                    [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Enter a password" wait:5];
                }
                    break;
                default:
                    break;
            }
        }
}

- (IBAction)goToPreviousScreen:(UIButton *)sender {
    
    if (self.viewType == SignUpView) {
        switch (self.signUpScreen) {
            case SignUpThree:
                self.signUpScreen = SignUpTwo;
                [self.nameTextField endEditing:YES];
                [self drawSignUpEmailScreenAnimated:YES];
                break;
            case SignUpTwo:
                self.signUpScreen = SignUpOne;
                [self.nameTextField endEditing:YES];
                [self drawSignUpNameScreenAnimated:YES];
                break;
            case SignUpOne:
                [self drawFacebookScreenAnimated:YES];
                break;
                
            default:
                break;
        }
    }
    else if (self.viewType == SignInView){
        [self drawFacebookScreenAnimated:YES];
    }
    
}
- (IBAction)showPassword:(UIButton *)sender {
    
    [self.nameTextField endEditing:YES];
    [self.nameTextField setSecureTextEntry:NO];
    [self.nameTextField becomeFirstResponder];
    
}

- (IBAction)switchSignInSignUpScreens:(UIButton *)sender {
    
    if (self.viewType == SignInView) {
        [self.view endEditing:YES];
        [self drawSignUpNameScreenAnimated:YES];
    }
    else{
        [self.view endEditing:YES];
        [self drawSignInScreenAnimated:YES];
    }
    
}
- (IBAction)connectWithFacebook:(UIButton *)sender {
    
    self.signUpWithEmailButton.enabled = NO;
    self.facebookButton.enabled = NO;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        [[FAlertView sharedHUD] showActivityIndicatorOnView:self.view];
        [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
            if (error == nil) {
                GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods objectAtIndex:0];
                GMSPlace* place = likelihood.place;
                NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:place];
                [FCurrentUser connectWithFacebookFromViewController:self withLocation:obj success:^(BOOL success) {
                    self.signUpWithEmailButton.enabled = YES;
                    self.facebookButton.enabled = YES;
                    [[FAlertView sharedHUD] hideActivityIndicatorOnView];
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    FTabBarController*rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FTabBarController"];
                    [appDelegate changeRootViewController:rootViewController];
                } failure:^(NSString *error) {
                    self.signUpWithEmailButton.enabled = YES;
                    self.facebookButton.enabled = YES;
                    [[FAlertView sharedHUD] showHUDOnView:self.view withText:error wait:5];
                }];
            }
            else{
                [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
                    if (error == nil) {
                        GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods objectAtIndex:0];
                        GMSPlace* place = likelihood.place;
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:place];
                        [FCurrentUser connectWithFacebookFromViewController:self withLocation:obj success:^(BOOL success) {
                            self.signUpWithEmailButton.enabled = YES;
                            self.facebookButton.enabled = YES;
                            [[FAlertView sharedHUD] hideActivityIndicatorOnView];
                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            FTabBarController*rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FTabBarController"];
                            [appDelegate changeRootViewController:rootViewController];
                        } failure:^(NSString *error) {
                            self.signUpWithEmailButton.enabled = YES;
                            self.facebookButton.enabled = YES;
                            [[FAlertView sharedHUD] showHUDOnView:self.view withText:error wait:5];
                        }];
                    }
                    else{
                        self.signUpWithEmailButton.enabled = YES;
                        self.facebookButton.enabled = YES;
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh Oh!" message:@"We couldn't get an accurate read on where you are. Try manually setting a location" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            FLocationPickerViewController *picker = [[FLocationPickerViewController alloc]initWithNibName:@"FLocationPickerViewController" bundle:[NSBundle mainBundle]];
                            picker.delegate = self;
                            picker.tag = faceBookTag;
                            picker.providesPresentationContextTransitionStyle = YES;
                            picker.definesPresentationContext = YES;
                            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                            [self presentViewController:picker animated:YES completion:nil];
                        }];
                        
                        [alert addAction:actionOk];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];;
            }
        }];
    }
    else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Location not detected" message:@"Location services are turned off on your device. Please go to settings and enable location services to use this feature or manually select a location." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *Select = [UIAlertAction actionWithTitle:@"Manually select a location" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.nextButton.enabled = YES;
            FLocationPickerViewController *picker = [[FLocationPickerViewController alloc]initWithNibName:@"FLocationPickerViewController" bundle:[NSBundle mainBundle]];
            picker.delegate = self;
            picker.tag = faceBookTag;
            picker.providesPresentationContextTransitionStyle = YES;
            picker.definesPresentationContext = YES;
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.nextButton.enabled = YES;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addAction:Select];
        [alert addAction:settings];
        [self presentViewController:alert animated:YES completion:nil];
    }
    

}

- (IBAction)signIn:(UIButton *)sender {
    self.signInEmail = self.signInEmailTextField.text;
    self.signInPassword = self.signInPasswordTextField.text;
    if ([self stringIsValidEmail:self.signInEmail] && self.signInPassword.length>0) {
        [[FAlertView sharedHUD] showActivityIndicatorOnView:self.view];
        self.signInButton.enabled = NO;
        [FCurrentUser logInUserWithEmail:self.signInEmail password:self.signInPassword success:^(BOOL success) {
            self.signInButton.enabled = YES;
            [[FAlertView sharedHUD] hideActivityIndicatorOnView];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FTabBarController*rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FTabBarController"];
            [appDelegate changeRootViewController:rootViewController];

        } failure:^(NSString *error) {
            self.signInButton.enabled = YES;
            [[FAlertView sharedHUD] showHUDOnView:self.view withText:error wait:5];
        }];
    }
    else{
        if ([self stringIsValidEmail:self.signInEmail] == NO) {
            [[FAlertView sharedHUD] showHUDOnView:self.view withText:@"Enter a valid email" wait:5];
        }
        else{
            [[FAlertView sharedHUD] showHUDOnView:self.view withText:@"Enter password" wait:5];
        }
    }
}

- (IBAction)signUpWithEmail:(UIButton *)sender {
    
    [self drawSignUpNameScreenAnimated:YES];
    
}

- (IBAction)changeToLoginView:(UIButton *)sender {
    
    [self drawSignInScreenAnimated:YES];
    
}


/////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark UTILITY METHODS

- (BOOL)stringIsValidEmail:(NSString *)checkString{
    
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark UIVIEW DRAW METHODS

- (void)drawSignUpPasswordScreenAnimated:(BOOL)animated{  // PASSWORD SCREEN
    
    double time;
    
    if (animated) {
        time = 0.2;
    }
    else{
        time = 0;
    }
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.whtIsYourNameLabel.alpha = 0;
        self.nameTextField.alpha = 0;
        self.nextButton.alpha = 0;
        
    } completion:^(BOOL finished) {
        self.nextButton.backgroundColor = [UIColor lightTextColor];
        [self.nameTextField setSecureTextEntry:YES];
        self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.nameTextField setKeyboardType:UIKeyboardTypeDefault];
        
        NSString *fontname = @"";
        if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
            fontname = @".SFUIDisplay-Ultralight";
        }
        else{
            fontname = @".HelveticaNeueInterface-UltraLightP2";
        }
        
        if (IS_IPHONE_4s) {
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:34];
            self.nameTextField.font = [UIFont fontWithName:fontname size:19];
            self.nameLabelHeight.constant = 44;
        }
        else if (IS_IPHONE_5){
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:33];
            self.nameTextField.font = [UIFont fontWithName:fontname size:20];
            self.nameLabelHeight.constant = 44;
        }
        else if (IS_IPHONE_6){
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:41];
            self.nameTextField.font = [UIFont fontWithName:fontname size:25];
            self.nameLabelHeight.constant = 50;
        }
        else{
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:45];
            self.nameTextField.font = [UIFont fontWithName:fontname size:28];
            self.nameLabelHeight.constant = 55;
        }
        
        if (self.nameTextField.layer.sublayers.count <= 2) {
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, self.nameLabelHeight.constant-3, self.nameTextField.frame.size.width, 1.0f);
            bottomBorder.backgroundColor = [UIColor colorWithWhite:1.0f
                                                             alpha:1.0f].CGColor;
            [self.nameTextField.layer addSublayer:bottomBorder];
            
            CALayer *bottomBorder2 = [CALayer layer];
            bottomBorder2.frame = CGRectMake(0.0f, self.nameLabelHeight.constant-3, self.passwordShow.frame.size.width, 1.0f);
            bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                             alpha:1.0f].CGColor;
            [self.passwordShow.layer addSublayer:bottomBorder2];
            
        }
        
        self.whtIsYourNameLabel.text = @"You'll need a password";
        self.nameTextField.placeholder = @"password";
        self.nameTextField.text = self.password;
        [self.nextButton setTitle:@"Register" forState:UIControlStateNormal];
        
        self.showPasswordWidth.constant = 31;
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.alpha = 1;
            self.whtIsYourNameLabel.alpha = 1;
            self.nameTextField.alpha = 1;
        } completion:^(BOOL finished) {
            
            [self.nameTextField becomeFirstResponder];
        }];
        
    }];

}

- (void)drawSignUpEmailScreenAnimated:(BOOL)animated{  //EMAIL SCREEN
    
    double time;
    
    if (animated) {
        time = 0.2;
    }
    else{
        time = 0;
    }
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.signInSignUpSwitchButton.alpha = 0;
        self.whtIsYourNameLabel.alpha = 0;
        self.nameTextField.alpha = 0;
        self.nextButton.alpha = 0;
        
    } completion:^(BOOL finished) {
        self.nextButton.backgroundColor = [UIColor lightTextColor];
        self.showPasswordWidth.constant = 0;
        [self.view layoutIfNeeded];
        [self.nameTextField setKeyboardType:UIKeyboardTypeEmailAddress];
        self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.nameTextField setSecureTextEntry:NO];
        
        NSString *fontname = @"";
        if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
            fontname = @".SFUIDisplay-Ultralight";
        }
        else{
            fontname = @".HelveticaNeueInterface-UltraLightP2";
        }
        
        if (IS_IPHONE_4s) {
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:34];
            self.nameTextField.font = [UIFont fontWithName:fontname size:19];
            self.nameLabelHeight.constant = 44;
        }
        else if (IS_IPHONE_5){
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:33];
            self.nameTextField.font = [UIFont fontWithName:fontname size:20];
            self.nameLabelHeight.constant = 44;
        }
        else if (IS_IPHONE_6){
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:41];
            self.nameTextField.font = [UIFont fontWithName:fontname size:25];
            self.nameLabelHeight.constant = 50;
        }
        else{
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:45];
            self.nameTextField.font = [UIFont fontWithName:fontname size:28];
            self.nameLabelHeight.constant = 55;
        }
        
        if (self.nameTextField.layer.sublayers.count <= 2) {
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, self.nameLabelHeight.constant-3, self.nameTextField.frame.size.width, 1.0f);
            bottomBorder.backgroundColor = [UIColor colorWithWhite:1.0f
                                                             alpha:1.0f].CGColor;
            [self.nameTextField.layer addSublayer:bottomBorder];
            
            CALayer *bottomBorder2 = [CALayer layer];
            bottomBorder2.frame = CGRectMake(0.0f, self.nameLabelHeight.constant-3, self.passwordShow.frame.size.width, 1.0f);
            bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                              alpha:1.0f].CGColor;
            [self.passwordShow.layer addSublayer:bottomBorder2];
        }
        
        self.whtIsYourNameLabel.text = @"Now,\nWhat's your email?";
        self.nameTextField.placeholder = @"email";
        self.nameTextField.text = self.email;
        [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.whtIsYourNameLabel.alpha = 1;
            self.nameTextField.alpha = 1;
            self.nextButton.alpha = 1;
        } completion:^(BOOL finished) {
            
            [self.nameTextField becomeFirstResponder];
        }];
        
    }];
}

- (void)drawSignUpNameScreenAnimated:(BOOL)animated{  // NAME SCREEN
    
    double time;
    
    if (animated) {
        time = 0.2;
    }
    else{
        time = 0;
    }
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.signInView.alpha = 0;
        self.whtIsYourNameLabel.alpha = 0;
        self.nameTextField.alpha = 0;
        self.nextButton.alpha = 0;
        self.facebookContainerView.alpha = 0;
        [self.signInSignUpSwitchButton setTitle:@"Have an account? Sign In" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        self.nextButton.backgroundColor = [UIColor lightTextColor];
        self.showPasswordWidth.constant = 0;
        [self.view layoutIfNeeded];
        [self.nameTextField setKeyboardType:UIKeyboardTypeDefault];
        self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [self.nameTextField setSecureTextEntry:NO];
        
        NSString *fontname = @"";
        if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
            fontname = @".SFUIDisplay-Ultralight";
        }
        else{
            fontname = @".HelveticaNeueInterface-UltraLightP2";
        }
        
        if (IS_IPHONE_4s) {
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:34];
            self.nameTextField.font = [UIFont fontWithName:fontname size:19];
            self.nameLabelHeight.constant = 44;
        }
        else if (IS_IPHONE_5){
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:33];
            self.nameTextField.font = [UIFont fontWithName:fontname size:20];
            self.nameLabelHeight.constant = 44;
        }
        else if (IS_IPHONE_6){
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:41];
            self.nameTextField.font = [UIFont fontWithName:fontname size:25];
            self.nameLabelHeight.constant = 50;
        }
        else{
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:45];
            self.nameTextField.font = [UIFont fontWithName:fontname size:28];
            self.nameLabelHeight.constant = 55;
        }
        
        if (self.nameTextField.layer.sublayers.count <= 2) {
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, self.nameLabelHeight.constant-3, self.nameTextField.frame.size.width, 1.0f);
            bottomBorder.backgroundColor = [UIColor colorWithWhite:1.0f
                                                             alpha:1.0f].CGColor;
            [self.nameTextField.layer addSublayer:bottomBorder];
            
            CALayer *bottomBorder2 = [CALayer layer];
            bottomBorder2.frame = CGRectMake(0.0f, self.nameLabelHeight.constant-3, self.passwordShow.frame.size.width, 1.0f);
            bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                              alpha:1.0f].CGColor;
            [self.passwordShow.layer addSublayer:bottomBorder2];
        }
        
        
        self.whtIsYourNameLabel.text = @"Hi!\nWhat's your name?";
        self.nameTextField.placeholder = @"name";
        self.nameTextField.text = self.name;
        [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.whtIsYourNameLabel.alpha = 1;
            self.nameTextField.alpha = 1;
            self.signUpView.alpha = 1;
            self.signInSignUpSwitchButton.alpha = 1;
            self.backButton.alpha = 1;
             self.nextButton.alpha = 1;
        } completion:^(BOOL finished) {
            [self.nameTextField becomeFirstResponder];
            self.viewType = SignUpView;
        }];
        
    }];
    
}

- (void)drawSignInScreenAnimated:(BOOL)animated{  // SIGN IN SCREEN
    double time;
    
    if (animated) {
        time = 0.2;
    }
    else{
        time = 0;
    }
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.signUpView.alpha = 0;
        self.facebookContainerView.alpha = 0;
        [self.signInSignUpSwitchButton setTitle:@"Dont have an account? Sign Up" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
        NSString *fontname = @"";
        if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
            fontname = @".SFUIDisplay-Ultralight";
        }
        else{
            fontname = @".HelveticaNeueInterface-UltraLightP2";
        }
        
        if (IS_IPHONE_4s) {
            self.signInLabel.font = [UIFont fontWithName:fontname size:34];
            self.signInEmailTextField.font = [UIFont fontWithName:fontname size:19];
            self.signInPasswordTextField.font = [UIFont fontWithName:fontname size:19];
            self.signInEmailLabelHeight.constant = 44;
            self.signInPasswordHeight.constant = 44;
        }
        else if (IS_IPHONE_5){
            self.signInLabel.font = [UIFont fontWithName:fontname size:33];
            self.signInEmailTextField.font = [UIFont fontWithName:fontname size:20];
            self.signInPasswordTextField.font = [UIFont fontWithName:fontname size:20];
            self.signInEmailLabelHeight.constant = 44;
            self.signInPasswordHeight.constant = 44;
        }
        else if (IS_IPHONE_6){
            self.signInLabel.font = [UIFont fontWithName:fontname size:41];
            self.signInEmailTextField.font = [UIFont fontWithName:fontname size:25];
            self.signInPasswordTextField.font = [UIFont fontWithName:fontname size:25];
            self.signInEmailLabelHeight.constant = 50;
            self.signInPasswordHeight.constant = 50;
        }
        else{
            self.signInLabel.font = [UIFont fontWithName:fontname size:45];
            self.signInEmailTextField.font = [UIFont fontWithName:fontname size:28];
            self.signInPasswordTextField.font = [UIFont fontWithName:fontname size:28];
            self.signInEmailLabelHeight.constant = 55;
            self.signInPasswordHeight.constant = 55;
        }
        
        if (self.signInEmailTextField.layer.sublayers.count <= 2) {
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, self.signInEmailLabelHeight.constant-3, self.signInEmailTextField.frame.size.width, 1.0f);
            bottomBorder.backgroundColor = [UIColor colorWithWhite:1.0f
                                                             alpha:1.0f].CGColor;
            [self.signInEmailTextField.layer addSublayer:bottomBorder];
            
            CALayer *bottomBorder2 = [CALayer layer];
            bottomBorder2.frame = CGRectMake(0.0f, self.signInPasswordHeight.constant-3, self.signInPasswordTextField.frame.size.width, 1.0f);
            bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                              alpha:1.0f].CGColor;
            [self.signInPasswordTextField.layer addSublayer:bottomBorder2];
        }
        
        
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.signInView.alpha = 1;
            self.signInSignUpSwitchButton.alpha = 1;
            self.backButton.alpha = 1;
        } completion:^(BOOL finished) {
            [self.signInEmailTextField becomeFirstResponder];
            self.viewType = SignInView;
            self.signUpScreen = SignUpOne;
            
        }];
    }];
}

- (void)drawFacebookScreenAnimated:(BOOL)animated{  // FACEBOOK SCREEN
    
    double time;
    
    if (animated) {
        time = 0.2;
    }
    else{
        time = 0;
    }
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.signUpView.alpha = 0;
        self.backButton.alpha = 0;
        self.signInView.alpha = 0;
        self.signInSignUpSwitchButton.alpha = 0;
    } completion:^(BOOL finished) {
        
        NSString *fontname = @"";
        NSString *fontTwo = @"";
        NSString *textfont = @"";
        if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
            fontname = @".SFUIDisplay-Ultralight";
            fontTwo = @".SFUIDisplay-Thin";
            textfont = @".SFUIText-Light";
        }
        else{
            fontTwo = @".HelveticaNeueInterface-Thin";
            fontname = @".HelveticaNeueInterface-UltraLightP2";
            textfont = @".HelveticaNeueInterface-UltraLightP2";
        }
        
        if (IS_IPHONE_4s) {
            self.welcomeLabel.font = [UIFont fontWithName:fontname size:44];
            self.onLabel.font = [UIFont fontWithName:fontname size:44];
            self.fuudLabel.font = [UIFont fontWithName:fontTwo size:44];
            [self.facebookButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [self.signUpWithEmailButton.titleLabel setFont:[UIFont fontWithName:textfont size:17]];
            [self.changeToLoginViewButton.titleLabel setFont:[UIFont fontWithName:textfont size:12]];
            
        }
        else if (IS_IPHONE_5){
            self.welcomeLabel.font = [UIFont fontWithName:fontname size:44];
            self.onLabel.font = [UIFont fontWithName:fontname size:44];
            self.fuudLabel.font = [UIFont fontWithName:fontTwo size:44];
            [self.facebookButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [self.signUpWithEmailButton.titleLabel setFont:[UIFont fontWithName:textfont size:17]];
            
            [self.changeToLoginViewButton.titleLabel setFont:[UIFont fontWithName:textfont size:12]];
        }
        else if (IS_IPHONE_6){
            self.welcomeLabel.font = [UIFont fontWithName:fontname size:50];
            self.onLabel.font = [UIFont fontWithName:fontname size:50];
            self.fuudLabel.font = [UIFont fontWithName:fontTwo size:50];
            [self.facebookButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [self.signUpWithEmailButton.titleLabel setFont:[UIFont fontWithName:textfont size:19]];
            
            [self.changeToLoginViewButton.titleLabel setFont:[UIFont fontWithName:textfont size:13]];
        }
        else{
            self.welcomeLabel.font = [UIFont fontWithName:fontname size:56];
            self.onLabel.font = [UIFont fontWithName:fontname size:56];
            self.fuudLabel.font = [UIFont fontWithName:fontTwo size:56];
            [self.facebookButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [self.signUpWithEmailButton.titleLabel setFont:[UIFont fontWithName:textfont size:21]];
            
            [self.changeToLoginViewButton.titleLabel setFont:[UIFont fontWithName:textfont size:15]];
        }
        
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.facebookContainerView.alpha = 1;
        } completion:^(BOOL finished) {
            self.viewType = FacebookView;
            self.signUpScreen = SignUpOne;
            
        }];
    }];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark REGISTER USER

- (void)registerUser{
    
    if (self.name.length>0 && self.password.length>0 && [self stringIsValidEmail:self.email]) {
        self.nextButton.enabled = NO;
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [[FAlertView sharedHUD] showActivityIndicatorOnView:self.view];
            
            [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
                if (error == nil) {
                    GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods objectAtIndex:0];
                    GMSPlace* place = likelihood.place;
                    NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:place];
                    [FCurrentUser signUpUserWithName:self.name email:self.email password:self.password andLocation:obj success:^(BOOL success) {
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
                    [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
                        if (error == nil) {
                            GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods objectAtIndex:0];
                            GMSPlace* place = likelihood.place;
                            NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:place];
                            [FCurrentUser signUpUserWithName:self.name email:self.email password:self.password andLocation:obj success:^(BOOL success) {
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
                            self.nextButton.enabled = YES;
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh Oh!" message:@"We couldn't get an accurate read on where you are. Try manually setting a location" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                FLocationPickerViewController *picker = [[FLocationPickerViewController alloc]initWithNibName:@"FLocationPickerViewController" bundle:[NSBundle mainBundle]];
                                picker.delegate = self;
                                picker.tag = emailTag;
                                picker.providesPresentationContextTransitionStyle = YES;
                                picker.definesPresentationContext = YES;
                                picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                                [self presentViewController:picker animated:YES completion:nil];
                            }];

                            [alert addAction:actionOk];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                    }];
                }
            }];
        }
        else{
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Location not detected" message:@"Location services are turned off on your device. Please go to settings and enable location services to use this feature or manually select a location." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *Select = [UIAlertAction actionWithTitle:@"Manually select a location" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.nextButton.enabled = YES;
                FLocationPickerViewController *picker = [[FLocationPickerViewController alloc]initWithNibName:@"FLocationPickerViewController" bundle:[NSBundle mainBundle]];
                picker.delegate = self;
                picker.providesPresentationContextTransitionStyle = YES;
                picker.definesPresentationContext = YES;
                picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [self presentViewController:picker animated:YES completion:nil];
            }];
            UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.nextButton.enabled = YES;
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alert addAction:Select];
            [alert addAction:settings];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
    else{
        if (self.name<=0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh Oh!" message:@"Your name seems to be invalid. Wanna go back and check?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.signUpScreen = SignUpOne;
                [self.nameTextField endEditing:YES];
                [self drawSignUpNameScreenAnimated:YES];
            }];
            UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"Never Mind" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:actionNo];
            [alert addAction:actionOk];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (self.password<=0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh Oh!" message:@"Your password seems to be invalid. Can you check if its correct?" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *actionok = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self.nameTextField becomeFirstResponder];
            }];
            [alert addAction:actionok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (![self stringIsValidEmail:self.email]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh Oh!" message:@"Your email seems to be invalid. Wanna go back and check?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.signUpScreen = SignUpTwo;
                [self.nameTextField endEditing:YES];
                [self drawSignUpEmailScreenAnimated:YES];
            }];
            UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"Never Mind" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:actionNo];
            [alert addAction:actionOk];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

-(void)FLocationPicker:(FLocationPickerViewController*)picker didFinishPickingPlace:(NSMutableDictionary*)location{
    [[FAlertView sharedHUD] showActivityIndicatorOnView:self.view];
    if (picker.tag == emailTag) {
        [FCurrentUser signUpUserWithName:self.name email:self.email password:self.password andLocation:location success:^(BOOL success) {
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
        [FCurrentUser connectWithFacebookFromViewController:self withLocation:location success:^(BOOL success) {
            self.signUpWithEmailButton.enabled = YES;
            self.facebookButton.enabled = YES;
            [[FAlertView sharedHUD] hideActivityIndicatorOnView];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FTabBarController*rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FTabBarController"];
            [appDelegate changeRootViewController:rootViewController];
        } failure:^(NSString *error) {
            self.signUpWithEmailButton.enabled = YES;
            self.facebookButton.enabled = YES;
            [[FAlertView sharedHUD] showHUDOnView:self.view withText:error wait:5];
        }];
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark VIDEO METHODS

- (void)initVideoBackground{
    
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"IMG_0101" ofType:@"mp4"]];
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [self.playerView.layer addSublayer:avPlayerLayer];
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[UIScreen mainScreen] bounds];
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,(id)[UIColor colorWithWhite:0 alpha:1].CGColor,nil];
    [self.gradientView.layer insertSublayer:gradient atIndex:0];
}

- (void)playerStartPlaying{
    
    [self.avplayer play];
    if (self.viewType == SignInView) {
        [self.signInEmailTextField becomeFirstResponder];
    }
    else if (self.viewType == SignUpView){
        [self.nameTextField becomeFirstResponder];
    }
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    
}

@end
