//
//  FListViewController.m
//  Foodu
//
//  Created by Abbin on 04/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FListViewController.h"
#import "FlistTableViewCell.h"
#import "FNextTableViewCell.h"

@interface FListViewController ()

@property (nonatomic,strong) UISearchBar *searchBarTop;
@property (nonatomic,assign) NSInteger numberOfRows;

@end

@implementation FListViewController

{
    int suss;
    int fai;
    NSMutableArray *restArray;
    NSDate *dateOne;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBarTop = [[UISearchBar alloc]initWithFrame:CGRectZero];
    self.searchBarTop.placeholder = @"Search near by";
    [self.searchBarTop sizeToFit];
    self.navigationItem.titleView = self.searchBarTop;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

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
    
    FlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.row%2) {
        cell.constain.constant = [UIScreen mainScreen].bounds.size.width/10;
    }
    else{
        cell.constain.constant = -[UIScreen mainScreen].bounds.size.width/10;
    }
    NSDictionary *imageDict = object.itemImageArray[0];
    cell.itemImageView.file = [imageDict objectForKey:@"file"];
    cell.titleLabel.text = object.itemTitle;
    cell.locationLabel.text = object.restaurent.address;
    cell.itemImageView.image = [UIImage imageNamed:@"loading"];
    [cell.itemImageView loadInBackground];
    return cell;
}

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath{
    FNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFTableViewCell" forIndexPath:indexPath];
    cell.cellActivityIndicator.hidden = !self.loading;
    if (self.loading) {
        [cell.cellActivityIndicator startAnimating];
        cell.nextLabel.text = @"Loading...";
    }
    else{
        [cell.cellActivityIndicator stopAnimating];
        cell.nextLabel.text = @"Load More...";
    }
    return cell;
}

-(void)objectsDidLoad:(NSError *)error{
    [super objectsDidLoad:error];
    self.numberOfRows = [self objects].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.numberOfRows) {
        return 55;
    }
    else{
        return [UIScreen mainScreen].bounds.size.width;
    }
}


@end
