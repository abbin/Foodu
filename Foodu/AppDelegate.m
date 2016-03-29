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
    
//    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
//        
//        configuration.applicationId = @"Ph3YlcRPtxvK4Y8yDAARLosc5lvu4ErH8XZm6aX7";
//        
//        configuration.clientKey = @"ccUN1ZcZrfcxrLVLtLqseB62htLPxxkAvr5DovNa";
//        
//        configuration.server = @"https://foodu.herokuapp.com/parse";
//        
//    }]];
    
    [Fabric with:@[[Crashlytics class]]];
    
    [FBSDKLoginButton class];
    [GMSServices provideAPIKey:@"AIzaSyBGtfOYOaK00zKdgHO0lDsvCsj0HCkD3u4"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    [Parse setApplicationId:@"Ek7p6c9ec9QEjoqrIiR2rFpWjUai4BLOTgQRnt4s"
                  clientKey:@"RlKnbRS6qyrtNML5ZVQETyOdbTWDHJxswLv6foal"];
    
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
        [rootViewController setViewType:FacebookView];
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if ([FCurrentUser isFirstLaunch] == NO && [FCurrentUser isSessionValid] == YES && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
            GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods objectAtIndex:0];
            GMSPlace* place = likelihood.place;
            NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:place];
            [[FCurrentUser sharedUser] updateUserlocation:obj];
        }];
    }
    
    [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
