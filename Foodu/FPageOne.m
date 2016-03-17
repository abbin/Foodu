//
//  FPageOne.m
//  Foodu
//
//  Created by Abbin on 16/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FPageOne.h"

@interface FPageOne ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrain;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuudLabel;
@property (weak, nonatomic) IBOutlet UILabel *discoverLabel;

@end

@implementation FPageOne

- (void)viewDidLoad {
    [super viewDidLoad];
    int height = [UIScreen mainScreen].bounds.size.height/2;
    int width = (height*125)/667;
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-width,
                                                                          [UIScreen mainScreen].bounds.size.height/8,
                                                                          width,
                                                                          height)];
    imageview.backgroundColor = [UIColor lightTextColor];
    

    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: imageview.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: (CGSize){10.0, 10.0}].CGPath;
    
    imageview.layer.mask = maskLayer;
    
    [self.view addSubview:imageview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adustParallax:)
                                                 name:@"paralax"
                                               object:nil];
    
    NSString *fontname = @"";
    NSString *fontTwo = @"";
    if ([UIFont fontWithName:@".SFUIDisplay-Thin" size:10]) {
        fontname = @".SFUIDisplay-Thin";
        fontTwo = @".SFUIDisplay-Light";
    }
    else{
        fontTwo = @".HelveticaNeueInterface-Thin";
        fontname = @".HelveticaNeueInterface-UltraLightP2";
    }
    
        self.joinLabel.font = [UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/17];
        self.discoverLabel.font = [UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/17];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:[UIScreen mainScreen].bounds.size.width/13];


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) adustParallax:(NSNotification *) notification{
    CGPoint point = [self.view.superview convertPoint:self.view.frame.origin toView:nil];
    self.constrain.constant = point.x;
}




@end
