//
//  FCurrentUser.h
//  Foodu
//
//  Created by Abbin Varghese on 28/02/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserType) {
    FaceBookUser,
    EmailUser
};

@interface FCurrentUser : NSObject

@property(nonatomic,strong) PFGeoPoint *userlocation;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,assign) UserType userType;

+ (FCurrentUser*)sharedUser;

+(BOOL)isFirstLaunch;

+(void)didFinishFirstLaunch;

+(BOOL)isSessionValid;

+(void)signUpUserWithName:(NSString*)name email:(NSString*)email password:(NSString*)password success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure;

+(void)logOutCurrentUser:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure;

+(void)logInUserWithEmail:(NSString*)email password:(NSString*)password success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure;

+(void)connectWithFacebookFromViewController:(UIViewController*)viewController success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure;

@end
