//
//  NSMutableDictionary+FLocation.m
//  Foodu
//
//  Created by Abbin Varghese on 20/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "NSMutableDictionary+FLocation.h"

@implementation NSMutableDictionary (FLocation)

-(instancetype)initWithGMSPlace:(GMSPlace *)place{
    self = [self init];
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
