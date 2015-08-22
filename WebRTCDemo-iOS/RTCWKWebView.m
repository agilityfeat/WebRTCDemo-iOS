//
//  WappoGLViewController.m
//  Wappo
//
//  Created by Jean Lescure on 7/25/15.
//

#import "RTCWKWebView.h"
#import "MyWebRTCPhone.h"

@interface RTCWKWebView ()

@end

@implementation RTCWKWebView

- (RTCWKWebView *)initWithFrame:(CGRect)frameRect {
    MyWebRTCPhone *phone = [[MyWebRTCPhone alloc] init];
    
    NSString *path = [NSString stringWithFormat:@"%@.%@", @"com.example.webrtc", @"index.html"];
    NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:path]];
    
    NSData *data = [phone.moduleString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    [data writeToURL:url options:NSDataWritingAtomic error:&error];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    WKWebViewConfiguration *rtcWebViewConfig = [[WKWebViewConfiguration alloc] init];
    [rtcWebViewConfig.userContentController addScriptMessageHandler:self name:@"interOp"];
    
    self = [self initWithFrame:CGRectMake(0.0f, 0.0f, frameRect.size.width, frameRect.size.height) configuration:rtcWebViewConfig];
    self.navigationDelegate = self;
    
    [self loadRequest:request];
    self.hidden = NO;
    
    return self;
}

- (void)processData:(RTCMediaController *)rmc{
    NSDictionary *frameDict = [rmc getLastFrame];
    //NSLog(@"%@",[[frameDict valueForKey:@"data"] valueForKey:@"description"]);
    [self evaluateJavaScript:[NSString stringWithFormat:@"vid('%@');",[self base64forData:[frameDict valueForKey:@"data"]]] completionHandler:^(NSString *result, NSError *error) {
        NSLog([error debugDescription]);
    }];
}

- (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];

    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;

    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;

            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }

        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }

    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"Finished Loading");
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSDictionary *sentData = (NSDictionary*)message.body;
    
    if ([sentData[@"action"]  isEqual: @"log"]) {
        NSLog(@"Log: %@",sentData[@"string"]);
    }
}

@end
