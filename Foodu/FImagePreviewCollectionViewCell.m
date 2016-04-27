//
//  FImagePreviewCollectionViewCell.m
//  Foodu
//
//  Created by Abbin on 06/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FImagePreviewCollectionViewCell.h"

@implementation FImagePreviewCollectionViewCell

- (void)awakeFromNib {

}

- (void)drawRect:(CGRect)rect{
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height/64;
    self.imageView.layer.masksToBounds = YES;
    self.closeButton.layer.cornerRadius = self.closeButton.frame.size.height/2;
    self.closeButton.layer.masksToBounds = YES;
}

@end
