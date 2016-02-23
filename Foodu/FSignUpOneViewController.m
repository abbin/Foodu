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

@interface FSignUpOneViewController ()
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *whtIsYourNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showPasswordWidth;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (weak, nonatomic) IBOutlet UIButton *passwordShow;

@property (nonatomic, strong) AVPlayer *avplayer;
@end

@implementation FSignUpOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signUpScreen = SignUpOne;
    
    [self initVideoBackground];
    
    if (self.signType == SignUpView) {
        [self drawSignUpViewOneAnimated:NO];
    }
    else{
        [self drawSignInView];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)drawSignInView{
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.nameLabel.text.length>0) {
        self.nextButton.alpha = 1;
    }
    else{
        self.nextButton.alpha = 0;
    }
    
    if (self.signUpScreen == SignUpTwo) {
        if ([self NSStringIsValidEmail:self.nameLabel.text]) {
            self.nextButton.alpha = 1;
        }
        else{
            self.nextButton.alpha = 0;
        }
    }
}

- (IBAction)nameLabelDidChangeEditing:(UITextField *)sender {
    if (sender.text.length>0 && self.nextButton.alpha == 0) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    if (sender.text.length==0 && self.nextButton.alpha == 1) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nextButton.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
    if (self.signUpScreen == SignUpTwo) {
        if ([self NSStringIsValidEmail:self.nameLabel.text]) {
            self.nextButton.alpha = 1;
        }
        else{
            self.nextButton.alpha = 0;
        }
    }
}

- (IBAction)nextClicked:(UIButton *)sender {
    [self.nameLabel endEditing:YES];
    if (self.nameLabel.text.length>0) {
        switch (self.signUpScreen) {
            case SignUpOne:
                self.signUpScreen = SignUpTwo;
                self.name = self.nameLabel.text;
                [self drawSignUpTwoAnimated:YES];
                break;
            case SignUpTwo:
                self.signUpScreen = SignUpThree;
                self.email = self.nameLabel.text;
                [self drawSignUpThreeAnimated:YES];
                break;
            case SignUpThree:
                self.password = self.nameLabel.text;
                [self registerUser];
                break;
            default:
                break;
        }
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)drawSignUpThreeAnimated:(BOOL)animated{
    double time;
    
    if (animated) {
        time = 0.2;
    }
    else{
        time = 0;
    }
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.whtIsYourNameLabel.alpha = 0;
        self.nameLabel.alpha = 0;
        self.nextButton.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.nameLabel setSecureTextEntry:YES];
        self.nameLabel.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.nameLabel setKeyboardType:UIKeyboardTypeDefault];
        
        NSString *fontname = @"";
        if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
            fontname = @".SFUIDisplay-Ultralight";
        }
        else{
            fontname = @".HelveticaNeueInterface-UltraLightP2";
        }
        
        if (IS_IPHONE_4s) {
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:34];
            self.nameLabel.font = [UIFont fontWithName:fontname size:19];
            self.nameLabelHeight.constant = 44;
        }
        else if (IS_IPHONE_5){
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:33];
            self.nameLabel.font = [UIFont fontWithName:fontname size:20];
            self.nameLabelHeight.constant = 44;
        }
        else if (IS_IPHONE_6){
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:41];
            self.nameLabel.font = [UIFont fontWithName:fontname size:25];
            self.nameLabelHeight.constant = 50;
        }
        else{
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:45];
            self.nameLabel.font = [UIFont fontWithName:fontname size:28];
            self.nameLabelHeight.constant = 55;
        }
        
        if (self.nameLabel.layer.sublayers.count == 2) {
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, self.nameLabelHeight.constant-3, self.nameLabel.frame.size.width, 1.0f);
            bottomBorder.backgroundColor = [UIColor colorWithWhite:1.0f
                                                             alpha:1.0f].CGColor;
            [self.nameLabel.layer addSublayer:bottomBorder];
            
            CALayer *bottomBorder2 = [CALayer layer];
            bottomBorder2.frame = CGRectMake(0.0f, self.nameLabelHeight.constant-3, self.passwordShow.frame.size.width, 1.0f);
            bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                             alpha:1.0f].CGColor;
            [self.passwordShow.layer addSublayer:bottomBorder2];
            
        }
        
        self.nextButton.layer.cornerRadius = 5;
        self.nextButton.layer.masksToBounds = YES;
        
        self.whtIsYourNameLabel.text = @"You'll need a password";
        self.nameLabel.placeholder = @"password";
        self.nameLabel.text = self.password;
        [self.nextButton setTitle:@"Register" forState:UIControlStateNormal];
        
        self.showPasswordWidth.constant = 31;
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.whtIsYourNameLabel.alpha = 1;
            self.nameLabel.alpha = 1;
        } completion:^(BOOL finished) {
            
            [self.nameLabel becomeFirstResponder];
        }];
        
    }];

}

-(void)registerUser{
    if (self.name.length>0 && self.password.length>0 && [self NSStringIsValidEmail:self.email]) {
        [self.activityIndicator startAnimating];
        [FUser signUpUserWithName:self.name email:self.email password:self.password success:^(BOOL success) {
            [FUser didFinishFirstLaunch];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             FTabBarController*rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FTabBarController"];
            [appDelegate changeRootViewController:rootViewController];
        } failure:^(NSString *error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh Oh!" message:error preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];

            [alert addAction:actionOk];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
    else{
        if (self.name<=0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh Oh!" message:@"Your name seems to be invalid. Wanna go back and check?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.signUpScreen = SignUpOne;
                [self.nameLabel endEditing:YES];
                [self drawSignUpViewOneAnimated:YES];
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
                [self.nameLabel becomeFirstResponder];
            }];
            [alert addAction:actionok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (![self NSStringIsValidEmail:self.email]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh Oh!" message:@"Your email seems to be invalid. Wanna go back and check?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.signUpScreen = SignUpTwo;
                [self.nameLabel endEditing:YES];
                [self drawSignUpTwoAnimated:YES];
            }];
            UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"Never Mind" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:actionNo];
            [alert addAction:actionOk];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

-(void)drawSignUpTwoAnimated:(BOOL)animated{

    double time;
    
    if (animated) {
        time = 0.2;
    }
    else{
        time = 0;
    }
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.whtIsYourNameLabel.alpha = 0;
        self.nameLabel.alpha = 0;
        self.nextButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.showPasswordWidth.constant = 0;
        [self.view layoutIfNeeded];
        [self.nameLabel setKeyboardType:UIKeyboardTypeEmailAddress];
        self.nameLabel.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.nameLabel setSecureTextEntry:NO];
        
        NSString *fontname = @"";
        if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
            fontname = @".SFUIDisplay-Ultralight";
        }
        else{
            fontname = @".HelveticaNeueInterface-UltraLightP2";
        }
        
        if (IS_IPHONE_4s) {
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:34];
            self.nameLabel.font = [UIFont fontWithName:fontname size:19];
            self.nameLabelHeight.constant = 44;
        }
        else if (IS_IPHONE_5){
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:33];
            self.nameLabel.font = [UIFont fontWithName:fontname size:20];
            self.nameLabelHeight.constant = 44;
        }
        else if (IS_IPHONE_6){
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:41];
            self.nameLabel.font = [UIFont fontWithName:fontname size:25];
            self.nameLabelHeight.constant = 50;
        }
        else{
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:45];
            self.nameLabel.font = [UIFont fontWithName:fontname size:28];
            self.nameLabelHeight.constant = 55;
        }
        
        if (self.nameLabel.layer.sublayers.count == 2) {
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, self.nameLabelHeight.constant-3, self.nameLabel.frame.size.width, 1.0f);
            bottomBorder.backgroundColor = [UIColor colorWithWhite:1.0f
                                                             alpha:1.0f].CGColor;
            [self.nameLabel.layer addSublayer:bottomBorder];
            
            CALayer *bottomBorder2 = [CALayer layer];
            bottomBorder2.frame = CGRectMake(0.0f, self.nameLabelHeight.constant-3, self.passwordShow.frame.size.width, 1.0f);
            bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                              alpha:1.0f].CGColor;
            [self.passwordShow.layer addSublayer:bottomBorder2];
        }
        
        self.nextButton.layer.cornerRadius = 5;
        self.nextButton.layer.masksToBounds = YES;
        
        self.whtIsYourNameLabel.text = @"Now,\nWhat's your email?";
        self.nameLabel.placeholder = @"email";
        self.nameLabel.text = self.email;
        [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.whtIsYourNameLabel.alpha = 1;
            self.nameLabel.alpha = 1;
        } completion:^(BOOL finished) {

            [self.nameLabel becomeFirstResponder];
        }];
        
    }];
}

-(void)drawSignUpViewOneAnimated:(BOOL)animated{
    
    double time;
    
    if (animated) {
        time = 0.2;
    }
    else{
        time = 0;
    }
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.whtIsYourNameLabel.alpha = 0;
        self.nameLabel.alpha = 0;
        self.nextButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.showPasswordWidth.constant = 0;
        [self.view layoutIfNeeded];
        [self.nameLabel setKeyboardType:UIKeyboardTypeDefault];
        self.nameLabel.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [self.nameLabel setSecureTextEntry:NO];
        
        NSString *fontname = @"";
        if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
            fontname = @".SFUIDisplay-Ultralight";
        }
        else{
            fontname = @".HelveticaNeueInterface-UltraLightP2";
        }
        
        if (IS_IPHONE_4s) {
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:34];
            self.nameLabel.font = [UIFont fontWithName:fontname size:19];
            self.nameLabelHeight.constant = 44;
        }
        else if (IS_IPHONE_5){
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:33];
            self.nameLabel.font = [UIFont fontWithName:fontname size:20];
            self.nameLabelHeight.constant = 44;
        }
        else if (IS_IPHONE_6){
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:41];
            self.nameLabel.font = [UIFont fontWithName:fontname size:25];
            self.nameLabelHeight.constant = 50;
        }
        else{
            self.whtIsYourNameLabel.font = [UIFont fontWithName:fontname size:45];
            self.nameLabel.font = [UIFont fontWithName:fontname size:28];
            self.nameLabelHeight.constant = 55;
        }
        
        if (self.nameLabel.layer.sublayers.count == 2) {
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, self.nameLabelHeight.constant-3, self.nameLabel.frame.size.width, 1.0f);
            bottomBorder.backgroundColor = [UIColor colorWithWhite:1.0f
                                                             alpha:1.0f].CGColor;
            [self.nameLabel.layer addSublayer:bottomBorder];
            
            CALayer *bottomBorder2 = [CALayer layer];
            bottomBorder2.frame = CGRectMake(0.0f, self.nameLabelHeight.constant-3, self.passwordShow.frame.size.width, 1.0f);
            bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                              alpha:1.0f].CGColor;
            [self.passwordShow.layer addSublayer:bottomBorder2];
        }
        
        self.nextButton.layer.cornerRadius = 5;
        self.nextButton.layer.masksToBounds = YES;
        
        self.whtIsYourNameLabel.text = @"Hi!\nWhat's your name?";
        self.nameLabel.placeholder = @"name";
        self.nameLabel.text = self.name;
        [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.whtIsYourNameLabel.alpha = 1;
            self.nameLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [self.nameLabel becomeFirstResponder];
        }];

    }];
    
}

-(void)initVideoBackground{
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MyMovie" ofType:@"mp4"]];
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

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.avplayer pause];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.avplayer play];
    [self.nameLabel becomeFirstResponder];
}

- (void)playerStartPlaying
{
    [self.avplayer play];
    [self.nameLabel becomeFirstResponder];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
- (IBAction)backButtonClicked:(UIButton *)sender {
    switch (self.signUpScreen) {
        case SignUpThree:
            self.signUpScreen = SignUpTwo;
            [self.nameLabel endEditing:YES];
            [self drawSignUpTwoAnimated:YES];
            break;
        case SignUpTwo:
            self.signUpScreen = SignUpOne;
            [self.nameLabel endEditing:YES];
            [self drawSignUpViewOneAnimated:YES];
            break;
        case SignUpOne:
            //sender.hidden = YES;
            break;
            
        default:
            break;
    }
}
- (IBAction)showPassword:(UIButton *)sender {
    [self.nameLabel endEditing:YES];
    [self.nameLabel setSecureTextEntry:NO];
    [self.nameLabel becomeFirstResponder];
}

@end
