//
//  FGeoListTableViewController.m
//  Foodu
//
//  Created by Abbin on 30/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FGeoListTableViewController.h"
#import "FGeoListTableViewCell.h"

@interface FGeoListTableViewController ()

@property (nonatomic,strong) UISearchBar *searchBarTop;
@property (nonatomic,assign) NSInteger numberOfRows;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *addButton;
@end

@implementation FGeoListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLabel];
    [self setUpSearchBar];
}

- (IBAction)didTapOnTableView:(UITapGestureRecognizer *)sender {
    [self.searchBarTop endEditing:YES];
}

-(void)setupLabel{
    self.label = [[UILabel alloc]initWithFrame:CGRectZero];
    self.label.text = @"No results found\nWould you like to add a FUUD?";
    self.label.numberOfLines = 0;
    [self.label setTextAlignment:NSTextAlignmentCenter];
    self.label.textColor = [UIColor lightGrayColor];
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    [self.label sizeToFit];
    self.label.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/3);
    self.label.hidden = YES;
    [self.tableView addSubview:self.label];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton addTarget:self
               action:@selector(addButtonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    [self.addButton setImage:[UIImage imageNamed:@"pin"] forState:UIControlStateNormal];
    self.addButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2,
                                      self.label.frame.origin.y+self.label.frame.size.height+20,
                                      [UIScreen mainScreen].bounds.size.width/13,
                                      [UIScreen mainScreen].bounds.size.width/13);
    
    self.addButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.addButton.center.y);
    self.addButton.hidden = YES;
    [self.tableView addSubview:self.addButton];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBarTop endEditing:YES];
}

-(void)addButtonClicked{
    
}

-(void)setUpSearchBar{
    
    self.searchBarTop = [[UISearchBar alloc]initWithFrame:CGRectZero];
    self.searchBarTop.placeholder = @"Search near by";
    self.searchBarTop.delegate = self;
    [self.searchBarTop sizeToFit];
    self.navigationItem.titleView = self.searchBarTop;
    
    for(UIView *subView in self.searchBarTop.subviews) {
        if([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *)subView setKeyboardAppearance:UIKeyboardAppearanceLight];
            [(UITextField *)subView setTextColor:[UIColor blackColor]];
            [(UITextField *)subView setReturnKeyType:UIReturnKeyDefault];
        } else {
            for(UIView *subSubView in [subView subviews]) {
                if([subSubView conformsToProtocol:@protocol(UITextInputTraits)]) {
                    [(UITextField *)subSubView setKeyboardAppearance:UIKeyboardAppearanceLight];
                    [(UITextField *)subSubView setTextColor:[UIColor blackColor]];
                    [(UITextField *)subSubView setReturnKeyType:UIReturnKeyDefault];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = [FItem parseClassName];
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
    }
    
    return self;
}

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query includeKey:@"restaurent"];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query orderByDescending:@"createdAt"];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(FItem *)object {
    static NSString *cellIdentifier = @"FlistTableViewCell";
    
    FGeoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    FImages *imageObj = object.itemImageArray[0];
//    cell.itemImageView.file = imageObj.thumbnail1x;
//    cell.titleLabel.text = object.itemTitle;
//    cell.locationLabel.text = object.restaurent.address;
//    cell.itemImageView.image = [UIImage imageNamed:@"loading"];
//    [cell.itemImageView loadInBackground];
    return cell;
}

-(void)objectsDidLoad:(NSError *)error{
    [super objectsDidLoad:error];
    self.numberOfRows = [self objects].count;
    if (self.objects.count == 0) {
        self.label.hidden = NO;
        self.addButton.hidden = NO;
    }
    else{
        self.label.hidden = YES;
        self.addButton.hidden = YES;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.numberOfRows) {
        return 55;
    }
    else{
        return [UIScreen mainScreen].bounds.size.height/4;
    }
}

@end
