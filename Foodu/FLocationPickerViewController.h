//
//  FLocationPickerViewController.h
//  Foodu
//
//  Created by Abbin on 18/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface FLocationPickerViewController : UIViewController<UISearchBarDelegate,GMSAutocompleteFetcherDelegate,UITableViewDataSource,UITableViewDelegate>

@end
