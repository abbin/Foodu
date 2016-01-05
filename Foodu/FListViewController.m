//
//  FListViewController.m
//  Foodu
//
//  Created by Abbin on 04/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FListViewController.h"
#import "FlistTableViewCell.h"

@interface FListViewController ()

@end

@implementation FListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 50, 0)];
    // Do any additional setup after loading the view.
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
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
//    [query whereKey:@"objectId" equalTo:@"gp1g2Zq4PU"];
    [query orderByDescending:@"createdAt"];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(FItem *)object {
    static NSString *cellIdentifier = @"FlistTableViewCell";
    
    FlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFFile *file = [object.itemImageArray objectAtIndex:0];
    cell.itemImageView.file = file;
    cell.itemImageView.image = [UIImage imageNamed:@"placeholder.png"];
    [cell.itemImageView loadInBackground];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height/4;
}

@end
