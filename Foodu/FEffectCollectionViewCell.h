//
//  FEffectCollectionViewCell.h
//  Foodu
//
//  Created by Abbin on 06/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FEffectCollectionViewCell;
@protocol FEffectCollectionViewCellDelegate <NSObject>

-(void)FEffectCollectionViewCell:(FEffectCollectionViewCell*)viewController didRemoveImageAtIndex:(NSIndexPath*)indexPath;

@end

@interface FEffectCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) id <FEffectCollectionViewCellDelegate> delegate;

-(void)pressCell;

@end
