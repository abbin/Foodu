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
    NSArray *restArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    suss = 0;
    fai = 0;
   [self refresh:0];
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
    
    FRestaurants *restaurent = [FRestaurants object];
    restaurent.name = @"Balaji's Restaurent and Cafe";
    restaurent.location = [PFGeoPoint geoPointWithLatitude:lat longitude:lon];
    
    spotObj.restaurent = restaurent;
    
    spotObj.itemRating = [NSNumber numberWithInt:(int)[self randomFloatBetween:0 and:5]];
    spotObj.itemPrice = [NSNumber numberWithInt:(int)[self randomFloatBetween:100 and:500]];
    
    NSMutableArray *imageArray2X = [[NSMutableArray alloc]init];
    NSMutableArray *imageArray3X = [[NSMutableArray alloc]init];
    
    int num = [self randomFloatBetween:1 and:5];
    for (int k = 0; k<num; k++) {
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg",(int)[self randomFloatBetween:1 and:55]];
        
        UIImage *img = [self imageWithImage:[UIImage imageNamed:imageName] scaledToWidth:435];
        
        NSData *imageData = UIImageJPEGRepresentation(img, 0.0);
        
        UIImage *img2 = [self imageWithImage:[UIImage imageNamed:imageName] scaledToWidth:435*2];
        
        NSData *imageData2 = UIImageJPEGRepresentation(img2, 0.0);
        
        NSLog(@"File size 2X : %.2f MB",(float)imageData.length/1024.0f/1024.0f);
        NSLog(@"File size 3X : %.2f MB",(float)imageData2.length/1024.0f/1024.0f);
        
        size = size + imageData.length/1024.0f/1024.0f;
        if (imageData==nil) {
            [self refresh:i];
        }
        else{
            PFFile *imageFile = [PFFile fileWithData:imageData];
            [imageArray2X addObject:imageFile];
            PFFile *imageFile2 = [PFFile fileWithData:imageData2];
            [imageArray3X addObject:imageFile2];
        }
    }
    
    FImages * image = [FImages object];
    image.iOS2X = imageArray2X;
    image.iOS3X = imageArray3X;
    spotObj.thumbNail2x = [imageArray2X objectAtIndex:0];
    spotObj.thumbNail3x = [imageArray3X objectAtIndex:0];
    spotObj.itemImage = image;
    
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:restaurent.location.latitude longitude:restaurent.location.longitude]; //insert your coordinates
    
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  
                  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                  spotObj.itemAddress = locatedAt;
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
     ];
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
