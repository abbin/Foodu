//
//  FUserDefaults.m
//  Foodu
//
//  Created by Abbin Varghese on 09/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FUserDefaults.h"

NSString *const firstLaunchKey = @"firstLaunchKey";

@implementation FUserDefaults

+(BOOL)isFirstLaunch{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:firstLaunchKey]) {
        return NO;
    }
    else{
        return YES;
    }
}

+(void)didFinishFirstLaunch{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstLaunchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)signUpUserWithName:(NSString*)name email:(NSString*)email password:(NSString*)password success:(void (^)(KiiUser *user))success failure:(void (^)(NSString *error))failure{
    
    if (failure == nil) {
        failure = ^(NSString *error){};
    }
    if (success == nil) {
        success = ^(KiiUser *user){};
    }
    
    KiiUser *user = [KiiUser userWithEmailAddress:email andPassword:password];
    
    user.displayName = name;
    [user performRegistrationWithBlock:^(KiiUser *user, NSError *error) {
        if (error != nil) {
            failure(error.description);
        }
        else{
            success(user);
        }
    }];
}

@end
