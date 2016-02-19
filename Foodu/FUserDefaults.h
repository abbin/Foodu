//
//  FUserDefaults.h
//  Foodu
//
//  Created by Abbin Varghese on 09/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FUserDefaults : NSUserDefaults

FOUNDATION_EXPORT NSString *const firstLaunchKey;

+(BOOL)isFirstLaunch;

+(void)didFinishFirstLaunch;

+(void)signUpUserWithName:(NSString*)name email:(NSString*)email password:(NSString*)password success:(void (^)(KiiUser *user))success failure:(void (^)(NSString *error))failure;

@end
