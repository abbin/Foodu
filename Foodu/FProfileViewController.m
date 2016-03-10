//
//  FProfileViewController.m
//  Foodu
//
//  Created by Abbin on 10/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FProfileViewController.h"
#import "FProfileTableViewCell.h"

@interface FProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation FProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, [UIScreen mainScreen].bounds.size.height/2);
    self.firstNameLabel.font = [UIFont fontWithName:@".SFUIDisplay-Ultralight" size:[UIScreen mainScreen].bounds.size.width/8];
    self.lastNameLabel.font = [UIFont fontWithName:@".SFUIDisplay-Ultralight" size:[UIScreen mainScreen].bounds.size.width/8];
    [self.headerView layoutIfNeeded];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.selectedIndexPath) {
        [self.profileTableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    else{
        return 5;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Profile";
    }
    else{
        return @"Others";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FProfileTableViewCell"];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = @"Edit profile";
                break;
            case 1:
                cell.titleLabel.text = @"Friends list";
                break;
                
            default:
                break;
        }
    }
    else{
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = @"Find friends on Carte";
                break;
            case 1:
                cell.titleLabel.text = @"Rate us on the App Store";
                break;
            case 2:
                cell.titleLabel.text = @"Send us a feedback";
                break;
            case 3:
                cell.titleLabel.text = @"About";
                break;
            case 4:
                cell.titleLabel.text = @"Sign out";
                break;
                
            default:
                break;
        }

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndexPath = indexPath;
}

@end
