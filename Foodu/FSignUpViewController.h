//
//  FSignUpViewController.h
//  Foodu
//
//  Created by Abbin Varghese on 09/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FSignType) {
    FSignUpView,
    FSignInView
};

@interface FSignUpViewController : UIViewController<UITextFieldDelegate>

@property(assign, nonatomic) FSignType FSignType;


@end
