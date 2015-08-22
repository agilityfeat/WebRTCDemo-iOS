//
//  RTCMediaController.h
//  WebRTCDemo-iOS
//
//  Created by Jean Lescure on 8/20/15.
//  Copyright (c) 2015 Jean Lescure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <QuartzCore/QuartzCore.h>

@interface RTCMediaController : NSObject

@property (nonatomic, assign) id  mediaDelegate;

- (void)startWithSession:(AVCaptureSession *)session forDelegate:(id)delegate;
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;
- (NSDictionary *)getLastFrame;
@end

@class RTCMedia;

@protocol RTCMediaDelegate

- (void) processData:(RTCMediaController *)rmc;

@end