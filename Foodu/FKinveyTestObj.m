//
//  FKinveyTestObj.m
//  Foodu
//
//  Created by Abbin on 22/02/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FKinveyTestObj.h"

@implementation FKinveyTestObj

// Kinvey code use: any "KCSPersistable" has to implement this mapping method
- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"text"       : @"text",
             @"userDate"   : @"userDate",
             @"attachment" : @"attachment",
             @"meta"       : KCSEntityKeyMetadata,
             @"kinveyId"   : KCSEntityKeyId,
             @"location"   : KCSEntityKeyGeolocation,
             };
}

+ (NSDictionary *)kinveyPropertyToCollectionMapping
{
    return @{@"attachment":KCSFileStoreCollectionName};
}


@end
