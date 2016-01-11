//
//  ViewController.m
//  Foodu
//
//  Created by Abbin on 04/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "ViewController.h"
#import <malloc/malloc.h>

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    restArray = [[NSMutableArray alloc]init];
    avgArray = [[NSMutableArray alloc]init];
    suss = 0;
    fai = 0;
   [self refresh:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)refresh:(int)i{
      NSLog(@"***********");
    i++;
    __block float size = 0;
    NSDate *dateOne = [NSDate date];
    float lat = [self randomFloatBetween:8 and:12];
    float lon = [self randomFloatBetween:74 and:77];
    
    __block NSString *imageName = [NSString stringWithFormat:@"%d.jpg",(int)[self randomFloatBetween:1 and:55]];
    __block UIImage *img = [UIImage imageNamed:imageName];
    __block NSData *imageData = UIImageJPEGRepresentation(img, 0.0);
    size = size+(float)imageData.length/1024.0f/1024.0f;
    PFFile *imageFile = [PFFile fileWithData:imageData];
    FImages *imageObj = [FImages object];
    imageObj.original = imageFile;
//    [imageObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
            imageName = [NSString stringWithFormat:@"%d.jpg",(int)[self randomFloatBetween:1 and:55]];
            img = [UIImage imageNamed:imageName];
            imageData = UIImageJPEGRepresentation(img, 0.0);
            size = size+(float)imageData.length/1024.0f/1024.0f;
            PFFile *imageFile2 = [PFFile fileWithData:imageData];
            FImages *imageObj2 = [FImages object];
            imageObj2.original = imageFile2;
//            [imageObj2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                if (succeeded) {
                    imageName = [NSString stringWithFormat:@"%d.jpg",(int)[self randomFloatBetween:1 and:55]];
                    img = [UIImage imageNamed:imageName];
                    imageData = UIImageJPEGRepresentation(img, 0.0);
                    size = size+(float)imageData.length/1024.0f/1024.0f;
                    PFFile *imageFile3 = [PFFile fileWithData:imageData];
                    FImages *imageObj3 = [FImages object];
                    imageObj3.original = imageFile3;
//                    [imageObj3 saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                        if (succeeded) {
                            NSArray *imageArray = [NSArray arrayWithObjects:imageObj,imageObj2,imageObj3, nil];
                            
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
                            
//                            CLGeocoder *ceo = [[CLGeocoder alloc]init];
//                            CLLocation *loc = [[CLLocation alloc]initWithLatitude:restaurent.location.latitude longitude:restaurent.location.longitude]; //insert your coordinates
//                            [ceo reverseGeocodeLocation:loc
//                                      completionHandler:^(NSArray *placemarks, NSError *error) {
//                                          if (error) {
//                                              fai++;
//                                              self.fail.text = [NSString stringWithFormat:@"%i",fai];
//                                              [self refresh:i];
//                                          }
//                                          else{
//                                              CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                                              
//                                              NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                                              spotObj.itemAddress = @"Blah Blah";
                                              [spotObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                                  if (succeeded) {
                                                      suss++;
                                                      self.sus.text = [NSString stringWithFormat:@"%i",suss];
                                                      NSDate *dateTwo = [NSDate date];
                                                      NSTimeInterval distanceBetweenDates = [dateTwo timeIntervalSinceDate:dateOne];
                                                      NSNumber *num = [NSNumber numberWithInteger:distanceBetweenDates];
                                                      NSNumber *num2 = [NSNumber numberWithFloat:size];
                                                      size = 0;
                                                      [restArray addObject:num];
                                                      [avgArray addObject:num2];
                                                      NSLog(@"avgSIze = %@", [avgArray valueForKeyPath:@"@avg.floatValue"]);
                                                      NSLog(@"avgTime = %@", [restArray valueForKeyPath:@"@avg.floatValue"]);
                                                      [self refresh:i];
                                                  }
                                                  else{
                                                      fai++;
                                                      self.fail.text = [NSString stringWithFormat:@"%i",fai];
                                                      [self refresh:i];
                                                  }
                                                  
                                              }];
//                                          }
//                                      }
//                             ];
//                        }
//                        else{
//                            NSLog(@"%@",error.description);
//                        }
//                    }];

//                }
//                else{
//                    NSLog(@"%@",error.description);
//                }
//            }];
//        }
//        else{
//            NSLog(@"%@",error.description);
//        }
//    }];
    
    
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
