//
//  FImagePreviewViewController.h
//  Foodu
//
//  Created by Abbin on 06/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEffectCollectionViewCell.h"
#import "FEffectsAddCollectionViewCell.h"

@interface FImagePreviewViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,FEffectCollectionViewCellDelegate,FEffectsAddCollectionViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *imageArray;
@end
