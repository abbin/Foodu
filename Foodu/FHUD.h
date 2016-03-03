//
//  FHUD.h
//  Foodu
//
//  Created by Abbin on 03/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FHUD : UIView

-(instancetype)initWithView:(UIView*)view;
-(void)showHUDWithText:(NSString*)text backgroundColour:(UIColor*)colour;
-(void)hideHUDWithText:(NSString*)text backgroundColour:(UIColor*)colour wait:(NSInteger)time;

@property(nonatomic,strong) UILabel *titleLabel;
@end
