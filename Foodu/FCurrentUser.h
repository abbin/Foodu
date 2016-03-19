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

@property(nonatomic,strong) FLocationObject *userlocation;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,assign) UserType userType;
@property(nonatomic,strong) PFFile *profilePicture;

+ (FCurrentUser*)sharedUser;

+(BOOL)isFirstLaunch;

+(void)didFinishFirstLaunch;

+(BOOL)isSessionValid;

+(void)signUpUserWithName:(NSString*)name email:(NSString*)email password:(NSString*)password success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure;

+(void)logOutCurrentUser:(void (^)(BOOL success, UserType userType))success failure:(void (^)(NSString *error))failure;

+(void)logInUserWithEmail:(NSString*)email password:(NSString*)password success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure;

+(void)connectWithFacebookFromViewController:(UIViewController*)viewController success:(void (^)(BOOL success))success failure:(void (^)(NSString *error))failure;

+(void)askForLocationPermision;

@end
