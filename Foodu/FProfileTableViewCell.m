//
//  FProfileTableViewCell.m
//  Foodu
//
//  Created by Abbin on 10/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FProfileTableViewCell.h"

@interface FProfileTableViewCell ()

@end

@implementation FProfileTableViewCell

- (void)awakeFromNib {
    self.sideImageView.layer.cornerRadius = self.sideImageView.frame.size.height/4;
    self.sideImageView.layer.masksToBounds = YES;
    
//    [self.sideImageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
//    [self.sideImageView.layer setBorderWidth: 1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end