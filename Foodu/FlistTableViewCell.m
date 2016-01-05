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
    self.itemImageView.layer.cornerRadius = 5;
    self.itemImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
