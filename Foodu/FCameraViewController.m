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
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIImageView *imageOne;
@property (strong, nonatomic) UIImageView *imageTwo;
@property (strong, nonatomic) UIImageView *imageThree;

@property (strong, nonatomic) NSMutableArray *selectedImagesArray;

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
    self.selectedImagesArray = [NSMutableArray new];
    self.fixOrientationAfterCapture = YES;
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    self.preview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    self.preview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.preview];
    
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.snapButton addTarget:self
                        action:@selector(snapButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.snapButton setBackgroundColor:[UIColor lightGrayColor]];
    
    self.snapButton.frame = CGRectMake(0, 0, screenRect.size.width/5, screenRect.size.width/5);
    self.snapButton.center = CGPointMake(screenRect.size.width/2, screenRect.size.height-screenRect.size.width/5/2-10);
    [self.view addSubview:self.snapButton];
    
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashButton.frame = CGRectMake(0, 0, screenRect.size.width/15, screenRect.size.width/15);
    self.flashButton.center = CGPointMake(self.snapButton.center.x+self.snapButton.frame.size.width/2+screenRect.size.width/15/2+20, self.snapButton.center.y);
    [self.flashButton setBackgroundColor:[UIColor redColor]];
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(0, 0, screenRect.size.width/10, screenRect.size.width/10);
    self.cancelButton.center = CGPointMake(screenRect.size.width-screenRect.size.width/15, self.preview.frame.size.height+screenRect.size.width/10/2+5);
    self.cancelButton.backgroundColor = [UIColor lightGrayColor];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    NSLog(@"%f",self.view.frame.size.height);
    NSLog(@"%f",self.preview.frame.size.height);
    
    int whiteHeight = self.view.frame.size.height-self.preview.frame.size.height;
    int imgHight = (whiteHeight/3)-17;
    
    self.imageOne = [[UIImageView alloc]initWithFrame:CGRectMake(5, self.preview.frame.size.height + 5, imgHight, imgHight)];
    self.imageOne.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageOne];
    
    self.imageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(5, self.preview.frame.size.height + 10+imgHight, imgHight, imgHight)];
    self.imageTwo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageTwo];
    
    self.imageThree = [[UIImageView alloc]initWithFrame:CGRectMake(5, self.preview.frame.size.height + 15+imgHight+imgHight, imgHight, imgHight)];
    self.imageThree.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageThree];
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

- (void)cancelButtonPressed:(UIButton *)button {
    
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
    if (self.selectedImagesArray.count<=3) {
        AVCaptureConnection *videoConnection = [self captureConnection];
        self.preview.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.preview.alpha = 1;
        }];
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
             [self.selectedImagesArray addObject:image];
             [self addImages];
         }];
    }
}

-(void)addImages{
    if (self.selectedImagesArray.count == 1) {
        self.imageOne.image = [self.selectedImagesArray objectAtIndex:0];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        
        [self.imageOne.layer addAnimation:transition forKey:nil];
    }
    else if (self.selectedImagesArray.count == 2){
        self.imageTwo.image = [self.selectedImagesArray objectAtIndex:1];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        
        [self.imageTwo.layer addAnimation:transition forKey:nil];
    }
    else if (self.selectedImagesArray.count == 3){
        self.imageThree.image = [self.selectedImagesArray objectAtIndex:2];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        
        [self.imageThree.layer addAnimation:transition forKey:nil];
    }
    
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
