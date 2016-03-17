//
//  FPageTWOViewController.h
//  Foodu
//
//  Created by Abbin on 16/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFirstLaunchViewController.h"
@class FFirstLaunchViewController;

@interface FPageTWOViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong) FFirstLaunchViewController *delegateObj;

@end
