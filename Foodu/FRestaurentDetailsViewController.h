//
//  FRestaurentDetailsViewController.h
//  Foodu
//
//  Created by Abbin Varghese on 19/05/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRestaurantPickerViewController.h"
#import "FLocationPickerViewController.h"

@interface FRestaurentDetailsViewController : UIViewController<UITextFieldDelegate,FRestaurantPickerDelegate,FLocationPickerDelegate>

@property (strong, nonatomic) FItem *item;

@end
