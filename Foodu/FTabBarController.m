//
//  FTabBarController.m
//  Foodu
//
//  Created by Abbin on 07/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FTabBarController.h"
#import "UIColor+FColours.h"
#include <Photos/Photos.h>
#import "FKinveyTestObj.h"

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

@property (nonatomic, retain) id<KCSStore> store;

@end

@implementation FTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KCSCollection* collection = [KCSCollection collectionFromString:@"Updates" ofClass:[FKinveyTestObj class]];
    _store = [KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyResource : collection,
                                                                  KCSStoreKeyCachePolicy : @(KCSCachePolicyBoth),
                                                                  KCSStoreKeyOfflineUpdateEnabled : @(YES)}];
     [[KCSClient sharedClient] setOfflineDelegate:self];
    
    self.tabBarView.frame = CGRectMake(0.0,
                                       self.view.frame.size.height - self.tabBarView.frame.size.height,
                                       [UIScreen mainScreen].bounds.size.width,
                                       44);
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.tabBarView.frame.size.width, 0.3f);
    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.tabBarView.layer addSublayer:topBorder];
    [self.view addSubview:self.tabBarView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES
                     completion:^ {
                         
                     }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    
    KiiBucket *bucket = [Kii bucketWithName:@"mydata"];
    
    
    KiiObject *object = [bucket createObject];
    
    [object setObject:[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]] forKey:@"userDate"];
    [object setObject:@"asd" forKey:@"feedText"];
    [object setObject:[NSNumber numberWithBool:NO] forKey:@"likeStatus"];
    [object setObject:[NSNumber numberWithBool:NO] forKey:@"dislikeStatus"];
    [object setObject:[NSNumber numberWithInteger:0] forKey:@"feedVotes"];
    
    
    NSData *imageData = nil;

        imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((chosenImage), 0.9)];
        double imageSize = imageData.length;
        
        [object setObject:@"MyImage" forKey:@"attachedImg"];
        [object setObject:[NSNumber numberWithDouble:imageSize] forKey:@"fileSize"];

    [object saveWithBlock:^(KiiObject *object, NSError *error)
     {

                 [object uploadBodyWithData:imageData andContentType:@"image/jpg" andCompletion:^(KiiObject *obj, NSError *error)
                  {
                          
                  }];

     }];
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pinButtonClicked:(UIButton *)sender {
}

- (IBAction)homeButtonClicked:(UIButton *)sender {
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backView.center = self.homeButton.center;
    } completion:^(BOOL finished) {
        
    }];
    
    [self.geoListImageView setImage:[UIImage imageNamed:@"geoList"]];
    [self.bookMarkImageView setImage:[UIImage imageNamed:@"bookMarks"]];
    [self.profileImageView setImage:[UIImage imageNamed:@"profile"]];
    
    [self.homeImageView setImage:[UIImage imageNamed:@"homeSelected"]];
    
    [self setSelectedIndex:0];
}

- (IBAction)geoListButtonClicked:(UIButton *)sender {
    [self.bookMarkImageView setImage:[UIImage imageNamed:@"bookMarks"]];
    [self.profileImageView setImage:[UIImage imageNamed:@"profile"]];
    [self.homeImageView setImage:[UIImage imageNamed:@"home"]];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backView.center = self.geoListButton.center;
    } completion:^(BOOL finished) {
        
    }];
    
    [self.geoListImageView setImage:[UIImage imageNamed:@"geoListSelected"]];
    
    [self setSelectedIndex:1];
}

- (IBAction)bookMarkButtonCLiked:(UIButton *)sender {
    [self.geoListImageView setImage:[UIImage imageNamed:@"geoList"]];
    [self.profileImageView setImage:[UIImage imageNamed:@"profile"]];
    [self.homeImageView setImage:[UIImage imageNamed:@"home"]];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backView.center = self.bookMarkButton.center;
    } completion:^(BOOL finished) {
        
    }];
    
    [self.bookMarkImageView setImage:[UIImage imageNamed:@"bookMarkSelected"]];
    
    [self setSelectedIndex:2];
}

- (IBAction)profileButtonClicked:(UIButton *)sender {
    [self.geoListImageView setImage:[UIImage imageNamed:@"geoList"]];
    [self.bookMarkImageView setImage:[UIImage imageNamed:@"bookMarks"]];
    [self.homeImageView setImage:[UIImage imageNamed:@"home"]];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backView.center = self.profileButton.center;
    } completion:^(BOOL finished) {
        
    }];
    
    [self.profileImageView setImage:[UIImage imageNamed:@"profileSelected"]];
    
    [self setSelectedIndex:3];
}

@end
