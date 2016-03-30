//
//  FCurrentUser.h
//  Foodu
//
//  Created by Abbin Varghese on 28/02/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, UserType) {
    FaceBookUser = 243123,
    EmailUser = 413242
};

@interface FCurrentUser : NSObject<CLLocationManagerDelegate>

+(BOOL)isFirstLaunch;

+(void)didFinishFirstLaunch;

+(BOOL)isSessionValid;

+(NSString*)name;

+(NSString*)email;

+(NSString*)userID;

+(NSString*)facebookID;

+(NSMutableDictionary*)userlocation;

+(UserType)userType;

+(PFFile*)profilePicture;

+(UserType)lastUserType;

+(NSString*)lastEmail;

/////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark WEBHOOKS

+(void)signUpUserWithName:(NSString*)name
                    email:(NSString*)email
                 password:(NSString*)password
              andLocation:(NSMutableDictionary*)location
                  success:(void (^)(BOOL success))success
                  failure:(void (^)(NSString *error))failure;

+(void)logOutCurrentUser:(void (^)(BOOL success, UserType userType))success
                 failure:(void (^)(NSString *error))failure;

+(void)logInUserWithEmail:(NSString*)email
                 password:(NSString*)password
                  success:(void (^)(BOOL success))success
                  failure:(void (^)(NSString *error))failure;

+(void)connectWithFacebookFromViewController:(UIViewController*)viewController
                                withLocation:(NSMutableDictionary*)location
                                     success:(void (^)(BOOL success))success
                                     failure:(void (^)(NSString *error))failure;

/////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark SETTER METHODS

+(void)supdateProfilePicture:(UIImage*)image
                     success:(void (^)(BOOL success))success
                     failure:(void (^)(NSString *error))failure;

+(void)updateName:(NSString*)name;

+(void)updateEmail:(NSString*)email;

+(void)updateUserlocation:(NSMutableDictionary*)location;

+(void)updateUserType:(UserType)userType;

+(void)setlastEmail:(NSString*)email;

+(void)setlastUserType:(UserType)userType;

/////////////////////////////////////////////////////////////////////////////////////////////

@end
