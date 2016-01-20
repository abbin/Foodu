//
//  FImagePicker.m
//  Foodu
//
//  Created by Abbin on 18/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "UICollectionView+UICollectionView_Convenience.h"
#import "NSIndexSet+NSIndexSet_Convenience.h"
#import "FImagePicker.h"
#import "AppDelegate.h"
#include <Photos/Photos.h>
#import "FImagePickerCollectionViewCell.h"

@interface FImagePicker ()

@property (nonatomic, strong) UIView *innerView;
@property (nonatomic, strong) UIView *supView;
@property (nonatomic, strong) UICollectionView *pickerCollectionView;

@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHCachingImageManager *imageManager;

@property CGRect previousPreheatRect;

@end

@implementation FImagePicker

static CGSize AssetGridThumbnailSize;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.innerView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2)];
        self.innerView.backgroundColor = [UIColor whiteColor];
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        self.pickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, self.innerView.frame.size.width, self.innerView.frame.size.height-50) collectionViewLayout:layout];
        [self.pickerCollectionView setDataSource:self];
        [self.pickerCollectionView setDelegate:self];
        [self.pickerCollectionView setBackgroundColor:[UIColor TableBackground]];
        [self.innerView addSubview:self.pickerCollectionView];
        
        self.imageManager = [[PHCachingImageManager alloc] init];
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
            [self resetCachedAssets];
        }
        
        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
        
        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize cellSize = ((UICollectionViewFlowLayout *)layout).itemSize;
        AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
        [self.pickerCollectionView reloadData];
        
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        
        
        [self.pickerCollectionView registerNib:[UINib nibWithNibName:@"FImagePickerCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FImagePickerCollectionViewCell"];
    }
    return self;
}

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

-(void)showInView:(UIView*)view{
    [self addSubview:self.innerView];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] addSubview:self];
    self.supView = view;
    [self updateCachedAssets];
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.supView setTransform:CGAffineTransformMakeScale(0.95, 0.95)];
        self.innerView.layer.position = CGPointMake(self.innerView.layer.position.x, self.innerView.layer.position.y - self.innerView.frame.size.height);
        self.supView.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.supView setTransform:CGAffineTransformMakeScale(1, 1)];
        self.innerView.layer.position = CGPointMake(self.innerView.layer.position.x, self.innerView.layer.position.y + self.innerView.frame.size.height);
        self.supView.alpha = 1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsFetchResults.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FImagePickerCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"FImagePickerCollectionViewCell" forIndexPath:indexPath];
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  
                                  cell.cellImageVIew.image = result;
                                  
                              }];

    return cell;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view == self) { // accept only touchs on superview, not accept touchs on subviews
        return YES;
    }
    
    return NO;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/4-2, [UIScreen mainScreen].bounds.size.width/4-2);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (void)updateCachedAssets {
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.pickerCollectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.pickerCollectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.pickerCollectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.pickerCollectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    [self updateCachedAssets];
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    
    return assets;
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}


@end
