//
//  FEffectsAddCollectionViewCell.m
//  Foodu
//
//  Created by Abbin on 25/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FEffectsAddCollectionViewCell.h"

@implementation FEffectsAddCollectionViewCell


- (void)drawRect:(CGRect)rect{
    self.containerView.layer.cornerRadius = self.containerView.frame.size.height/64;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderWidth = 2;
    self.containerView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self layoutIfNeeded];
}
- (IBAction)addButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(FEffectsAddCollectionViewCellWantsToAddNewPhoto:)]) {
        [self.delegate FEffectsAddCollectionViewCellWantsToAddNewPhoto:self];
    }
}
@end
