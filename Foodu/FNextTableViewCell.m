//
//  FNextTableViewCell.m
//  Foodu
//
//  Created by Abbin on 06/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FNextTableViewCell.h"

@implementation FNextTableViewCell

- (void)awakeFromNib {
    self.nextLabel.layer.cornerRadius = 5;
    self.nextLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
