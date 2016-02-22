//
//  FKinveyTestObj.h
//  Foodu
//
//  Created by Abbin on 22/02/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKinveyTestObj : NSObject<KCSPersistable>

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* kinveyId;
@property (nonatomic, retain) NSDate* userDate;
@property (nonatomic, retain) KCSFile* attachment;
@property (nonatomic, retain) KCSMetadata* meta;
@property (nonatomic, retain) CLLocation* location;

@end
