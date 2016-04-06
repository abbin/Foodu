//
//  FCurrentUser.m
//  Foodu
//
//  Created by Abbin Varghese on 28/02/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FCurrentUser.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

NSString *const firstLaunchKey = @"firstLaunchKey";
NSString *const firstCameraLaunchKey = @"firstCameraLaunchKey";
NSString *const userFacebookDefaultPassword = @"comPaadamFooduFacebookPassword";
NSString *const lastEmailKey = @"lastEmailKey";
NSString *const lastUserTypeKey = @"lastUserTypeKey";

@implementation FCurrentUser

+(NSString*)name{
    return [[PFUser currentUser]valueForKey:@"name"];
}

+(NSString*)email{
    return [PFUser currentUser].email;
}

+(NSMutableDictionary*)userlocation{
    return [[PFUser currentUser]valueForKey:@"userlocation"];
}

+(UserType)userType{
    return [[[PFUser currentUser]objectForKey:@"userType"] integerValue];
}

+(NSString*)facebookID{
    return [[PFUser currentUser]objectForKey:@"facebookId"];
}

+(PFFile*)profilePicture{
    return [[PFUser currentUser]valueForKey:@"profilePicture"];
}

+(NSString*)userID{
    return [PFUser currentUser].objectId;
}

+(NSString *)lastEmail{
    return [[NSUserDefaults standardUserDefaults] stringForKey:lastEmailKey];
}

+(UserType)lastUserType{
    return [[NSUserDefaults standardUserDefaults] integerForKey:lastUserTypeKey];
}

+(void)updateName:(NSString*)name{
    [PFUser currentUser][@"name"] = name;
    [[PFUser currentUser] saveEventually];
}

+(void)updateEmail:(NSString*)email{
    [PFUser currentUser].email = email;
    [[PFUser currentUser] saveEventually];
}

+(void)updateUserlocation:(NSMutableDictionary*)location{
    [PFUser currentUser][@"userlocation"] = location;
    [[PFUser currentUser] saveEventually];
}

+(void)updateUserType:(UserType)userType{
    [PFUser currentUser][@"userType"] = @(userType);
    [[PFUser currentUser] saveEventually];
}

+(void)setlastEmail:(NSString *)email{
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:lastEmailKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setlastUserType:(UserType)userType{
    [[NSUserDefaults standardUserDefaults] setInteger:userType forKey:lastUserTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)supdateProfilePicture:(UIImage*)image success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure{
    if (failure == nil) {
        failure = ^(NSString *error){};
    }
    if (success == nil) {
        success = ^(BOOL success){};
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    [PFUser currentUser][@"profilePicture"] = imageFile;
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            failure([error userInfo][@"error"]);
        }
        else{
            success(YES);
        }
    }];
}

+(BOOL)isFirstCameraLaunch{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:firstCameraLaunchKey]) {
        return NO;
    }
    else{
        return YES;
    }
}

+(void)didFinishFirstCameraLaunch{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstCameraLaunchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

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

+(BOOL)isSessionValid{
    if ([PFUser currentUser]){
        return YES;
    }
    else{
        return NO;
    }
}

+(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSDictionary* userInfo = @{@"CLAuthorizationStatus": @(status)};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"locationManagerdidChangeAuthorizationStatus" object:self userInfo:userInfo];
}

+(void)signUpUserWithName:(NSString*)name email:(NSString*)email password:(NSString*)password andLocation:(NSMutableDictionary*)location success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure{
    
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
    user[@"name"] = name;
    user[@"userType"] = @(EmailUser);
    user[@"userlocation"] = location;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            if ([FCurrentUser isFirstLaunch]) {
                [FCurrentUser didFinishFirstLaunch];
            }
            [self setlastUserType:EmailUser];
            [self setlastEmail:user.email];
            [self logUser];
            success(succeeded);
        }
        else
        {
            NSString *errorString = [[error userInfo][@"error"] capitalizedString];   // Show the errorString somewhere and let the user try again.
            failure(errorString);
        }
    }];
}

+(void)logOutCurrentUser:(void (^)(BOOL success, UserType userType))success failure:(void (^)(NSString *error))failure{
    
    if (failure == nil) {
        failure = ^(NSString *error){};
    }
    if (success == nil) {
        success = ^(BOOL success, UserType userType){};
    }
    
    if ([FCurrentUser  userType] == FaceBookUser) {
        [PFUser logOutInBackground];
        [[FBSDKLoginManager new] logOut];
        success(YES,FaceBookUser);
    }
    else{
        [PFUser logOutInBackground];
        success(YES,EmailUser);
    }
}

+(void)logInUserWithEmail:(NSString*)email password:(NSString*)password success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure{
    [PFUser logInWithUsernameInBackground:email password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            if ([FCurrentUser isFirstLaunch]) {
                                                [FCurrentUser didFinishFirstLaunch];
                                            }
                                            [self setlastUserType:EmailUser];
                                            [self setlastEmail:user.email];
                                            [self logUser];
                                            success(YES);
                                        } else {
                                            if ([error code] == 101) {
                                                NSString *errorString = @"Incorrect email/password";
                                                failure(errorString);
                                            }
                                            else{
                                                NSString *errorString = [[error userInfo][@"error"] capitalizedString];
                                            
                                                failure(errorString);
                                            }
                                        }
                                    }];
    
}



+(void)connectWithFacebookFromViewController:(UIViewController*)viewController withLocation:(NSMutableDictionary*)location success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure{
    //    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"public_profile",@"email",@"user_friends"];
    
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[FBSDKLoginManager new] logOut];
    }
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login setLoginBehavior:FBSDKLoginBehaviorSystemAccount];
    
    [login
     logInWithReadPermissions: permissionsArray
     fromViewController:viewController
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             failure(@"Failed to Sign in to Facebook");
         } else if (result.isCancelled) {
             failure(@"Facebook Sign in was canceled");
         } else {
             if ([FBSDKAccessToken currentAccessToken]) {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,first_name,last_name,email,picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         if ([result objectForKey:@"email"]) {
                             
                             PFQuery *query = [PFUser query];
                             [query whereKey:@"email" equalTo:[result objectForKey:@"email"]]; // find all the women
                             [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                                 
                                 if (objects.count==0) {
                                     PFUser *user = [PFUser user];
                                     user.password = userFacebookDefaultPassword;
                                     user.email = [result objectForKey:@"email"];
                                     user.username = [result objectForKey:@"email"];
                                     user[@"name"] = [NSString stringWithFormat:@"%@ %@",[result objectForKey:@"first_name"],[result objectForKey:@"last_name"]];
                                     user[@"userType"] = [NSNumber numberWithInteger:FaceBookUser];
                                     user[@"userlocation"] = location;
                                     user[@"facebookId"] = [result objectForKey:@"id"];
                                     NSString *url = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                                     PFFile *image;
                                     if (url.length>0) {
                                        image = [PFFile fileWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                                     }
                                     if (image) {
                                         user[@"profilePicture"] = image;
                                     }
                                     [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {   // Hooray! Let them use the app now.
                                             if ([FCurrentUser isFirstLaunch]) {
                                                 [FCurrentUser didFinishFirstLaunch];
                                             }
                                             [self setlastUserType:FaceBookUser];
                                             [self setlastEmail:user.email];
                                             [self logUser];
                                             success(succeeded);
                                         }
                                         else
                                         {
                                            NSString *errorString = [[error userInfo][@"error"] capitalizedString];   // Show the errorString somewhere and let the user try again.
                                             failure(errorString);
                                         }
                                     }];
                                     
                                 }
                                 else{
                                     [PFUser logInWithUsernameInBackground:[result objectForKey:@"email"] password:userFacebookDefaultPassword
                                                                     block:^(PFUser *user, NSError *error) {
                                                                         if (user) {
                                                                             if ([FCurrentUser isFirstLaunch]) {
                                                                                 [FCurrentUser didFinishFirstLaunch];
                                                                             }
                                                                             [self setlastEmail:user.email];
                                                                             [self setlastUserType:FaceBookUser];
                                                                             [self logUser];
                                                                             success(YES);
                                                                         } else {
                                                                             NSString *errorString = [[error userInfo][@"error"] capitalizedString];
                                                                             failure(errorString);
                                                                         }
                                                                     }];
                                     
                                 }
                                 
                             }];
                         }
                         else{
                             failure(@"Couldn't register a new account. Fuud requires your email");
                         }
                     }
                 }];
             }
         }
     }];
}

+ (void)logUser {
    [CrashlyticsKit setUserIdentifier:[FCurrentUser userID]];
    [CrashlyticsKit setUserEmail:[FCurrentUser email]];
    [CrashlyticsKit setUserName:[FCurrentUser name]];
}


@end
