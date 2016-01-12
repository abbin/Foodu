//
//  FlistTableViewCell.m
//  Foodu
//
//  Created by Abbin on 04/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FlistTableViewCell.h"

@implementation FlistTableViewCell

- (void)awakeFromNib {
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.masksToBounds = YES;
    
//    self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.containerView.layer.borderWidth = 0.5f;
    
    if (IS_IPad) {
        self.itemImageViewWidth.constant = (16*[UIScreen mainScreen].bounds.size.height/4)/9;
    }
    else{
        self.itemImageViewWidth.constant = (4*[UIScreen mainScreen].bounds.size.height/4)/3;
    }
    self.ratingView.delegate = self;
    self.ratingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    self.ratingView.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
    self.ratingView.contentMode = UIViewContentModeScaleAspectFill;
    self.ratingView.maxRating = 5;
    self.ratingView.minRating = 1;
    self.ratingView.rating = 2.8;
    self.ratingView.editable = YES;
    self.ratingView.halfRatings = YES;
    self.ratingView.floatRatings = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
