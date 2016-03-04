//
//  FAlertView.h
//  Foodu
//
//  Created by Abbin on 04/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAlertView : UIVisualEffectView

-(instancetype)initWithView:(UIView*)view;

-(void)showHUDWithText:(NSString*)text wait:(NSInteger)time;
-(void)hideHUDWithText:(NSString*)text wait:(NSInteger)time;

@property(nonatomic,strong) UILabel *titleLabel;

@end
