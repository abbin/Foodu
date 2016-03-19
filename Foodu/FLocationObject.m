//
//  FLocationObject.m
//  Foodu
//
//  Created by Abbin on 19/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FLocationObject.h"

@implementation FLocationObject

-(instancetype)initWithGMSPlace:(GMSPlace *)place{
    self = [super init];
    if (self != nil){
        [self setObject:place.placeID forKey:@"placeIDKey"];
        if (place.formattedAddress) {
            [self setObject:place.formattedAddress forKey:@"addressKey"];
        }
        else{
            [self setObject:@"" forKey:@"addressKey"];
        }
        [self setObject:[PFGeoPoint geoPointWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude] forKey:@"coordinatesKey"];
    }
    return self;
}

-(NSString *)address{
    return [self objectForKey:@"addressKey"];
}

-(NSString *)placeID{
    return [self objectForKey:@"placeIDKey"];
}

-(PFGeoPoint *)coordinates{
    return [self objectForKey:@"coordinatesKey"];
}

@end
