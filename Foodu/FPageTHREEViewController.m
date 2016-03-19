//
//  FPageTHREEViewController.m
//  Foodu
//
//  Created by Abbin on 17/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FPageTHREEViewController.h"

@interface FPageTHREEViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *autoButton;
@property (weak, nonatomic) IBOutlet UIButton *manualButton;

@end

@implementation FPageTHREEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationManagerdidChangeAuthorizationStatus:)
                                                 name:@"locationManagerdidChangeAuthorizationStatus"
                                               object:nil];
    
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
    [[FCurrentUser sharedUser] askForLocationPermision];
}
- (IBAction)manualButtonClicked:(UIButton *)sender {
    FLocationPickerViewController *picker = [[FLocationPickerViewController alloc]initWithNibName:@"FLocationPickerViewController" bundle:[NSBundle mainBundle]];
    picker.delegate = self;
    picker.providesPresentationContextTransitionStyle = YES;
    picker.definesPresentationContext = YES;
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)FLocationPicker:(FLocationPickerViewController *)picker didFinishPickingPlace:(FLocationObject *)location{
    [FCurrentUser sharedUser].userlocation = location;
}

- (void) locationManagerdidChangeAuthorizationStatus:(NSNotification *) notification{
    NSDictionary *dict = notification.userInfo;
    if ([[dict objectForKey:@"CLAuthorizationStatus"] integerValue] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
            GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods objectAtIndex:0];
            GMSPlace* place = likelihood.place;
            FLocationObject *obj = [[FLocationObject alloc]initWithGMSPlace:place];
            [FCurrentUser sharedUser].userlocation = obj;
        }];
    }
}


@end
