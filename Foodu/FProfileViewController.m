//
//  FProfileViewController.m
//  Foodu
//
//  Created by Abbin on 10/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FProfileViewController.h"
#import "FProfileTableViewCell.h"
#import "AppDelegate.h"
#import "FSignUpOneViewController.h"

typedef NS_ENUM(NSInteger, indexPath) {
    editProfile,
    friendsList,
    findFriends,
    rateAppstore,
    feedBack,
    about,
    signOut
};

@interface FProfileViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *profilePhotoEditButton;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation FProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x,
                                       self.headerView.frame.origin.y,
                                       self.headerView.frame.size.width,
                                       [UIScreen mainScreen].bounds.size.height/2);

    [self.headerView layoutIfNeeded];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.clipsToBounds = YES;
    
    self.profilePhotoEditButton.layer.cornerRadius = self.profilePhotoEditButton.frame.size.height/2;
    self.profilePhotoEditButton.clipsToBounds = YES;
    
    self.nameLabel.text = [FCurrentUser name];
    self.profileImageView.image = [UIImage imageNamed:@"profilePlaceholder"];
    self.profileImageView.file = [FCurrentUser profilePicture];
    [self.profileImageView loadInBackground];

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

/////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark UITABLEVIEW DELEGATE AND DATASOURE

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FProfileTableViewCell"];
    switch (indexPath.row) {
        case editProfile:
            cell.titleLabel.text = @"Edit profile";
            cell.sideImageView.image = [UIImage imageNamed:@"EditProfile"];
            break;
        case friendsList:
            cell.titleLabel.text = @"Friends list";
            cell.sideImageView.image = [UIImage imageNamed:@"FriendsList"];
            break;
        case findFriends:
            cell.titleLabel.text = @"Find friends on Carte";
            cell.sideImageView.image = [UIImage imageNamed:@"FindFriends"];
            break;
        case rateAppstore:
            cell.titleLabel.text = @"Rate us on the App Store";
            cell.sideImageView.image = [UIImage imageNamed:@"Appstore"];
            break;
        case feedBack:
            cell.titleLabel.text = @"Send us a feedback";
            cell.sideImageView.image = [UIImage imageNamed:@"FeedBack"];
            break;
        case about:
            cell.titleLabel.text = @"About";
            cell.sideImageView.image = [UIImage imageNamed:@"About"];
            break;
        case signOut:
            cell.titleLabel.text = @"Sign out";
            cell.sideImageView.image = [UIImage imageNamed:@"Logout"];
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndexPath = indexPath;
    switch (indexPath.row) {
        case editProfile:{
            
        }
            break;
        case friendsList:{
            
        }
            break;
        case findFriends:{
            
        }
            break;
        case rateAppstore:{
            
        }
            break;
        case feedBack:{
            
        }
            break;
        case about:{
            
        }
            break;
        case signOut:{
            [self signOut];
        }
            break;
            
        default:
            break;
    }
}

-(void)signOut{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Sign out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.view.userInteractionEnabled = NO;
        [[FAlertView sharedHUD] showActivityIndicatorOnView:nil];
        [FCurrentUser logOutCurrentUser:^(BOOL success, UserType userType) {
            
            self.view.userInteractionEnabled = YES;
            [[FAlertView sharedHUD]hideActivityIndicatorOnView];
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FSignUpOneViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FSignUpOneViewController"];
            
            if (userType == FaceBookUser) {
                [rootViewController setViewType:FacebookView];
            }
            else{
                [rootViewController setViewType:SignInView];
            }
            [appDelegate changeRootViewController:rootViewController];
            
        } failure:^(NSString *error) {
            self.view.userInteractionEnabled = YES;
            [[FAlertView sharedHUD]showHUDOnView:self.view withText:@"Failed to SignOut. Please try again" wait:5];
        }];
    }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.profileTableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    }];
    [alert addAction:actionYes];
    [alert addAction:actionNo];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
