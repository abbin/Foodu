//
//  FSignUpOneViewController.h
//  Foodu
//
//  Created by Abbin Varghese on 19/02/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, viewType) {
    SignUpView,
    SignInView,
    FacebookView
};

typedef NS_ENUM(NSInteger, SignUpScreen) {
    SignUpOne,
    SignUpTwo,
    SignUpThree
};

@interface FSignUpOneViewController : UIViewController<UITextFieldDelegate>

@property(assign, nonatomic) viewType viewType;
@property(assign, nonatomic) SignUpScreen signUpScreen;
@end
