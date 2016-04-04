//
//  AAPLGridViewCell2.m
//  Foodu
//
//  Created by Abbin Varghese on 03/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "AAPLGridViewCell2.h"

@interface AAPLGridViewCell2 ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *livePhotoBadgeImageView;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIView *galleryIcon;

@end

@implementation AAPLGridViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.livePhotoBadgeImageView.image = nil;
    
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

- (void)setLivePhotoBadgeImage:(UIImage *)livePhotoBadgeImage {
    _livePhotoBadgeImage = livePhotoBadgeImage;
    self.livePhotoBadgeImageView.image = livePhotoBadgeImage;
}

-(void)deSelectCellWithAnimation:(BOOL)animation{
    double time;
    if (animation) {
        time = 0.3;
    }else{
        time = 0.0;
    }
    
    [UIView animateWithDuration:time delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.blurView.alpha = 0;
        self.galleryIcon.alpha = 0;
        self.imageViewWidth.constant = 0;
        [self.blurView layoutIfNeeded];
        [self.imageView setTransform:CGAffineTransformMakeScale(1, 1)];
        [self.blurView setTransform:CGAffineTransformMakeScale(1, 1)];
    } completion:^(BOOL finished) {
        self.cellSelected = NO;
    }];

}

-(void)selectCellWithAnimation:(BOOL)animation forGallery:(BOOL)gallery{
    
    double time;
    if (animation) {
        time = 0.3;
    }else{
        time = 0.0;
    }
    
    if (gallery) {
        [UIView animateWithDuration:time delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blurView.alpha = 0;
            self.imageViewWidth.constant = 0;
            self.galleryIcon.alpha = 1;
            [self.blurView layoutIfNeeded];
            [self.imageView setTransform:CGAffineTransformMakeScale(1, 1)];
            [self.blurView setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:^(BOOL finished) {
            self.cellSelected = NO;
        }];
    }
    else{
        [UIView animateWithDuration:time delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blurView.alpha = 1;
            self.galleryIcon.alpha = 0;
            self.imageViewWidth.constant = self.blurView.frame.size.width/5;
            [self.imageView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
            [self.blurView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
            self.iconImage.image = [UIImage imageNamed:@"check"];
            [self.blurView layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.cellSelected = YES;
        }];
    }
}


@end
