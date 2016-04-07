//
//  FImagePreviewViewController.m
//  Foodu
//
//  Created by Abbin on 06/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FImagePreviewViewController.h"
#import "FImagePreviewCollectionViewCell.h"
#import "FEffectCollectionViewCell.h"
@import GPUImage;

@interface FImagePreviewViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *effectsCollectionView;

@property (strong, nonatomic) NSMutableArray *filterArray;

@end

@implementation FImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filterArray = [[NSMutableArray alloc]init];
    
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"FImagePreviewCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FImagePreviewCollectionViewCell"];
        [self.effectsCollectionView registerNib:[UINib nibWithNibName:@"FEffectCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FEffectCollectionViewCell"];
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
    for (int i = 0; i <= 10; i++) {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize cellSize = ((UICollectionViewFlowLayout *)self.photoCollectionView.collectionViewLayout).itemSize;
        CGSize AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
        [self.filterArray addObject:[self imageWithImage:[self.imageArray objectAtIndex:0] scaledToSize:AssetGridThumbnailSize]];
    }
    
    for (int i = 0; i<self.filterArray.count; i++) {
        [self.filterArray replaceObjectAtIndex:i withObject:[self filteredImageForIndex:i withOriginal:[self.filterArray objectAtIndex:i]]];
    }
    
    [self.effectsCollectionView reloadData];
}

-(UIImage*)filteredImageForIndex:(NSInteger)index withOriginal:(UIImage*)image{
    switch (index) {
        case 0:{
            GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            
            GPUImagePicture *lookupImageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"cloudy07.jpg"]];
            
            GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init]; 
            [stillImageSource addTarget:lookupFilter];
            [lookupImageSource addTarget:lookupFilter];
            
            [lookupFilter useNextFrameForImageCapture];
            [stillImageSource processImage];
            [lookupImageSource processImage];
            
            UIImage *filteredimage = [lookupFilter imageFromCurrentFramebuffer];
            
            return filteredimage;
        }
            break;
            
        default:
            return image;
            break;
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 0) {
        return self.imageArray.count;
    }
    else{
        return self.filterArray.count;
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
        FEffectCollectionViewCell * effCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FEffectCollectionViewCell" forIndexPath:indexPath];
        effCell.imageView.image = [self.filterArray objectAtIndex:indexPath.row];
        return effCell;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 0) {
        return self.photoCollectionView.frame.size;
    }
    else{
        return CGSizeMake(self.effectsCollectionView.frame.size.height, self.effectsCollectionView.frame.size.height);
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


@end
