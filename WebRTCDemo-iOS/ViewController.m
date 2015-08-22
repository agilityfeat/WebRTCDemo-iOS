//
//  ViewController.m
//  WebRTCDemo-iOS
//
//  Created by Jean Lescure on 8/20/15.
//  Copyright (c) 2015 Jean Lescure. All rights reserved.
//

#import "ViewController.h"
#import "RTCWKWebView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    session = [[AVCaptureSession alloc] init];
    rtcMediaController = [[RTCMediaController alloc] init];
    
    RTCWKWebView *rtcWebView = [[RTCWKWebView alloc] initWithFrame:self.view.layer.bounds];
    rtcMediaController.mediaDelegate = rtcWebView;
    
    [self.view addSubview:rtcWebView];
    
    [rtcMediaController startWithSession:session forDelegate:self];
}

- ( void ) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    [rtcMediaController captureOutput:captureOutput didOutputSampleBuffer:sampleBuffer fromConnection:connection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
