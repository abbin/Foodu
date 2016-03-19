//
//  FLocationObject.h
//  Foodu
//
//  Created by Abbin on 19/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface FLocationObject : NSMutableDictionary

-(instancetype)initWithGMSPlace:(GMSPlace*)place;

-(NSString*)address;
-(NSString*)placeID;
-(PFGeoPoint*)coordinates;

@end
