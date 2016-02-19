//
//  FSignUpOneViewController.m
//  Foodu
//
//  Created by Abbin Varghese on 19/02/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FSignUpOneViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface FSignUpOneViewController ()
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@property (nonatomic, strong) AVPlayer *avplayer;
@end

@implementation FSignUpOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVideoBackground];
    
    if (self.signType == SignUpView) {
        [self drawSignUpView];
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
- (IBAction)nameLabelDidChangeEditing:(UITextField *)sender {
    if (sender.text.length>0 && self.nextButton.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
}

- (IBAction)nextClicked:(UIButton *)sender {
    if (self.nameLabel.text.length>0) {
        
    }
}

-(void)drawSignUpView{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.nameLabel.frame.size.height-3, self.nameLabel.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:1.0f
                                                     alpha:1.0f].CGColor;
    [self.nameLabel.layer addSublayer:bottomBorder];
    
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.layer.masksToBounds = YES;
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

@end
