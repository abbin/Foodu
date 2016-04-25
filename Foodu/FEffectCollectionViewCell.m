//
//  FEffectCollectionViewCell.m
//  Foodu
//
//  Created by Abbin on 06/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FEffectCollectionViewCell.h"

@implementation FEffectCollectionViewCell

- (void)drawRect:(CGRect)rect{
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height/64;
    self.imageView.layer.masksToBounds = YES;
    self.closeButton.layer.cornerRadius = self.closeButton.frame.size.height/2;
    self.closeButton.layer.masksToBounds = YES;
    [self layoutIfNeeded];
}

-(void)pressCell{
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }];
}
- (IBAction)closeButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(FEffectCollectionViewCell:didRemoveImageAtIndex:)]) {
        [self.delegate FEffectCollectionViewCell:self didRemoveImageAtIndex:self.indexPath];
    }
}

@end
