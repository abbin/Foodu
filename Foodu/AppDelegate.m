//
//  AppDelegate.m
//  Foodu
//
//  Created by Abbin on 04/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "AppDelegate.h"
#import "FSignUpOneViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FFirstLaunchViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@import GoogleMaps;
@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)changeRootViewController:(UIViewController*)viewController {
    self.window.rootViewController = viewController;
}

- (void) reachabilityChanged:(NSNotification *)note{
    Reachability* curReach = [note object];
    if (curReach.currentReachabilityStatus == NotReachable) {
        [[FAlertView sharedHUD]  showHUDOnView:self.window.rootViewController.view withText:@"No Internet" wait:0];
    }
    else{
        [[FAlertView sharedHUD] hideHUDWithText:@"Connected" wait:2];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"Ph3YlcRPtxvK4Y8yDAARLosc5lvu4ErH8XZm6aX7";
        
        configuration.clientKey = @"ccUN1ZcZrfcxrLVLtLqseB62htLPxxkAvr5DovNa";
        
        configuration.server = @"https://foodu.herokuapp.com/parse";
        
    }]];
    
    
    
    [Fabric with:@[[Crashlytics class]]];
    
    [FBSDKLoginButton class];
    [GMSServices provideAPIKey:@"AIzaSyCa3D-1AJLPxkr8QoGwUlE5q7y3G4d3ekk"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
//    [Parse setApplicationId:@"Ek7p6c9ec9QEjoqrIiR2rFpWjUai4BLOTgQRnt4s"
//                  clientKey:@"RlKnbRS6qyrtNML5ZVQETyOdbTWDHJxswLv6foal"];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    if ([FCurrentUser isFirstLaunch]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FirstLaunch" bundle:nil];
        FFirstLaunchViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FFirstLaunchViewController"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    }
    else if ([FCurrentUser isSessionValid] == NO){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FSignUpOneViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FSignUpOneViewController"];
        if ([FCurrentUser lastUserType] == EmailUser) {
            [rootViewController setViewType:SignInView];
        }
        else{
            [rootViewController setViewType:FacebookView];
        }
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    }

    if (self.internetReachability.currentReachabilityStatus == NotReachable) {
        [[FAlertView sharedHUD] showHUDOnView:self.window.rootViewController.view withText:@"No internet" wait:0];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if ([FCurrentUser isFirstLaunch] == NO && [FCurrentUser isSessionValid] == YES && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
            GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods objectAtIndex:0];
            GMSPlace* place = likelihood.place;
            if (place != nil) {
                NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:place];
                [FCurrentUser  updateUserlocation:obj];
            }
        }];
    }
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Inform the device that we no longer require access the device orientation.
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Inform the device that we want to use the device orientation again.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Let the device power down the accelerometer if not used elsewhere while backgrounded.
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

@end
