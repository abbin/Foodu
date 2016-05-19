//
//  FItemPickerViewController.m
//  Foodu
//
//  Created by Abbin Varghese on 19/05/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FItemPickerViewController.h"

@interface FItemPickerViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic)PFQuery *query;
@property (strong, nonatomic)NSMutableArray *objects;
@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avtivityIndicator;

@end

@implementation FItemPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setKeyboardOnSearchBar:self.searchBar];
    self.query = [PFQuery queryWithClassName:@"items"];
    [self.query includeKey:@"restaurent"];
    self.query.limit = 10;
    
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.searchBar isFirstResponder]) {
        [self.view endEditing:YES];
    }
}

- (IBAction)dismissButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.query cancel];
    [self.avtivityIndicator startAnimating];
    [self.query whereKey:@"itemTitle" containsString:searchText];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.avtivityIndicator stopAnimating];
        if (!error) {
            if (objects.count>0) {
                self.objects = [objects mutableCopy];
                [self.itemsTableView reloadData];
            }
            else{
                self.objects = [@[searchText] mutableCopy];
                [self.itemsTableView reloadData];
            }
        }
    }];
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
    return self.objects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCellID"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    if ([[self.objects objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
        cell.textLabel.text = [NSString stringWithFormat:@"Add new dish '%@'",[self.objects objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = @"";
    }
    else{
        FItem *item = [self.objects objectAtIndex:indexPath.row];
        cell.textLabel.text = item.itemTitle;
        cell.detailTextLabel.text = item.restaurent.name;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(FItemPicker:didFinishPickingItem:)]) {
            [self.delegate FItemPicker:self didFinishPickingItem:[self.objects objectAtIndex:indexPath.row]];
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height/10;
}


@end
