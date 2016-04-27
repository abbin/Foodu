//
//  FImagePreviewViewController.m
//  Foodu
//
//  Created by Abbin on 06/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FImagePreviewViewController.h"
#import "FImagePreviewCollectionViewCell.h"

@interface FImagePreviewViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *effectsCollectionView;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorX;

@end

@implementation FImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"FImagePreviewCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FImagePreviewCollectionViewCell"];
    [self.effectsCollectionView registerNib:[UINib nibWithNibName:@"FEffectCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FEffectCollectionViewCell"];
    [self.effectsCollectionView registerNib:[UINib nibWithNibName:@"FEffectsAddCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FEffectsAddCollectionViewCell"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.indicatorView.layer.cornerRadius = self.indicatorView.frame.size.height/2;
    self.indicatorView.layer.masksToBounds = YES;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 0) {
        return self.imageArray.count;
    }
    else{
        if (self.imageArray.count == 3) {
            return self.imageArray.count;
        }
        else{
            return self.imageArray.count+1;
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double offset = scrollView.contentOffset.x;
    self.indicatorX.constant = offset/3;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 1) {
        if (indexPath.row < self.imageArray.count ) {
            [self.photoCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 0) {
        FImagePreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FImagePreviewCollectionViewCell" forIndexPath:indexPath];
        UIImage *imge = [self.imageArray objectAtIndex:indexPath.row];
        cell.imageView.image = imge;
        return cell;
    }
    else{
        if (self.imageArray.count == 3) {
            FEffectCollectionViewCell * effCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FEffectCollectionViewCell" forIndexPath:indexPath];
            effCell.imageView.image = [self.imageArray objectAtIndex:indexPath.row];
            effCell.delegate = self;
            effCell.indexPath = indexPath;
            return effCell;
        }
        else{
            if (indexPath.row < self.imageArray.count) {
                FEffectCollectionViewCell * effCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FEffectCollectionViewCell" forIndexPath:indexPath];
                effCell.imageView.image = [self.imageArray objectAtIndex:indexPath.row];
                effCell.delegate = self;
                effCell.indexPath = indexPath;
                return effCell;
            }
            else{
                FEffectsAddCollectionViewCell * effCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FEffectsAddCollectionViewCell" forIndexPath:indexPath];
                effCell.delegate = self;
                return effCell;
            }
        }
    }
}

-(void)FEffectCollectionViewCell:(FEffectCollectionViewCell *)viewController didRemoveImageAtIndex:(NSIndexPath *)indexPath{
    
    if (self.imageArray.count == 1) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"popViewControllerAnimated"
         object:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.photoCollectionView performBatchUpdates:^{
            NSArray * array = [NSArray arrayWithObject:indexPath];
            [self.imageArray removeObjectAtIndex:indexPath.row];
            [self.photoCollectionView deleteItemsAtIndexPaths:array];
        } completion:^(BOOL finished) {
            
        }];
        
        [self.effectsCollectionView performBatchUpdates:^{
            [self.effectsCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:nil];
    }
    
}

-(void)FEffectsAddCollectionViewCellWantsToAddNewPhoto:(FEffectsAddCollectionViewCell *)viewcontroller{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 0) {
        return self.photoCollectionView.frame.size;
    }
    else{
        return CGSizeMake([UIScreen mainScreen].bounds.size.width/3, [UIScreen mainScreen].bounds.size.width/3);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (IBAction)dismissButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)checkButtonClicked:(UIButton *)sender {

}

- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


@end
