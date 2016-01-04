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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.itemImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (self.itemImageView.image) {
            [self.loader stopAnimating];
        }
    }];
    // Configure the view for the selected state
}

@end
