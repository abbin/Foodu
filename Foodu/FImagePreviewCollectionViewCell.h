//
//  FImagePreviewCollectionViewCell.h
//  Foodu
//
//  Created by Abbin on 06/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FImagePreviewCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end
