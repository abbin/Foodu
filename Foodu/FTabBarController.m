//
//  FTabBarController.m
//  Foodu
//
//  Created by Abbin on 07/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FTabBarController.h"
#import "UIColor+FColours.h"

@interface FTabBarController ()

@property (strong, nonatomic) IBOutlet UIView *tabBarView;

@property (weak, nonatomic) IBOutlet UIButton *pinButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *geoListButton;
@property (weak, nonatomic) IBOutlet UIButton *bookMarkButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *geoListImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bookMarkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UPStackMenu *stack;


@end

@implementation FTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarView.frame = CGRectMake(0.0,
                                       self.view.frame.size.height - self.tabBarView.frame.size.height,
                                       [UIScreen mainScreen].bounds.size.width,
                                       55);
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.tabBarView.frame.size.width, 0.3f);
    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.tabBarView.layer addSublayer:topBorder];
    [self.view addSubview:self.tabBarView];

    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 54, 54)];
    [self.contentView setBackgroundColor:[UIColor blackColor]];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin"]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setFrame:CGRectInset(self.contentView.frame, 15, 15)];
    [self.contentView addSubview:icon];
    
    self.stack = [[UPStackMenu alloc] initWithContentView:self.contentView];
    [self.stack setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/5/2, [UIScreen mainScreen].bounds.size.height-27.5)];
    [self.stack setDelegate:self];
    
    UPStackMenuItem *squareItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera"] highlightedImage:nil title:@""];
    UPStackMenuItem *circleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"gallery"] highlightedImage:nil title:@""];
    squareItem.layer.cornerRadius = 5;
    circleItem.layer.cornerRadius = 5;
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:squareItem, circleItem, nil];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitleColor:[UIColor whiteColor]];
    }];

    [self.stack setAnimationType:UPStackMenuAnimationType_progressive];
    [self.stack setStackPosition:UPStackMenuStackPosition_up];
    self.stack.itemsSpacing = 25;
    [self.stack setOpenAnimationDuration:.4];
    [self.stack setCloseAnimationDuration:.4];
    
    [self.stack addItems:items];
    [self.view addSubview:self.stack];

}

- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index
{
    [self.stack closeStack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeButtonClicked:(UIButton *)sender {
    [self.stack closeStack];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backView.center = self.homeButton.center;
    } completion:^(BOOL finished) {
        
    }];
    
    [self.geoListImageView setImage:[UIImage imageNamed:@"geoList"]];
    [self.bookMarkImageView setImage:[UIImage imageNamed:@"bookMarks"]];
    [self.profileImageView setImage:[UIImage imageNamed:@"profile"]];
    
//    self.backView.backgroundColor = [UIColor HomeGreen];
    [self.homeImageView setImage:[UIImage imageNamed:@"homeSelected"]];
    
    [self setSelectedIndex:0];
}

- (IBAction)geoListButtonClicked:(UIButton *)sender {
    [self.stack closeStack];
    [self.bookMarkImageView setImage:[UIImage imageNamed:@"bookMarks"]];
    [self.profileImageView setImage:[UIImage imageNamed:@"profile"]];
    [self.homeImageView setImage:[UIImage imageNamed:@"home"]];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backView.center = self.geoListButton.center;
    } completion:^(BOOL finished) {
        
    }];
    
//    self.backView.backgroundColor = [UIColor GeoListPink];
    [self.geoListImageView setImage:[UIImage imageNamed:@"geoListSelected"]];
    
    [self setSelectedIndex:1];
}

- (IBAction)bookMarkButtonCLiked:(UIButton *)sender {
    [self.stack closeStack];
    [self.geoListImageView setImage:[UIImage imageNamed:@"geoList"]];
    [self.profileImageView setImage:[UIImage imageNamed:@"profile"]];
    [self.homeImageView setImage:[UIImage imageNamed:@"home"]];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backView.center = self.bookMarkButton.center;
    } completion:^(BOOL finished) {
        
    }];
    
//    self.backView.backgroundColor = [UIColor BookMarkBrown];
    [self.bookMarkImageView setImage:[UIImage imageNamed:@"bookMarkSelected"]];
    
    [self setSelectedIndex:2];
}

- (IBAction)profileButtonClicked:(UIButton *)sender {
    [self.stack closeStack];
    [self.geoListImageView setImage:[UIImage imageNamed:@"geoList"]];
    [self.bookMarkImageView setImage:[UIImage imageNamed:@"bookMarks"]];
    [self.homeImageView setImage:[UIImage imageNamed:@"home"]];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backView.center = self.profileButton.center;
    } completion:^(BOOL finished) {
        
    }];
    
//    self.backView.backgroundColor = [UIColor ProfileBlue];
    [self.profileImageView setImage:[UIImage imageNamed:@"profileSelected"]];
    
    [self setSelectedIndex:3];
}

@end
