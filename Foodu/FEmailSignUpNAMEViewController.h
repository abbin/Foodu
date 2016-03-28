//
//  FEmailSignUpNAMEViewController.h
//  Foodu
//
//  Created by Abbin on 21/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FEmailSignUpNAMEViewController;
@protocol SignUpNAMEDelegate <NSObject>

-(void)SignUpNAMEClickedBack:(FEmailSignUpNAMEViewController*)controller;
-(void)SignUpNAMEClickedNext:(FEmailSignUpNAMEViewController*)controller withLocation:(NSMutableDictionary*)location andName:(NSString*)name;

@end

@interface FEmailSignUpNAMEViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSMutableDictionary *location;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) id <SignUpNAMEDelegate> delegate;

@end
