//
//  FSignUpViewController.m
//  Foodu
//
//  Created by Abbin Varghese on 09/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FSignUpViewController.h"
#import <AVFoundation/AVFoundation.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface FSignUpViewController ()

@property (nonatomic, strong) AVPlayer *avplayer;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *nameBackGround;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fuudLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleConstrain;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UILabel *fuudLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signButtonLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signButtonRight;

@end

@implementation FSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self initVideoBackground];
    
    [self drawTextFields];
}

-(void)drawTextFields{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 43.0f, self.nameField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:1.0f
                                                     alpha:1.0f].CGColor;
    [self.nameField.layer addSublayer:bottomBorder];
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, 43.0f, self.emailField.frame.size.width, 1.0f);
    bottomBorder2.backgroundColor = [UIColor colorWithWhite:1.0f
                                                      alpha:1.0f].CGColor;
    [self.emailField.layer addSublayer:bottomBorder2];
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, 43.0f, self.passwordField.frame.size.width, 1.0f);
    bottomBorder3.backgroundColor = [UIColor colorWithWhite:1.0f
                                                      alpha:1.0f].CGColor;
    [self.passwordField.layer addSublayer:bottomBorder3];
    
    CALayer *bottomBorder4 = [CALayer layer];
    bottomBorder4.frame = CGRectMake(0.0f, 43.0f, self.confirmPasswordField.frame.size.width, 1.0f);
    bottomBorder4.backgroundColor = [UIColor colorWithWhite:1.0f
                                                      alpha:1.0f].CGColor;
    [self.confirmPasswordField.layer addSublayer:bottomBorder4];
    
    if (IS_IPHONE_6) {
//        self.fuudLabelTop.constant = self.playerView.frame.size.height/15;
//        self.middleConstrain.constant = self.playerView.frame.size.height/15;
//        int sideConstant = 25;
//        self.nameLeft.constant = sideConstant;
//        self.nameRight.constant = sideConstant;
//        self.emailLeft.constant = sideConstant;
//        self.emailRight.constant = sideConstant;
//        self.passwordLeft.constant = sideConstant;
//        self.passwordRight.constant = sideConstant;
//        self.confirmPasswordLeft.constant = sideConstant;
//        self.confirmPasswordRight.constant = sideConstant;
//        self.signButtonLeft.constant = sideConstant;
//        self.signButtonRight.constant = sideConstant;
    }
    else if (IS_IPHONE_5){
        self.fuudLabelTop.constant = self.playerView.frame.size.height/30;
        self.middleConstrain.constant = self.playerView.frame.size.height/30;
        [self.fuudLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Ultralight" size:70]];
        int sideConstant = 10;
        self.nameLeft.constant = sideConstant;
        self.nameRight.constant = sideConstant;
        self.emailLeft.constant = sideConstant;
        self.emailRight.constant = sideConstant;
        self.passwordLeft.constant = sideConstant;
        self.passwordRight.constant = sideConstant;
        self.confirmPasswordLeft.constant = sideConstant;
        self.confirmPasswordRight.constant = sideConstant;
        self.signButtonLeft.constant = sideConstant;
        self.signButtonRight.constant = sideConstant;
    }
    else if (IS_IPHONE_4s){
        self.fuudLabelTop.constant = self.playerView.frame.size.height/120;
        self.middleConstrain.constant = self.playerView.frame.size.height/120;
        [self.fuudLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Ultralight" size:60]];
        int sideConstant = 10;
        self.nameLeft.constant = sideConstant;
        self.nameRight.constant = sideConstant;
        self.emailLeft.constant = sideConstant;
        self.emailRight.constant = sideConstant;
        self.passwordLeft.constant = sideConstant;
        self.passwordRight.constant = sideConstant;
        self.confirmPasswordLeft.constant = sideConstant;
        self.confirmPasswordRight.constant = sideConstant;
        self.signButtonLeft.constant = sideConstant;
        self.signButtonRight.constant = sideConstant;
    }
    else if (IS_IPHONE_6Plus){
        self.fuudLabelTop.constant = self.playerView.frame.size.height/15;
        self.middleConstrain.constant = self.playerView.frame.size.height/15;
    }
    else{
        self.fuudLabelTop.constant = self.playerView.frame.size.height/15;
        self.middleConstrain.constant = self.playerView.frame.size.height/15;
    }
}

-(void)initVideoBackground{
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Untitled" ofType:@"mov"]];
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
}

@end
