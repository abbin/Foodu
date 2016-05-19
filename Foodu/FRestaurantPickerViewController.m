//
//  FRestaurantPickerViewController.m
//  Foodu
//
//  Created by Abbin Varghese on 19/05/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FRestaurantPickerViewController.h"

@interface FRestaurantPickerViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic)PFQuery *query;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *restTableView;
@property (strong, nonatomic)NSMutableArray *rests;
@end

@implementation FRestaurantPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setKeyboardOnSearchBar:self.searchBar];
    self.query = [PFQuery queryWithClassName:@"restaurants"];
    self.query.limit = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)dismissButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.query cancel];
    [self.activityIndicator startAnimating];
    [self.query whereKey:@"name" containsString:searchText];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.activityIndicator stopAnimating];
        if (!error) {
            if (objects.count>0) {
                self.rests = [objects mutableCopy];
                [self.restTableView reloadData];
            }
            else{
                self.rests = [@[searchText] mutableCopy];
                [self.restTableView reloadData];
            }
        }
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.searchBar isFirstResponder]) {
        [self.view endEditing:YES];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rests.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCellID"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    if ([[self.rests objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
        cell.textLabel.text = [NSString stringWithFormat:@"Add new Restaurant '%@'",[self.rests objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = @"";
    }
    else{
        FRestaurants *rest = [self.rests objectAtIndex:indexPath.row];
        cell.textLabel.text = rest.name;
        cell.detailTextLabel.text = rest.address;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(restaurantPicker:didFinishPickingrestaurant:)]) {
            [self.delegate restaurantPicker:self didFinishPickingrestaurant:[self.rests objectAtIndex:indexPath.row]];
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height/10;
}

@end
