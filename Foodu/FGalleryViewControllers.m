//
//  FGalleryViewControllers.m
//  Foodu
//
//  Created by Abbin on 05/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FGalleryViewControllers.h"
#import "NSIndexSet+Convenience.h"
#import "UICollectionView+Convenience.h"
#import "AAPLGridViewCell2.h"
#import "FImagePreviewViewController.h"

@interface FGalleryViewControllers ()

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSArray *sectionFetchResults;
@property (nonatomic, strong) NSMutableArray *selectedindexs;
@property (nonatomic, strong) NSMutableArray *selectedPHAsset;
@property (nonatomic, strong) NSMutableArray *selectedImage;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property CGRect previousPreheatRect;

@end

@implementation FGalleryViewControllers

static NSString * const reuseIdentifier = @"Cell";
CGSize AssetGridThumbnailSize;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedindexs = [[NSMutableArray alloc]init];
    self.selectedPHAsset = [[NSMutableArray alloc]init];
    self.selectedImage = [[NSMutableArray alloc]init];
    
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"AAPLGridViewCell2" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    self.sectionFetchResults = @[allPhotos];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        self.assetsFetchResults = [self.sectionFetchResults objectAtIndex:0];
        [self initSelectedIndexArrayWithCount:self.assetsFetchResults.count];
        self.imageManager = [[PHCachingImageManager alloc] init];
        [self resetCachedAssets];
        [self.photoCollectionView reloadData];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Begin caching assets in and around collection view's visible rect.
    [self updateCachedAssets];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (IBAction)dismissButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)doneClicked:(UIButton *)sender {
    for (PHAsset *asset in self.selectedPHAsset) {
        [self.imageManager requestImageDataForAsset:asset
                                            options:nil
                                      resultHandler:^(NSData * _Nullable imageData,
                                                      NSString * _Nullable dataUTI,
                                                      UIImageOrientation orientation,
                                                      NSDictionary * _Nullable info) {
                                          
                                          UIImage *image = [UIImage imageWithData:imageData];
                                          
                                          [self.selectedImage addObject:[self imageByCroppingImage:image toSize:image.size]];
                                          
                                          if (self.selectedImage.count == self.selectedPHAsset.count) {
                                              FImagePreviewViewController *controller = [[FImagePreviewViewController alloc]initWithNibName:@"FImagePreviewViewController" bundle:[NSBundle mainBundle]];
                                              controller.imageArray = self.selectedImage;
                                              [self.navigationController pushViewController:controller animated:YES];
                                          }
        }];
    }
}

- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:image.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return cropped;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.photoCollectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AAPLGridViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    
    cell.representedAssetIdentifier = asset.localIdentifier;
    
    if ([[self.selectedindexs objectAtIndex:indexPath.row]boolValue]) {
        [cell selectCellWithAnimation:NO];
    }
    else{
        [cell deSelectCellWithAnimation:NO];
    }
    
    // Add a badge to the cell if the PHAsset represents a Live Photo.
    if (asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
        // Add Badge Image to the cell to denote that the asset is a Live Photo.
        UIImage *badge = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
        cell.livePhotoBadgeImage = badge;
    }
    
    // Request an image for the asset from the PHCachingImageManager.
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  // Set the cell's thumbnail image if it's still showing the same asset.
                                  if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                      cell.thumbnailImage = result;
                                  }
                              }];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/3-2, [UIScreen mainScreen].bounds.size.width/3-2);
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AAPLGridViewCell2 *cell = (AAPLGridViewCell2*)[self.photoCollectionView cellForItemAtIndexPath:indexPath];
    if ([[self.selectedindexs objectAtIndex:indexPath.row] boolValue]) {
        [cell deSelectCellWithAnimation:YES];
        [self.selectedindexs replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
        [self.selectedPHAsset removeObject:[self.assetsFetchResults objectAtIndex:indexPath.row]];
    }
    else{
        if (self.selectedPHAsset.count>=3) {
            [cell shakeCell];
        }
        else{
            [self.selectedindexs replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
            [cell selectCellWithAnimation:YES];
            [self.selectedPHAsset addObject:[self.assetsFetchResults objectAtIndex:indexPath.row]];
        }
    }

}

-(void)initSelectedIndexArrayWithCount:(NSInteger)count{
    if (self.selectedindexs == nil) {
        self.selectedindexs = [[NSMutableArray alloc]init];
    }
    for (int i = 0; i<count; i++) {
        [self.selectedindexs addObject:[NSNumber numberWithBool:NO]];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    [self updateCachedAssets];
}

#pragma mark - Asset Caching

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.photoCollectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.photoCollectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.photoCollectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.photoCollectionView aapl_indexPathsForElementsInRect:addedRect];
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

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    
    return assets;
}


- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Loop through the section fetch results, replacing any fetch results that have been updated.
        NSMutableArray *updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
        __block BOOL reloadRequired = NO;
        
        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            
            if (changeDetails != nil) {
                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
            }
        }];
        
        if (reloadRequired) {
            self.sectionFetchResults = updatedSectionFetchResults;
            self.assetsFetchResults = [self.sectionFetchResults objectAtIndex:0];
            [self initSelectedIndexArrayWithCount:self.assetsFetchResults.count];
            self.imageManager = [[PHCachingImageManager alloc] init];
            [self resetCachedAssets];
            [self.photoCollectionView reloadData];
        }
        
    });
}

@end
