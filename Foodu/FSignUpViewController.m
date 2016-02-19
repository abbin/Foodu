//
//  FSignUpViewController.m
//  Foodu
//
//  Created by Abbin Varghese on 09/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FSignUpViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "FTabBarController.h"

@interface FSignUpViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) AVPlayer *avplayer;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *nameBackGround;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *buttomButton;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UILabel *fuudLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPassHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facebookButtonHeight;


@property (assign, nonatomic) int originalConstant;
@property (assign, nonatomic) int adustmentNeeded;

@property (weak, nonatomic) IBOutlet UILabel *orSignUpLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@end

@implementation FSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self initVideoBackground];
    
    if (self.FSignType == FSignUpView) {
        [self drawSignUpView];
    }
    else{
        [self drawSignInView];
    }
    
}

-(void)drawSignInView{
    int buttonAndTextFieldHeight = 0;
    if (IS_IPHONE_5){
        [self.fuudLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Ultralight" size:70]];
        
        self.adustmentNeeded = 20;
        
        self.topConstrain.constant = 10;
        self.bottomConstrain.constant = 0;
        buttonAndTextFieldHeight = 40;
        self.nameHeight.constant = 0;
        self.emailHeight.constant = buttonAndTextFieldHeight;
        self.passwordHeight.constant = buttonAndTextFieldHeight;
        self.confirmPassHeight.constant = 0;
        self.signButtonHeight.constant = buttonAndTextFieldHeight;
        self.facebookButtonHeight.constant = buttonAndTextFieldHeight;
    }
    else if (IS_IPHONE_4s){
        
    }
    else if (IS_IPHONE_6Plus){
        [self.fuudLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Ultralight" size:90]];
        self.topConstrain.constant = 20;
        self.bottomConstrain.constant = 10;
        self.adustmentNeeded = 20;
        buttonAndTextFieldHeight = 60;
        self.nameHeight.constant = 0;
        self.emailHeight.constant = buttonAndTextFieldHeight;
        self.passwordHeight.constant = buttonAndTextFieldHeight;
        self.confirmPassHeight.constant = 0;
        self.signButtonHeight.constant = buttonAndTextFieldHeight;
        self.facebookButtonHeight.constant = buttonAndTextFieldHeight;
    }
    else{
        self.topConstrain.constant = 20;
        self.bottomConstrain.constant = 10;
        self.adustmentNeeded = 20;  // 20 IS NO ADJUSTMENT
        buttonAndTextFieldHeight = 50;
        self.nameHeight.constant = 0;
        self.emailHeight.constant = buttonAndTextFieldHeight;
        self.passwordHeight.constant = buttonAndTextFieldHeight;
        self.confirmPassHeight.constant = 0;
        self.signButtonHeight.constant = buttonAndTextFieldHeight;
        self.facebookButtonHeight.constant = buttonAndTextFieldHeight;
    }
    
    self.originalConstant = self.topConstrain.constant;
    
    if (self.emailField.layer.sublayers.count == 0) {
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, buttonAndTextFieldHeight-3, self.nameField.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:1.0f
                                                         alpha:1.0f].CGColor;
        [self.nameField.layer addSublayer:bottomBorder];
        
        CALayer *bottomBorder2 = [CALayer layer];
        bottomBorder2.frame = CGRectMake(0.0f, buttonAndTextFieldHeight-3, self.emailField.frame.size.width, 1.0f);
        bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                          alpha:1.0f].CGColor;
        [self.emailField.layer addSublayer:bottomBorder2];
        
        CALayer *bottomBorder3 = [CALayer layer];
        bottomBorder3.frame = CGRectMake(0.0f, buttonAndTextFieldHeight-3, self.passwordField.frame.size.width, 1.0f);
        bottomBorder3.backgroundColor = [UIColor colorWithWhite:1.0f
                                                          alpha:1.0f].CGColor;
        [self.passwordField.layer addSublayer:bottomBorder3];
        
        CALayer *bottomBorder4 = [CALayer layer];
        bottomBorder4.frame = CGRectMake(0.0f, buttonAndTextFieldHeight-3, self.confirmPasswordField.frame.size.width, 1.0f);
        bottomBorder4.backgroundColor = [UIColor colorWithWhite:1.0f
                                                          alpha:1.0f].CGColor;
        [self.confirmPasswordField.layer addSublayer:bottomBorder4];

    }
    [self.signButton setTitle:@"Sign In" forState:UIControlStateNormal];
    self.orSignUpLabel.text = @"or Sign in with";
    [self.buttomButton setTitle:@"Dont have an account? Sign Up" forState:UIControlStateNormal];
}

-(void)drawSignUpView{
    int buttonAndTextFieldHeight = 0;
    if (IS_IPHONE_5){
        [self.fuudLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Ultralight" size:70]];
        
        self.adustmentNeeded = -65;
        
        self.topConstrain.constant = 10;
        self.bottomConstrain.constant = 0;
        buttonAndTextFieldHeight = 40;
        self.nameHeight.constant = buttonAndTextFieldHeight;
        self.emailHeight.constant = buttonAndTextFieldHeight;
        self.passwordHeight.constant = buttonAndTextFieldHeight;
        self.confirmPassHeight.constant = buttonAndTextFieldHeight;
        self.signButtonHeight.constant = buttonAndTextFieldHeight;
        self.facebookButtonHeight.constant = buttonAndTextFieldHeight;
    }
    else if (IS_IPHONE_4s){
        
    }
    else if (IS_IPHONE_6Plus){
        [self.fuudLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Ultralight" size:90]];
        self.topConstrain.constant = 20;
        self.bottomConstrain.constant = 10;
        self.adustmentNeeded = -45;
        buttonAndTextFieldHeight = 60;
        self.nameHeight.constant = buttonAndTextFieldHeight;
        self.emailHeight.constant = buttonAndTextFieldHeight;
        self.passwordHeight.constant = buttonAndTextFieldHeight;
        self.confirmPassHeight.constant = buttonAndTextFieldHeight;
        self.signButtonHeight.constant = buttonAndTextFieldHeight;
        self.facebookButtonHeight.constant = buttonAndTextFieldHeight;
    }
    else{
        self.topConstrain.constant = 20;
        self.bottomConstrain.constant = 10;
        self.adustmentNeeded = -45;
        buttonAndTextFieldHeight = 50;
        self.nameHeight.constant = buttonAndTextFieldHeight;
        self.emailHeight.constant = buttonAndTextFieldHeight;
        self.passwordHeight.constant = buttonAndTextFieldHeight;
        self.confirmPassHeight.constant = buttonAndTextFieldHeight;
        self.signButtonHeight.constant = buttonAndTextFieldHeight;
        self.facebookButtonHeight.constant = buttonAndTextFieldHeight;
    }
    
    self.originalConstant = self.topConstrain.constant;
    
    if ((self.emailField.layer.sublayers.count == 0)) {
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, buttonAndTextFieldHeight-3, self.nameField.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:1.0f
                                                         alpha:1.0f].CGColor;
        [self.nameField.layer addSublayer:bottomBorder];
        
        CALayer *bottomBorder2 = [CALayer layer];
        bottomBorder2.frame = CGRectMake(0.0f, buttonAndTextFieldHeight-3, self.emailField.frame.size.width, 1.0f);
        bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                          alpha:1.0f].CGColor;
        [self.emailField.layer addSublayer:bottomBorder2];
        
        CALayer *bottomBorder3 = [CALayer layer];
        bottomBorder3.frame = CGRectMake(0.0f, buttonAndTextFieldHeight-3, self.passwordField.frame.size.width, 1.0f);
        bottomBorder3.backgroundColor = [UIColor colorWithWhite:1.0f
                                                          alpha:1.0f].CGColor;
        [self.passwordField.layer addSublayer:bottomBorder3];
        
        CALayer *bottomBorder4 = [CALayer layer];
        bottomBorder4.frame = CGRectMake(0.0f, buttonAndTextFieldHeight-3, self.confirmPasswordField.frame.size.width, 1.0f);
        bottomBorder4.backgroundColor = [UIColor colorWithWhite:1.0f
                                                          alpha:1.0f].CGColor;
        [self.confirmPasswordField.layer addSublayer:bottomBorder4];
    }
    
    [self.signButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    self.orSignUpLabel.text = @"or Sign Up with";
    [self.buttomButton setTitle:@"Already have an account? Sign In" forState:UIControlStateNormal];
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
    [self.nameBackGround.layer insertSublayer:gradient atIndex:0];

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playerStartPlaying
{
    [self.avplayer play];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.topConstrain.constant = self.originalConstant;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
        self.fuudLabel.alpha = 1;
        self.orSignUpLabel.alpha = 1;
        self.facebookButton.alpha = 1;
    } completion:nil];
}
- (IBAction)signButtonClicked:(UIButton *)sender {
    self.topConstrain.constant = self.originalConstant;
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
        self.fuudLabel.alpha = 1;
        self.orSignUpLabel.alpha = 1;
        self.facebookButton.alpha = 1;
    } completion:nil];
    
    [self.activityIndicator startAnimating];
    
//    [FUserDefaults signUpUserWithName:self.nameField.text email:self.emailField.text password:self.confirmPasswordField.text success:^(KiiUser *user) {
//        [self.activityIndicator stopAnimating];
//    } failure:^(NSString *error) {
//        [self.activityIndicator stopAnimating];
//    }];
    
}

-(BOOL)doesPasswordsMatch{
    NSString *str1 = self.passwordField.text;
    NSRange range = [str1 rangeOfString:self.confirmPasswordField.text];
    
    return YES;
}

- (IBAction)confirmPasswordDidChange:(UITextField *)sender {
    [self doesPasswordsMatch];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.topConstrain.constant = self.adustmentNeeded;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
        if (self.FSignType == FSignUpView) {
            self.fuudLabel.alpha = 0;
        }
        self.orSignUpLabel.alpha = 0;
        self.facebookButton.alpha = 0;
    } completion:nil];
}
- (IBAction)facebookButtonClicked:(UIButton *)sender {
    
}

- (IBAction)signInButtonClicked:(UIButton *)sender {
    if (self.FSignType == FSignInView) {
        self.FSignType = FSignUpView;
        [self drawSignUpView];
    }
    else{
        self.FSignType = FSignInView;
        [self drawSignInView];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
