//
//  RTCMediaController.m
//  WebRTCDemo-iOS
//
//  Created by Jean Lescure on 8/20/15.
//  Copyright (c) 2015 Jean Lescure. All rights reserved.
//

#import "RTCMediaController.h"

@interface RTCMediaController ()

@end

@implementation RTCMediaController

NSData * m_cameraWriteBuffer;   // Pixels, captured from the camera, are copied here
NSData * m_middleManBuffer;     // Pixels will be read from here
NSData * m_consumerReadBuffer;  // Pixels are copied from this buffer into the ActionScript buffer
AVCaptureVideoDataOutput * m_videoOutput;
int m_frameWidth;
int m_frameHeight;

- (void)startWithSession:(AVCaptureSession *)session forDelegate:(id)delegate {
    NSLog(@"Setting up video output");
    m_videoOutput = [[AVCaptureVideoDataOutput alloc] init];
 
    m_videoOutput.alwaysDiscardsLateVideoFrames = YES;
 
    NSNumber * framePixelFormat = [NSNumber numberWithInt: kCVPixelFormatType_32BGRA];
    m_videoOutput.videoSettings = [NSDictionary dictionaryWithObject:framePixelFormat forKey:(id)kCVPixelBufferPixelFormatTypeKey];

    NSLog(@"Setting up capture session");
    [session beginConfiguration];
    
    NSLog(@"Adding video input");
    AVCaptureDevice *VideoDevice = [self CameraWithPosition:AVCaptureDevicePositionFront];
    [VideoDevice lockForConfiguration:nil];
    VideoDevice.activeVideoMinFrameDuration = CMTimeMake(1, 2);
    VideoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, 2);
    [VideoDevice unlockForConfiguration];
    if (VideoDevice) {
        NSError *error;
        AVCaptureDeviceInput *VideoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:VideoDevice error:&error];
        if (!error) {
            if ([session canAddInput:VideoInputDevice]) {
                [session addInput:VideoInputDevice];
            }else{
                NSLog(@"Couldn't add video input");
            }
        }else{
            NSLog(@"Couldn't create video input");
        }
    }else{
        NSLog(@"Couldn't create video capture device");
    }
    
    NSLog(@"Setting image quality");
    [session setSessionPreset:AVCaptureSessionPresetMedium];
    if ([session canSetSessionPreset:AVCaptureSessionPreset640x480])		//Check size based configs are supported before setting them
      [session setSessionPreset:AVCaptureSessionPreset640x480];
      
    NSLog(@"Adding video output");
    [m_videoOutput setSampleBufferDelegate:delegate queue:dispatch_get_main_queue()];
    if ([session canAddOutput:m_videoOutput]) {
        [session addOutput:m_videoOutput];
    }else{
        NSLog(@"Couldn't add video output");
    }
    
    [session commitConfiguration];
    
    m_frameWidth = 0;
    m_frameHeight = 0;
  
    [session startRunning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    //NSLog(@"capture");
    if ( captureOutput == m_videoOutput )
    {
        [self copyVideoFrame: sampleBuffer];
    }
}

- ( void ) copyVideoFrame: ( CMSampleBufferRef ) sampleBuffer
{
  CVPixelBufferRef pixelBuffer = (CVPixelBufferRef) CMSampleBufferGetImageBuffer(sampleBuffer);
  
  CVOptionFlags lockFlags = 0; // If you are curious, look up the definition of CVOptionFlags
  CVReturn status = CVPixelBufferLockBaseAddress( pixelBuffer, lockFlags );
  assert( kCVReturnSuccess == status );
  
  size_t bytesPerRow = CVPixelBufferGetBytesPerRow( pixelBuffer );
  size_t height = CVPixelBufferGetHeight( pixelBuffer );
  NSUInteger numBytesToCopy = bytesPerRow * height;

  void * startByte = CVPixelBufferGetBaseAddress( pixelBuffer );
  
    m_cameraWriteBuffer = [ NSData dataWithBytes: startByte length: numBytesToCopy ];
  
    @synchronized(self)
    {
        m_middleManBuffer = m_cameraWriteBuffer;
        m_cameraWriteBuffer = NULL;

        m_frameWidth = CVPixelBufferGetWidth( pixelBuffer );
        m_frameHeight = height;
        [_mediaDelegate processData:self];
      
        CVOptionFlags unlockFlags = 0; // If you are curious, look up the definition of CVOptionFlags
        CVPixelBufferUnlockBaseAddress( pixelBuffer, unlockFlags );
    }
}

- (NSDictionary *)getLastFrame {
    NSDictionary *retDict;
    @synchronized(self){
        m_consumerReadBuffer = m_middleManBuffer;
        m_middleManBuffer = NULL;

        retDict = @{
                    @"data": m_consumerReadBuffer,
                    @"width": [NSNumber numberWithInt: m_frameWidth],
                    @"height": [NSNumber numberWithInt: m_frameHeight]
                    };
    }

    return retDict;
}

- (AVCaptureDevice *)CameraWithPosition:(AVCaptureDevicePosition)Position {
	NSArray *Devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *Device in Devices) {
		if ([Device position] == Position) {
			return Device;
		}
	}
	return nil;
}

@end
