//
//  FEmailSignUpEMAILViewController.h
//  Foodu
//
//  Created by Abbin on 22/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FEmailSignUpEMAILViewController;
@protocol SignUpEMAILDelegate <NSObject>

-(void)SignUpEMAILClickedBack:(FEmailSignUpEMAILViewController*)controller withLocation:(NSMutableDictionary*)location andName:(NSString*)name;
-(void)SignUpEMAILClickedNext:(FEmailSignUpEMAILViewController*)controller withLocation:(NSMutableDictionary*)location name:(NSString*)name andEmail:(NSString*)email;

@end

@interface FEmailSignUpEMAILViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *location;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;

@property (strong, nonatomic) id <SignUpEMAILDelegate>delegate;
@end
