//
//  FItemDetailsViewController.h
//  Foodu
//
//  Created by Abbin on 27/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FItemPickerViewController.h"

@interface FItemDetailsViewController : UIViewController<UITextFieldDelegate,FItemPickerDelegate>

@property (nonatomic, strong) NSMutableArray *selectedImage;

@end
