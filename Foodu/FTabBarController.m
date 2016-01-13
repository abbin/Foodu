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
                                       44);
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.tabBarView.frame.size.width, 0.3f);
    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.tabBarView.layer addSublayer:topBorder];
    [self.view addSubview:self.tabBarView];

    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 43, 43)];
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin"]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setFrame:CGRectInset(self.contentView.frame,10, 10)];
    [self.contentView addSubview:icon];
    
    self.stack = [[UPStackMenu alloc] initWithContentView:self.contentView];
    [self.stack setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/5/2, [UIScreen mainScreen].bounds.size.height-21)];
    [self.stack setDelegate:self];
    
    UPStackMenuItem *camera = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera"] highlightedImage:nil title:@""];
    UPStackMenuItem *gallery = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"gallery"] highlightedImage:nil title:@""];
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects: gallery, camera, nil];

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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self dude];
}

-(void)dude{
    NSString *imageName = [NSString stringWithFormat:@"%d.jpg",(int)[self randomFloatBetween:1 and:55]];
    UIImage *img = [UIImage imageNamed:imageName];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.0);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    
    imageName = [NSString stringWithFormat:@"%d.jpg",(int)[self randomFloatBetween:1 and:55]];
    img = [UIImage imageNamed:imageName];
    imageData = UIImageJPEGRepresentation(img, 0.0);
    PFFile *imageFile4 = [PFFile fileWithData:imageData];
    
    imageName = [NSString stringWithFormat:@"%d.jpg",(int)[self randomFloatBetween:1 and:55]];
    img = [UIImage imageNamed:imageName];
    imageData = UIImageJPEGRepresentation(img, 0.0);
    PFFile *imageFile2 = [PFFile fileWithData:imageData];
    
    imageName = [NSString stringWithFormat:@"%d.jpg",(int)[self randomFloatBetween:1 and:55]];
    img = [UIImage imageNamed:imageName];
    imageData = UIImageJPEGRepresentation(img, 0.0);
    PFFile *imageFile3 = [PFFile fileWithData:imageData];
    
    FImages *imageObj = [FImages object];
    imageObj.itemImage = imageFile;
    FImages *imageObj2 = [FImages object];
    imageObj2.itemImage = imageFile2;
    FImages *imageObj3 = [FImages object];
    imageObj3.itemImage = imageFile3;
    FImages *imageObj4 = [FImages object];
    imageObj4.itemImage = imageFile4;
    
//    [imageObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"first susses");
//            [imageObj2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                if (succeeded) {
//                    NSLog(@"Second susses");
//                    [imageObj3 saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                        if (succeeded) {
//                            NSLog(@"third susses");
//                            [imageObj4 saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                                if (succeeded) {
//                                    NSLog(@"final susses");
                                    NSArray *imageArray = [NSArray arrayWithObjects:imageObj,imageObj2,imageObj3,imageObj4, nil];
                                    
                                    FItem *spotObj = [FItem object];
                                    spotObj.itemImageArray = imageArray;
                                    spotObj.itemTitle = @"Sample Title";
                                    spotObj.itemDescription = @"The Parse platform provides a complete backend solution for your mobile application. Our goal is to totally eliminate the need for writing server code or maintaining servers.";
                                    
                                    float lat = [self randomFloatBetween:8 and:12];
                                    float lon = [self randomFloatBetween:74 and:77];
                                    
                                    FRestaurants *restaurent = [FRestaurants object];
                                    restaurent.name = @"Balaji's Restaurent and Cafe";
                                    restaurent.location = [PFGeoPoint geoPointWithLatitude:lat longitude:lon];
                                    
                                    spotObj.restaurent = restaurent;
                                    
                                    spotObj.itemRating = [NSNumber numberWithInt:(int)[self randomFloatBetween:0 and:5]];
                                    spotObj.itemPrice = [NSNumber numberWithInt:(int)[self randomFloatBetween:100 and:500]];
                                    spotObj.itemAddress = @"Blah Blah";
                                    
                                    [spotObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                        if (succeeded) {
                                            NSLog(@"Dude susses");
                                            [self dude];
                                        }
                                        else{
                                            NSLog(@"Final Failed");
                                        }
                                        
                                    }];
                                    
//                                }
//                                else{
//                                    NSLog(@"forth Failed");
//                                }
//                            }];
//                        }
//                        else{
//                            NSLog(@"Third Failed");
//                        }
//                    }];
//                }
//                else{
//                    NSLog(@"Second Failed");
//                }
//            }];
//        }
//        else{
//            NSLog(@"First Failed");
//        }
//    }];

}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
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
