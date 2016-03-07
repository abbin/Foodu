//
//  FAlertView.h
//  Foodu
//
//  Created by Abbin on 04/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAlertView : UIView

-(void)showHUDOnView:(UIView*)view withText:(NSString*)text wait:(NSInteger)time;
-(void)hideHUDWithText:(NSString*)text wait:(NSInteger)time;
-(void)showActivityIndicatorOnView:(UIView*)view;
-(void)hideActivityIndicatorOnView;
+ (FAlertView*)sharedHUD;
@end
