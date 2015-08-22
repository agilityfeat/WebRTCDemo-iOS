//
//  ViewController.h
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
#import "RTCMediaController.h"

@interface ViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>
{
	AVCaptureSession *session;
  RTCMediaController *rtcMediaController;
}

@end

