//
//  FRestaurantPickerViewController.h
//  Foodu
//
//  Created by Abbin Varghese on 19/05/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRestaurantPickerViewController;

@protocol FRestaurantPickerDelegate <NSObject>

-(void)restaurantPicker:(FRestaurantPickerViewController*)picker didFinishPickingrestaurant:(id)restaurant;

@end

@interface FRestaurantPickerViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) id <FRestaurantPickerDelegate> delegate;

@end
