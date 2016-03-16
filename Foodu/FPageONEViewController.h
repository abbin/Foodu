//
//  FPageONEViewController.h
//  Foodu
//
//  Created by Abbin on 15/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FPageONEViewController;
@protocol ONEDelegate <NSObject>

-(void)ONEClickedNext:(FPageONEViewController*)viewController;

@end

@interface FPageONEViewController : UIViewController

@property(nonatomic,strong) id <ONEDelegate>delegate;

@end
