//
//  NSMutableDictionary+FLocation.h
//  Foodu
//
//  Created by Abbin Varghese on 20/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface NSMutableDictionary (FLocation)

-(instancetype)initWithGMSPlace:(GMSPlace*)place;

-(NSString*)address;
-(NSString*)placeID;
-(PFGeoPoint*)coordinates;

@end
