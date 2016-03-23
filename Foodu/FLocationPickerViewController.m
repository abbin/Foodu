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
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation FLocationPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setKeyboardOnSearchBar:self.searchBar];
    
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    filter.country = countryCode;
    filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
    
    self.fetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:nil
                                                       filter:filter];
    self.fetcher.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
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
        if (error) {
            [[GMSPlacesClient sharedClient] lookUpPlaceID:prediction.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
                if (error) {
                    
                }
                else{
                    NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:result];
                    [self dismissViewControllerAnimated:YES completion:^{
                        if ([self.delegate respondsToSelector:@selector(FLocationPicker:didFinishPickingPlace:)]) {
                            [self.delegate  FLocationPicker:self didFinishPickingPlace:obj];
                        }
                    }];
                }
            }];
        }
        else{
            NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:result];
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(FLocationPicker:didFinishPickingPlace:)]) {
                    [self.delegate  FLocationPicker:self didFinishPickingPlace:obj];
                }
            }];
        }
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
    if (predictions.count>0) {
        self.label.hidden = YES;
    }
    else{
        self.label.hidden = NO;
    }
    self.listArray = predictions;
    [self.listTableView reloadData];
}

- (void)didFailAutocompleteWithError:(NSError *)error {
    
}

@end
