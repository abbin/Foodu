//
//  FPageTHREEViewController.m
//  Foodu
//
//  Created by Abbin on 17/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FPageTHREEViewController.h"
#import "AppDelegate.h"

@interface FPageTHREEViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *autoButton;
@property (weak, nonatomic) IBOutlet UIButton *manualButton;
@property(nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation FPageTHREEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationManagerdidChangeAuthorizationStatus:)
                                                 name:@"locationManagerdidChangeAuthorizationStatus"
                                               object:nil];
    
    NSString *fontname = @"";
    //NSString *fontTwo = @"";
    NSString *textfont = @"";
    if ([UIFont fontWithName:@".SFUIDisplay-Thin" size:10]) {
        fontname = @".SFUIDisplay-Thin";
       // fontTwo = @".SFUIDisplay-Light";
        textfont = @".SFUIText-Light";
    }
    else{
        //fontTwo = @".HelveticaNeueInterface-Thin";
        fontname = @".HelveticaNeueInterface-UltraLightP2";
        textfont = @".HelveticaNeueInterface-UltraLightP2";
    }
    
    [self.label setFont:[UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/18]];
    
    self.label.text = @"To get started, please set your location\n(or let us do it for you)";
    
    [self.autoButton.titleLabel setFont:[UIFont fontWithName:textfont size:[UIScreen mainScreen].bounds.size.width/25]];
    [self.view layoutIfNeeded];
    self.autoButton.layer.cornerRadius = self.autoButton.frame.size.height/4;
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Location not detected" message:@"Location services are turned off on your device. Please go to settings and enable location services to use this feature or manually select a location." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alert addAction:cancel];
            [alert addAction:settings];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager startUpdatingLocation];
        }
    }
    else{
        [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Check your internet connection" wait:0];
    }
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.autoButton setTitle:@"Detecting Location..." forState:UIControlStateNormal];
        self.autoButton.enabled = NO;
        self.manualButton.enabled = NO;
        [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
            if (error == nil) {
                GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods objectAtIndex:0];
                GMSPlace* place = likelihood.place;
                NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:place];
                if ([self.delegate respondsToSelector:@selector(THREEClickedNext:withLocation:)]) {
                    [self.delegate THREEClickedNext:self withLocation:obj];
                }
            }
            else{
                [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
                    if (error == nil) {
                        GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods objectAtIndex:0];
                        GMSPlace* place = likelihood.place;
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:place];
                        if ([self.delegate respondsToSelector:@selector(THREEClickedNext:withLocation:)]) {
                            [self.delegate THREEClickedNext:self withLocation:obj];
                        }
                    }
                    else{
                        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Failed to get your current location" message:@"Try to manually select location" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            FLocationPickerViewController *picker = [[FLocationPickerViewController alloc]initWithNibName:@"FLocationPickerViewController" bundle:[NSBundle mainBundle]];
                            picker.delegate = self;
                            picker.providesPresentationContextTransitionStyle = YES;
                            picker.definesPresentationContext = YES;
                            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                            [self presentViewController:picker animated:YES completion:nil];
                        }];
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    
                }];
            }
            
        }];
    }
}


- (IBAction)manualButtonClicked:(UIButton *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable) {
        FLocationPickerViewController *picker = [[FLocationPickerViewController alloc]initWithNibName:@"FLocationPickerViewController" bundle:[NSBundle mainBundle]];
        picker.delegate = self;
        picker.providesPresentationContextTransitionStyle = YES;
        picker.definesPresentationContext = YES;
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Check your internet connection" wait:0];
    }
}

-(void)FLocationPicker:(FLocationPickerViewController *)picker didFinishPickingPlace:(NSMutableDictionary *)location{
    if ([self.delegate respondsToSelector:@selector(THREEClickedNext:withLocation:)]) {
        [self.delegate THREEClickedNext:self withLocation:location];
    }
}

- (void) locationManagerdidChangeAuthorizationStatus:(NSNotification *) notification{
    NSDictionary *dict = notification.userInfo;
    if ([[dict objectForKey:@"CLAuthorizationStatus"] integerValue] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.autoButton setTitle:@"Detecting Location..." forState:UIControlStateNormal];
        self.autoButton.enabled = NO;
        self.manualButton.enabled = NO;
        [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
            if (error == nil) {
                GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods objectAtIndex:0];
                GMSPlace* place = likelihood.place;
                NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:place];
                if ([self.delegate respondsToSelector:@selector(THREEClickedNext:withLocation:)]) {
                    [self.delegate THREEClickedNext:self withLocation:obj];
                }
            }
            else{
                [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
                    if (error == nil) {
                        GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods objectAtIndex:0];
                        GMSPlace* place = likelihood.place;
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:place];
                        if ([self.delegate respondsToSelector:@selector(THREEClickedNext:withLocation:)]) {
                            [self.delegate THREEClickedNext:self withLocation:obj];
                        }
                    }
                    else{
                        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Failed to get your current location" message:@"Try to manually select location" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            FLocationPickerViewController *picker = [[FLocationPickerViewController alloc]initWithNibName:@"FLocationPickerViewController" bundle:[NSBundle mainBundle]];
                            picker.delegate = self;
                            picker.providesPresentationContextTransitionStyle = YES;
                            picker.definesPresentationContext = YES;
                            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                            [self presentViewController:picker animated:YES completion:nil];
                        }];
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    
                }];
            }
        
        }];
    }
}


@end
