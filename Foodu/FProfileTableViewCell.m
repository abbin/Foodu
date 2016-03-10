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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
    }];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
    }];
}

@end
