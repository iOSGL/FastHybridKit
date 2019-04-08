//
//  JSManger.h
//  iOSDemo
//
//  Created by genglei on 2019/4/4.
//  Copyright © 2019年 genglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import <YYModel.h>
#import <SVProgressHUD.h>
#import "JSModel.h"
#import "WebModel.h"

typedef void (^GLJSResponseCallback)(id responseData);
typedef void (^GLJSHandler)(id data, GLJSResponseCallback responseCallback);

@interface JSManger : NSObject

- (WebViewJavascriptBridge *)registerJSTool:(UIWebView *)webView hannle:(GLJSHandler)jsHandle;
- (WebViewJavascriptBridge *)WK_RegisterJSTool:(WKWebView *)webView hannle:(GLJSHandler)jsHandle;

@end


