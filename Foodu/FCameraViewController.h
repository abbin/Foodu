//
//  FCameraViewController.h
//  Foodu
//
//  Created by Abbin on 27/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    CameraFlashOn,
    CameraFlashOff
} CameraFlash;

@class FCameraViewController;

@protocol FCameraDelegate <NSObject>

- (void)cameraViewController:(FCameraViewController*)cameraVC didCaptureImage:(UIImage *)image;

@end

@interface FCameraViewController : UIViewController

@end
