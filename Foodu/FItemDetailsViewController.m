//
//  FItemDetailsViewController.m
//  Foodu
//
//  Created by Abbin on 27/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FItemDetailsViewController.h"
#import "FImagePreviewCollectionViewCell.h"
#import "FRestaurentDetailsViewController.h"

@interface FItemDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrain;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *imagePreviewCollection;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *cellSizeArray;
@property (strong, nonatomic) FItem *item;
@end

@implementation FItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.item = [FItem object];
    
    self.descriptionTextView.inputAccessoryView = self.toolBar;
    self.priceTextField.inputAccessoryView = self.toolBar;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(noticeShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(noticeHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    self.cellSizeArray = [NSMutableArray new];
    for (UIImage *image in self.selectedImage) {
        [self.cellSizeArray addObject:[NSValue valueWithCGSize:CGSizeMake(image.size.width*([UIScreen mainScreen].bounds.size.height/3.5)/image.size.height, ([UIScreen mainScreen].bounds.size.height/3.5))]];
    }
    [self.imagePreviewCollection registerNib:[UINib nibWithNibName:@"FImagePreviewCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FImagePreviewCollectionViewCell"];
    
    self.priceTextField.text = [self currencySymbol];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.descriptionTextView.layer.cornerRadius = 5;
    self.descriptionTextView.layer.masksToBounds = YES;
    self.descriptionTextView.layer.borderWidth = 0.5f;
    self.descriptionTextView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1] CGColor];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (IBAction)dismissButtonClicked:(UIButton *)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes, I'm sure" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [controller addAction:yes];
    [controller addAction:cancel];
    [self presentViewController:controller animated:YES completion:nil];
    
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)noticeHideKeyboard:(NSNotification *)notification {
    self.topConstrain.constant = 0;
    NSDictionary *info  = notification.userInfo;
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)noticeShowKeyboard:(NSNotification *)notification {
    
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    self.topConstrain.constant = -keyboardFrame.size.height;
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (IBAction)textFieldDidChangeEditing:(UITextField *)sender {
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 0 && range.length == 1) {
        return NO;
    }
    else{
        return YES;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        FItemPickerViewController *picker = [[FItemPickerViewController alloc]initWithNibName:@"FItemPickerViewController" bundle:[NSBundle mainBundle]];
        picker.delegate = self;
        picker.providesPresentationContextTransitionStyle = YES;
        picker.definesPresentationContext = YES;
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:picker animated:YES completion:nil];
        return NO;
    }
    else{
        return YES;
    }
}

-(NSString*)currencySymbol{
    return [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
}

- (IBAction)doneClicked:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
}

-(void)FItemPicker:(FItemPickerViewController *)picker didFinishPickingItem:(id)item{
    if ([item isKindOfClass:[NSString class]]) {
        self.nameTextField.text = item;
    }
    else{
        
    }
}
- (IBAction)nextClciked:(UIButton *)sender {
    if (self.nameTextField.text.length == 0) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"Fill in the name of the dish" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else if (self.priceTextField.text.length == 1){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"Fill in the price of the dish" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else{
        FRestaurentDetailsViewController *picker = [[FRestaurentDetailsViewController alloc]initWithNibName:@"FRestaurentDetailsViewController" bundle:[NSBundle mainBundle]];
        self.item.itemTitle = self.nameTextField.text;
        self.item.itemPrice = [NSNumber numberWithInteger:[self.priceTextField.text integerValue]];
        self.item.itemDescription = self.descriptionTextView.text;
        picker.item = self.item;
        [self.view endEditing:YES];
        [self.navigationController pushViewController:picker animated:YES];
    }
}

@end
