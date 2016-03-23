//
//  FPageFOURViewController.h
//  Foodu
//
//  Created by Abbin on 21/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FPageFOURViewController;
@protocol FOURDelegate <NSObject>

-(void)FPageFOURSwitchToEmailSignUp:(FPageFOURViewController*)controller withLocation:(NSMutableDictionary*)location;

@end

@interface FPageFOURViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *location;

@property (strong, nonatomic) id <FOURDelegate> delegate;

@end
