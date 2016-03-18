//
//  FLocationPickerViewController.m
//  Foodu
//
//  Created by Abbin on 18/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FLocationPickerViewController.h"

@interface FLocationPickerViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarConstarin;
@property (strong, nonatomic) GMSAutocompleteFetcher *fetcher;
@property (strong, nonatomic) NSArray *listArray;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

@implementation FLocationPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setKeyboardOnSearchBar:self.searchBar];
    
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.country = @"IND";
    filter.type = kGMSPlacesAutocompleteTypeFilterCity;
    
    self.fetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:nil
                                                       filter:filter];
    self.fetcher.delegate = self;
    
   // [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellID"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
    self.searchBarConstarin.constant = 8;
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.fetcher sourceTextHasChanged:searchText];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)dismissButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    GMSAutocompletePrediction *prediction = [self.listArray objectAtIndex:indexPath.row];
    [[GMSPlacesClient sharedClient] lookUpPlaceID:prediction.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCellID"];
    }
    GMSAutocompletePrediction *prediction = [self.listArray objectAtIndex:indexPath.row];
    cell.textLabel.attributedText = prediction.attributedPrimaryText;
    cell.detailTextLabel.attributedText = prediction.attributedSecondaryText;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height/10;
}

-(void)setKeyboardOnSearchBar:(UISearchBar *)searchBar
{
    for(UIView *subView in searchBar.subviews) {
        if([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *)subView setKeyboardAppearance:UIKeyboardAppearanceDark];
            [(UITextField *)subView setReturnKeyType:UIReturnKeySearch];
            [(UITextField *)subView setTextColor:[UIColor whiteColor]];
        } else {
            for(UIView *subSubView in [subView subviews]) {
                if([subSubView conformsToProtocol:@protocol(UITextInputTraits)]) {
                    [(UITextField *)subSubView setReturnKeyType:UIReturnKeySearch];
                    [(UITextField *)subSubView setKeyboardAppearance:UIKeyboardAppearanceDark];
                    [(UITextField *)subSubView setTextColor:[UIColor whiteColor]];
                }
            }
        }
    }
}

- (void)didAutocompleteWithPredictions:(NSArray *)predictions {
    self.listArray = predictions;
    [self.listTableView reloadData];
}

- (void)didFailAutocompleteWithError:(NSError *)error {
    NSLog(@"%@",[NSString stringWithFormat:@"%@", error.localizedDescription]);
}

@end
