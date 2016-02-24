//
//  FUser.h
//  Foodu
//
//  Created by Abbin Varghese on 09/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <Parse/Parse.h>

@interface FUser : PFUser

FOUNDATION_EXPORT NSString *const firstLaunchKey;

+(BOOL)isFirstLaunch;

+(void)didFinishFirstLaunch;

+(void)signUpUserWithName:(NSString*)name email:(NSString*)email password:(NSString*)password success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure;

+(void)logOutCurrentUser:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure;

+(void)logInUserWithEmail:(NSString*)email password:(NSString*)password success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure;

+(void)connectWithFacebook:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure;

@end
