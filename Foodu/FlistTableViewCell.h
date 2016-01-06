//
//  FlistTableViewCell.h
//  Foodu
//
//  Created by Abbin on 04/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import "TPFloatRatingView.h"

@interface FlistTableViewCell : PFTableViewCell<TPFloatRatingViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet PFImageView *itemImageView;
@property (weak, nonatomic) IBOutlet TPFloatRatingView *ratingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemImageViewWidth;

@end
