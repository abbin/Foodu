//
//  FUser.m
//  Foodu
//
//  Created by Abbin Varghese on 09/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FUser.h"
#import "FDKeychain.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

NSString *const firstLaunchKey = @"firstLaunchKey";

NSString *const keyChainEmailKey = @"comPaadamFooduUserEmail";
NSString *const keyChainPasswordKey = @"comPaadamFooduUserEmail";
NSString *const keyChainUserIdKey = @"comPaadamFooduUserId";
NSString *const keyChainServiceKey = @"comPaadamFooduService";

@implementation FUser

+(BOOL)isFirstLaunch{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:firstLaunchKey]) {
        return NO;
    }
    else{
        return YES;
    }
}

+(BOOL)isSessionValid{
    NSError *keyChainError = nil;
    NSString *userId = [FDKeychain itemForKey:keyChainUserIdKey forService:keyChainServiceKey error:&keyChainError];
    if (userId.length>0) {
        return YES;
    }
    else{
        return NO;
    }
}

+(void)didFinishFirstLaunch{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstLaunchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)logOutCurrentUser:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure{
    if (failure == nil) {
        failure = ^(NSString *error){};
    }
    if (success == nil) {
        success = ^(BOOL success){};
    }
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error == nil) {
            success(YES);
        }
        else{
            failure(error.description);
        }
    }];
}

+(void)logInUserWithEmail:(NSString*)email password:(NSString*)password success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure{
    [PFUser logInWithUsernameInBackground:email password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            success(YES);
                                        } else {
                                            failure(error.description);
                                        }
                                    }];
    
}

+(void)connectWithFacebookFromViewController:(UIViewController*)viewController success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure{
    //    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"public_profile"];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login
     logInWithReadPermissions: permissionsArray
     fromViewController:viewController
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"%@",[FBSDKProfile currentProfile].name);
             ;
         }
     }];
}

+(void)signUpUserWithName:(NSString*)name email:(NSString*)email password:(NSString*)password success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure{

    if (failure == nil) {
        failure = ^(NSString *error){};
    }
    if (success == nil) {
        success = ^(BOOL success){};
    }
    
    PFUser *user = [PFUser user];
    user.password = password;
    user.email = email;
    user.username = email;
//    user[@"name"] = name;
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
    
    user[@"country"] = country;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            NSError *keyChainError = nil;
            [FDKeychain saveItem:email forKey:keyChainEmailKey forService:keyChainServiceKey error:&keyChainError];
            [FDKeychain saveItem:password forKey:keyChainPasswordKey forService:keyChainServiceKey error:&keyChainError];
            [FDKeychain saveItem:user.objectId forKey:keyChainUserIdKey forService:keyChainServiceKey error:&keyChainError];
            success(succeeded);
        }
        else
        {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            failure(errorString);
        }
    }];
}


@end
