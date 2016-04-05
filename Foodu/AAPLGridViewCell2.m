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
@property (weak, nonatomic) IBOutlet UIView *badgeView;

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
        time = 0.2;
    }
    else{
        time = 0.0;
    }
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        self.badgeView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)selectCellWithAnimation:(BOOL)animation{
    
    double time;
    if (animation) {
        time = 0.2;
    }
    else{
        time = 0.0;
    }
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        self.badgeView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

}


@end
