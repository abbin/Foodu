//
//  FPageTWOViewController.m
//  Foodu
//
//  Created by Abbin on 16/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FPageTWOViewController.h"
#import "FPageOne.h"
#import "FPageTwo.h"
#import "FPageThree.h"
#import "FPageFour.h"

@interface FPageTWOViewController ()

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (assign,nonatomic) NSInteger currentPage;
@end

@implementation FPageTWOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewControllerTwo"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FirstLaunch" bundle:nil];
    FPageOne *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FPageOne"];
    NSArray *viewControllers = @[rootViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = self.view.frame;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setDelegate:self];
        }
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  //  CGFloat percentage = scrollView.contentOffset.x;
  //  NSDictionary* userInfo = @{@"adustment": @(percentage)};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"paralax" object:self userInfo:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    switch (self.currentPage) {
        case 1:
            return nil;
            break;
        case 2:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FirstLaunch" bundle:nil];
            FPageOne *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FPageOne"];
            
            return rootViewController;
        }
            break;
        case 3:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FirstLaunch" bundle:nil];
            FPageTwo *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FPageTwo"];
            
            return rootViewController;
        }
            break;
        case 4:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FirstLaunch" bundle:nil];
            FPageFour *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FPageFour"];
            rootViewController.delegate = self.delegateObj;
            return rootViewController;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    switch (self.currentPage) {
        case 1:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FirstLaunch" bundle:nil];
            FPageTwo *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FPageTwo"];
            return rootViewController;
        }
            break;
        case 2:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FirstLaunch" bundle:nil];
            FPageThree *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FPageThree"];
            return rootViewController;
        }
            break;
        case 3:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FirstLaunch" bundle:nil];
            FPageFour *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FPageFour"];
            rootViewController.delegate = self.delegateObj;
            return rootViewController;
        }
            break;
        case 4:
            return nil;
            break;
        default:
            return nil;
            break;
    }
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    if ([[pendingViewControllers objectAtIndex:0] isKindOfClass:[FPageOne class]]) {
        self.currentPage = 1;
    }
    else if ([[pendingViewControllers objectAtIndex:0] isKindOfClass:[FPageTwo class]]){
        self.currentPage = 2;
    }
    else if ([[pendingViewControllers objectAtIndex:0] isKindOfClass:[FPageThree class]]){
        self.currentPage = 3;
    }
    else{
        self.currentPage = 4;
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 4;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}



@end
