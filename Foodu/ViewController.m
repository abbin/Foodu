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
    NSMutableArray *restArray;
    NSMutableArray *avgArray;
    NSDate *dateOne;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    restArray = [[NSMutableArray alloc]init];
    avgArray = [[NSMutableArray alloc]init];
    suss = 0;
    fai = 0;
   [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)refresh{
     dateOne = [NSDate date];

    
    NSString *imageName = [NSString stringWithFormat:@"%d.jpg",(int)[self randomFloatBetween:1 and:55]];
    UIImage *img = [UIImage imageNamed:imageName];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.0);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    
    imageName = [NSString stringWithFormat:@"%d.jpg",(int)[self randomFloatBetween:1 and:55]];
    img = [UIImage imageNamed:imageName];
    imageData = UIImageJPEGRepresentation(img, 0.0);
    PFFile *imageFile2 = [PFFile fileWithData:imageData];
    
    imageName = [NSString stringWithFormat:@"%d.jpg",(int)[self randomFloatBetween:1 and:55]];
    img = [UIImage imageNamed:imageName];
    imageData = UIImageJPEGRepresentation(img, 0.0);
    PFFile *imageFile3 = [PFFile fileWithData:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            if (!imageFile.dirty & !imageFile2.dirty & !imageFile3.dirty) {
                [self saveObjWith2:imageFile :imageFile2 :imageFile3];
            }
        }
        else{
            NSLog(@"%@",error.description);
        }
    } progressBlock:^(int percentDone) {
        NSLog(@"%i",percentDone);
    }];
    

    [imageFile2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            if (!imageFile.dirty & !imageFile2.dirty & !imageFile3.dirty) {
                [self saveObjWith2:imageFile :imageFile2 :imageFile3];
            }
        }
        else{
            NSLog(@"%@",error.description);
        }
    }];
    
    [imageFile3 saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            if (!imageFile.dirty & !imageFile2.dirty & !imageFile3.dirty) {
                [self saveObjWith2:imageFile :imageFile2 :imageFile3];
            }
        }
        else{
            NSLog(@"%@",error.description);
        }
    }];
}
-(void)saveObjWith2:(PFFile*)obj1 :(PFFile*)obj2 :(PFFile*)obj3{
    FImages *imageObj = [FImages object];
    imageObj.original = obj1;
    FImages *imageObj2 = [FImages object];
    imageObj2.original = obj2;
    FImages *imageObj3 = [FImages object];
    imageObj3.original = obj3;
    
    if (obj1 == nil || obj2 == nil || obj3 == nil) {
        
    }
    
    [imageObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            if (!imageObj.dirty & !imageObj2.dirty & !imageObj3.dirty ) {
                [self saveObjWith:imageObj :imageObj2 :imageObj3];
            }
        }
        else{
            NSLog(@"%@",error.description);
        }
    }];
    
    
    
    [imageObj2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            if (!imageObj.dirty & !imageObj2.dirty & !imageObj3.dirty ) {
                [self saveObjWith:imageObj :imageObj2 :imageObj3];
            }
        }
        else{
            NSLog(@"%@",error.description);
        }
    }];
    
    [imageObj3 saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            if (!imageObj.dirty & !imageObj2.dirty & !imageObj3.dirty ) {
                [self saveObjWith:imageObj :imageObj2 :imageObj3];
            }
        }
        else{
            NSLog(@"%@",error.description);
        }
    }];

}

-(void)saveObjWith:(FImages*)obj1 :(FImages*)obj2 :(FImages*)obj3{
    
    float lat = [self randomFloatBetween:8 and:12];
    float lon = [self randomFloatBetween:74 and:77];
    
    NSArray *imageArray = [NSArray arrayWithObjects:obj1,obj2,obj3, nil];
    
    FItem *spotObj = [FItem object];
    spotObj.itemImageArray = imageArray;
    spotObj.itemTitle = @"Sample Title";
    spotObj.itemDescription = @"The Parse platform provides a complete backend solution for your mobile application. Our goal is to totally eliminate the need for writing server code or maintaining servers.";
    
    FRestaurants *restaurent = [FRestaurants object];
    restaurent.name = @"Balaji's Restaurent and Cafe";
    restaurent.location = [PFGeoPoint geoPointWithLatitude:lat longitude:lon];
    
    spotObj.restaurent = restaurent;
    
    spotObj.itemRating = [NSNumber numberWithInt:(int)[self randomFloatBetween:0 and:5]];
    spotObj.itemPrice = [NSNumber numberWithInt:(int)[self randomFloatBetween:100 and:500]];
    spotObj.itemAddress = @"Blah Blah";
    [spotObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            suss++;
            self.sus.text = [NSString stringWithFormat:@"%i",suss];
            NSDate *dateTwo = [NSDate date];
            NSTimeInterval distanceBetweenDates = [dateTwo timeIntervalSinceDate:dateOne];
            NSNumber *num = [NSNumber numberWithInteger:distanceBetweenDates];
            [restArray addObject:num];
            NSLog(@"avgTime = %@", [restArray valueForKeyPath:@"@avg.floatValue"]);
            [self refresh];
        }
        else{
            fai++;
            self.fail.text = [NSString stringWithFormat:@"%i",fai];
            [self refresh];
        }
        
    }];
}

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

@end
