//
//  FEffectsAddCollectionViewCell.h
//  Foodu
//
//  Created by Abbin on 25/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FEffectsAddCollectionViewCell;
@protocol FEffectsAddCollectionViewCellDelegate <NSObject>

-(void)FEffectsAddCollectionViewCellWantsToAddNewPhoto:(FEffectsAddCollectionViewCell*)viewcontroller;

@end

@interface FEffectsAddCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) id <FEffectsAddCollectionViewCellDelegate> delegate;
@end
