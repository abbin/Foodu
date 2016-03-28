//
//  FPageFOURViewController.m
//  Foodu
//
//  Created by Abbin on 21/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FPageFOURViewController.h"
#import "AppDelegate.h"
#import "FTabBarController.h"

@interface FPageFOURViewController ()
@property (weak, nonatomic) IBOutlet UIView *facebookContainerView;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *promiseLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectEmailButton;

@end

@implementation FPageFOURViewController

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
    
    [self.facebookButton.titleLabel setFont:[UIFont fontWithName:textfont size:[UIScreen mainScreen].bounds.size.width/25]];
    [self.connectEmailButton.titleLabel setFont:[UIFont fontWithName:textfont size:[UIScreen mainScreen].bounds.size.width/25]];
    
    [self.headingLabel setFont:[UIFont fontWithName:fontTwo size:[UIScreen mainScreen].bounds.size.width/16]];
    [self.subjectLabel setFont:[UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/23]];
    [self.promiseLabel setFont:[UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/23]];
    
    self.facebookContainerView.layer.cornerRadius = self.facebookContainerView.frame.size.height/16;
    self.facebookContainerView.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookClicked:(UIButton *)sender {
    [[FAlertView sharedHUD] showActivityIndicatorOnView:self.view];
    self.connectEmailButton.enabled = NO;
    self.facebookButton.enabled = NO;
    [FCurrentUser connectWithFacebookFromViewController:self withLocation:self.location success:^(BOOL success) {
        self.connectEmailButton.enabled = YES;
        self.facebookButton.enabled = YES;
        [[FAlertView sharedHUD] hideActivityIndicatorOnView];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FTabBarController*rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FTabBarController"];
        [appDelegate changeRootViewController:rootViewController];
    } failure:^(NSString *error) {
        self.connectEmailButton.enabled = YES;
        self.facebookButton.enabled = YES;
        [[FAlertView sharedHUD] showHUDOnView:self.view withText:error wait:5];
    }];
}

- (IBAction)emailButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(FPageFOURSwitchToEmailSignUp:withLocation:)]) {
        [self.delegate FPageFOURSwitchToEmailSignUp:self withLocation:self.location];
    }
}

@end
