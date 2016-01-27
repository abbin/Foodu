//
//  FCameraViewController.m
//  Foodu
//
//  Created by Abbin on 27/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FCameraViewController.h"
#import <ImageIO/CGImageProperties.h>
#import "UIImage+FixOrientation.h"

@interface FCameraViewController ()

@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *flashButton;

@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic) BOOL fixOrientationAfterCapture;
@property (nonatomic) CameraFlash cameraFlash;
@property (nonatomic,strong) UIView *preview;
@end

@implementation FCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fixOrientationAfterCapture = YES;
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    
    self.preview = [[UIView alloc] initWithFrame:screenRect];
    self.preview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.preview];
    
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.snapButton addTarget:self
                        action:@selector(snapButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.snapButton setImage:[UIImage imageNamed:@"button_record-512.png"] forState:UIControlStateNormal];
    [self.snapButton setImage:[UIImage imageNamed:@"geoListSelected"] forState:UIControlStateHighlighted];
    self.snapButton.frame = CGRectMake(0, 0, screenRect.size.width/4, screenRect.size.width/4);
    self.snapButton.center = CGPointMake(screenRect.size.width/2, screenRect.size.height-screenRect.size.width/4/2-20);
    [self.view addSubview:self.snapButton];
    
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashButton.frame = CGRectMake(screenRect.size.width-screenRect.size.width/15-20, 20, screenRect.size.width/15, screenRect.size.width/15);
    [self.flashButton setImage:[UIImage imageNamed:@"flashOff"] forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"flashOn"] forState:UIControlStateSelected];
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)snapButtonPressed:(UIButton *)button {
    [self capture];
}

- (void)flashButtonPressed:(UIButton *)button {
    [self toggleFlash];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)start {
    
    if(!_session) {
        
        self.session = [[AVCaptureSession alloc] init];
        
        NSString *sessionPreset = AVCaptureSessionPresetPhoto;
        
        self.session.sessionPreset = sessionPreset;
        
        CALayer *viewLayer = self.preview.layer;
        
        AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        // set size
        CGRect bounds=viewLayer.bounds;
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        captureVideoPreviewLayer.bounds=bounds;
        captureVideoPreviewLayer.position=CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
        [self.preview.layer addSublayer:captureVideoPreviewLayer];
        
        self.captureVideoPreviewLayer = captureVideoPreviewLayer;
        
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
        
        if (!input) {
            // Handle the error appropriately.
            NSLog(@"ERROR: trying to open camera: %@", error);
            return;
        }
        [self.session addInput:input];
        
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [self.stillImageOutput setOutputSettings:outputSettings];
        [self.session addOutput:self.stillImageOutput];
    }
    
    [self.session startRunning];
    [self setCameraFlash:CameraFlashOff];
}

- (void)stop {
    [self.session stopRunning];
}

- (AVCaptureConnection *)captureConnection {
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    return videoConnection;
}

-(void)capture {
    
    AVCaptureConnection *videoConnection = [self captureConnection];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
             //NSLog(@"attachements: %@", exifAttachments);
         } else {
             //NSLog(@"no attachments");
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         if(self.fixOrientationAfterCapture) {
             image = [image fixOrientation];
         }
         
//         if(self.delegate) {
//             if ([self.delegate respondsToSelector:@selector(cameraViewController:didCaptureImage:)]) {
//                 [self.delegate cameraViewController:self didCaptureImage:image];
//             }
//         }
     }];
}

- (BOOL)isFlashAvailable {
    AVCaptureInput* currentCameraInput = [self.session.inputs objectAtIndex:0];
    AVCaptureDeviceInput *deviceInput = (AVCaptureDeviceInput *)currentCameraInput;
    
    return deviceInput.device.isTorchAvailable;
}

-(void)setCameraFlash:(CameraFlash)cameraFlash {
    
    AVCaptureInput* currentCameraInput = [self.session.inputs objectAtIndex:0];
    AVCaptureDeviceInput *deviceInput = (AVCaptureDeviceInput *)currentCameraInput;
    
    if(!deviceInput.device.isTorchAvailable) {
        return;
    }
    
    _cameraFlash = cameraFlash;
    
    [self.session beginConfiguration];
    [deviceInput.device lockForConfiguration:nil];
    
    if(_cameraFlash == CameraFlashOn) {
        deviceInput.device.torchMode = AVCaptureTorchModeOn;
    }
    else {
        deviceInput.device.torchMode = AVCaptureTorchModeOff;
    }
    
    [deviceInput.device unlockForConfiguration];
    
    //Commit all the configuration changes at once
    [self.session commitConfiguration];
}

- (CameraFlash)toggleFlash {
    if(self.cameraFlash == CameraFlashOn) {
        self.cameraFlash = CameraFlashOff;
    }
    else {
        self.cameraFlash = CameraFlashOn;
    }
    
    return self.cameraFlash;
}


@end
