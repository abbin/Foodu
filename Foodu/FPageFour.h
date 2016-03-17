//
//  FPageFour.h
//  Foodu
//
//  Created by Abbin on 16/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FPageFour;

@protocol TWODelegate <NSObject>

-(void)TWOClickedNext:(FPageFour*)viewController;

@end

@interface FPageFour : UIViewController

@property(nonatomic,strong) id <TWODelegate>delegate;

@end
