//
//  FItemDetailsViewController.m
//  Foodu
//
//  Created by Abbin on 27/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FItemDetailsViewController.h"
#import "FImagePreviewCollectionViewCell.h"

@interface FItemDetailsViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *imagePreviewCollection;
@property (strong, nonatomic) NSMutableArray *cellSizeArray;
@end

@implementation FItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellSizeArray = [NSMutableArray new];
    for (UIImage *image in self.selectedImage) {
        [self.cellSizeArray addObject:[NSValue valueWithCGSize:CGSizeMake(image.size.width*self.imagePreviewCollection.frame.size.height/image.size.height, self.imagePreviewCollection.frame.size.height)]];
    }
    [self.imagePreviewCollection registerNib:[UINib nibWithNibName:@"FImagePreviewCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FImagePreviewCollectionViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (IBAction)dismissButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectedImage.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        FImagePreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FImagePreviewCollectionViewCell" forIndexPath:indexPath];
        UIImage *imge = [self.selectedImage objectAtIndex:indexPath.row];
        cell.imageView.image = imge;
        return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [[self.cellSizeArray objectAtIndex:indexPath.row] CGSizeValue];
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

@end
