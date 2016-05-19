//
//  FItemPickerViewController.h
//  Foodu
//
//  Created by Abbin Varghese on 19/05/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FItemPickerViewController;

@protocol FItemPickerDelegate <NSObject>

-(void)FItemPicker:(FItemPickerViewController*)picker didFinishPickingItem:(id)item;

@end

@interface FItemPickerViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) id <FItemPickerDelegate> delegate;

@end
