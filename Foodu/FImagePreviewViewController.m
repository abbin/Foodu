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

@interface FImagePreviewViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *effectsCollectionView;

@end

@implementation FImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 1) {
        
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
        effCell.imageView.image = [self.imageArray objectAtIndex:indexPath.row];
        return effCell;
    }
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


@end
