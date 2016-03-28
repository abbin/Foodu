//
//  FEmailSignUpPASSWORDViewController.h
//  Foodu
//
//  Created by Abbin on 28/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FEmailSignUpPASSWORDViewController;
@protocol SignUpPASSWORDDelegate <NSObject>

-(void)SignUpPASSWORDClickedBack:(FEmailSignUpPASSWORDViewController*)controller withLocation:(NSMutableDictionary*)location name:(NSString*)name email:(NSString*)email;

@end

@interface FEmailSignUpPASSWORDViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *location;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;

@property (strong, nonatomic) id <SignUpPASSWORDDelegate>delegate;

@end
