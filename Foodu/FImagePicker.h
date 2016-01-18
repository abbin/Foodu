//
//  FImagePicker.h
//  Foodu
//
//  Created by Abbin on 18/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FImagePicker : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

-(void)showInView:(UIView*)view;

@end
