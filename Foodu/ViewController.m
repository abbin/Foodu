//
//  ViewController.m
//  Foodu
//
//  Created by Abbin on 04/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sus;
@property (weak, nonatomic) IBOutlet UILabel *fail;



@end

@implementation ViewController

{
    int suss;
    int fai;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    suss = 0;
    fai = 0;
//    [self refresh:0];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh:(int)i{
    i++;
    int size = 0;
    float lat = [self randomFloatBetween:8 and:12];
    float lon = [self randomFloatBetween:74 and:77];
    
    FItem *spotObj = [FItem object];
    spotObj.itemTitle = @"Sample Title";
    spotObj.itemDescription = @"The Parse platform provides a complete backend solution for your mobile application. Our goal is to totally eliminate the need for writing server code or maintaining servers.";
    spotObj.itemStoreName = @"Balajis";
    spotObj.itemRating = [NSNumber numberWithInt:(int)[self randomFloatBetween:0 and:5]];
    spotObj.itemLocation = [PFGeoPoint geoPointWithLatitude:lat longitude:lon];
    spotObj.itemPrice = [NSNumber numberWithInt:(int)[self randomFloatBetween:100 and:500]];
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    int num = [self randomFloatBetween:1 and:5];
    for (int k = 0; k<num; k++) {
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg",(int)[self randomFloatBetween:0 and:72]];
//        NSString *imageName = [NSString stringWithFormat:@"24.jpg"];
        NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:imageName], 0.0);
        NSLog(@"File size is : %.2f MB",(float)imageData.length/1024.0f/1024.0f);
        size = size + imageData.length/1024.0f/1024.0f;
        if (imageData==nil) {
            [self refresh:i];
        }
        else{
            PFFile *imageFile = [PFFile fileWithData:imageData];
            [imageArray addObject:imageFile];
        }
    }
    
    spotObj.itemImageArray = imageArray;
    [spotObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            suss++;
            self.sus.text = [NSString stringWithFormat:@"%i",suss];
            
            [self refresh:i];
        }
        else{
            fai++;
            self.fail.text = [NSString stringWithFormat:@"%i",fai];
        }
    }];
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

@end
