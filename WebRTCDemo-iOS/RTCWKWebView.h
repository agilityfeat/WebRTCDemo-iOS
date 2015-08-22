//
//  WappoGLViewController.h
//  Wappo
//
//  Created by Jean Lescure on 7/25/15.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "RTCMediaController.h"

@interface RTCWKWebView : WKWebView <WKScriptMessageHandler, WKNavigationDelegate, RTCMediaDelegate>

@end
