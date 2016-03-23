//
//  FPageTHREEViewController.h
//  Foodu
//
//  Created by Abbin on 17/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLocationPickerViewController.h"

@class FPageTHREEViewController;
@import GoogleMaps;
@protocol THREEDelegate <NSObject>

-(void)THREEClickedNext:(FPageTHREEViewController*)viewController withLocation:(NSMutableDictionary*)location;

@end

@interface FPageTHREEViewController : UIViewController<FLocationPickerDelegate>

@property (strong, nonatomic) id <THREEDelegate> delegate;

@end
