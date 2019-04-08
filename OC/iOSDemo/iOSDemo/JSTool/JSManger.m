//
//  JSManger.m
//  iOSDemo
//
//  Created by genglei on 2019/4/4.
//  Copyright © 2019年 genglei. All rights reserved.
//

#import "JSManger.h"

@interface JSManger()

@property (nonatomic , strong) UIWebView *webView;

@property (nonatomic , strong) WKWebView *wkWebView;

@property (nonatomic , strong) WebViewJavascriptBridge *bridge;

@property (nonatomic , copy) GLJSHandler glHandler;

@end

@implementation JSManger

- (WebViewJavascriptBridge *)registerJSTool:(UIWebView *)webView hannle:(GLJSHandler)jsHandle {
    if (webView) {
        self.webView = webView;
    }
    if (jsHandle) {
        self.glHandler = jsHandle;
    }
    [self initJavaScriptObservers];
    return self.bridge;
}
- (WebViewJavascriptBridge *)WK_RegisterJSTool:(WKWebView *)webView hannle:(GLJSHandler)jsHandle {
    if (webView) {
        self.wkWebView = webView;
    }
    if (jsHandle) {
        self.glHandler = jsHandle;
    }
    [self initJavaScriptObservers];
    return self.bridge;
}

- (void)initJavaScriptObservers {
    if (self.webView) {
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    } else {
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:_wkWebView];
    }
    __weak JSManger *weakSelf = self;
    
    [self.bridge registerHandler:@"getToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *parameter = [weakSelf getJSONMessage:@{@"id":@"getToken", @"val":@"1234567"}];
        [weakSelf.bridge callHandler:@"jsCallBack" data:parameter responseCallback:^(id responseData) {
        }];
    }];
    [self.bridge registerHandler:@"info" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        NSString *sysVersion = [UIDevice currentDevice].systemVersion;
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSDictionary *infoDic = @{
                                  @"platform":@"1",
                                  @"visit":@(1),
                                  @"version":version,
                                  @"resource":@"iOS",
                                  @"sysVersion":sysVersion,
                                  @"uuid":idfv,
                                  @"User-Agent": [NSString stringWithFormat:@"You App Name/%@", version],
                                  };
        NSString *jsonInfo = [weakSelf getJSONMessage:infoDic];
        NSString *jsonParameter = [weakSelf getJSONMessage:@{@"id":@"info", @"val":jsonInfo}];
        [weakSelf.bridge callHandler:@"jsCallBack" data:jsonParameter responseCallback:^(id responseData) {
        }];
    }];
    [self.bridge registerHandler:@"openH5" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        JSModel *model =  [JSModel yy_modelWithDictionary:@{
                                                            @"methdName":@"openH5:",
                                                            @"parameterData":dic}];
        weakSelf.glHandler(model, ^(id responseData) {
            
        });
    }];
    [self.bridge registerHandler:@"UMAnalytics" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
//        [MobClick event:PARAM_IS_NIL_ERROR(dic[@"eventID"]) label:PARAM_IS_NIL_ERROR(dic[@"label"])];  UM统计
    }];
    [self.bridge registerHandler:@"txtCopy" handler:^(id data, WVJBResponseCallback responseCallback) {
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = data;
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }];
    
    
    [self.bridge registerHandler:@"back" handler:^(id data, WVJBResponseCallback responseCallback) {
        JSModel *model =  [JSModel yy_modelWithDictionary:@{
                                                                @"methdName":@"back:",
                                                                @"parameterData":data}];
        weakSelf.glHandler(model, ^(id responseData) {
            NSString *jsonUrlPath = [weakSelf getJSONMessage:@{@"imagePath":responseData}];
            NSString *jsonParameter = [weakSelf getJSONMessage:@{@"id":@"back", @"val":jsonUrlPath}];
            [weakSelf.bridge callHandler:@"jsCallBack" data:jsonParameter responseCallback:^(id responseData) {
            }];
        });
    }];
    
    [self.bridge registerHandler:@"dialog" handler:^(id data, WVJBResponseCallback responseCallback) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:data preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSString *jsonParameter = [weakSelf getJSONMessage:@{@"id":@"dialogCancel", @"val":@""}];
            [weakSelf.bridge callHandler:@"jsCallBack" data:jsonParameter responseCallback:^(id responseData) {
            }];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *jsonParameter = [weakSelf getJSONMessage:@{@"id":@"dialogSuccess", @"val":@""}];
            [weakSelf.bridge callHandler:@"jsCallBack" data:jsonParameter responseCallback:^(id responseData) {
            }];
        }];
        [alertControl addAction:cancleAction];
        [alertControl addAction:okAction];
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [root presentViewController:alertControl animated:true completion:nil];
    }];
    
    [self.bridge registerHandler:@"toast" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (data == nil) {
            return ;
        }
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        [SVProgressHUD showInfoWithStatus:dic[@"text"]];
        [SVProgressHUD dismissWithDelay:[dic[@"time"] integerValue] / 1000];
    }];
    
    [self.bridge registerHandler:@"getResource" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LOGO" ofType:@"png"];
        if (path) {
            NSURL *urlPath = [NSURL fileURLWithPath:path];
            NSString *jsonUrlPath = [weakSelf getJSONMessage:@{@"imagePath":urlPath.absoluteString}];
            NSString *jsonParameter = [weakSelf getJSONMessage:@{@"id":@"getResource", @"val":jsonUrlPath}];
            [weakSelf.bridge callHandler:@"jsCallBack" data:jsonParameter responseCallback:^(id responseData) {
            }];
        }
      
    }];
   
    [self.bridge registerHandler:@"share" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (data) {
            NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            /*
             NSString *title = dic[@"title"];
             NSString *picurl = dic[@"picurl"];
             NSString *des = dic[@"des"];
             NSString *linkurl = dic[@"linkurl"];
             
             NSString *type = PARAM_IS_NIL_ERROR(dic[@"type"]);
             if (!(type.length > 0)) {
             type = @"link";
             }
             [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
             switch (platformType) {
             case UMSocialPlatformType_Sina: {
             if (![[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_Sina]) {
             [SVProgressHUD showErrorWithStatus:@"未安装新浪客户端"];
             return ;
             }
             }
             break;
             case UMSocialPlatformType_WechatSession: {
             if (![[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatSession]) {
             [SVProgressHUD showErrorWithStatus:@"未安装微信客户端"];
             return ;
             }
             }
             break;
             case UMSocialPlatformType_WechatTimeLine: {
             if (![[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatTimeLine]) {
             [SVProgressHUD showErrorWithStatus:@"未安装微信客户端"];
             return ;
             }
             }
             break;
             case UMSocialPlatformType_QQ: {
             if (![[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_QQ]) {
             [SVProgressHUD showErrorWithStatus:@"未安装QQ客户端"];
             return ;
             }
             }
             break;
             case UMSocialPlatformType_Qzone: {
             if (![[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_Qzone]) {
             [SVProgressHUD showErrorWithStatus:@"未安装QQ客户端"];
             return ;
             }
             }
             break;
             default:
             break;
             }
             UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
             if ([type isEqualToString:@"link"]) {
             UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:des thumImage:picurl];
             shareObject.webpageUrl = linkurl;
             messageObject.shareObject = shareObject;
             } else if ([type isEqualToString:@"pic"]) {
             UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
             shareObject.thumbImage = [UIImage imageNamed:@"icon"];
             [shareObject setShareImage:picurl];
             messageObject.shareObject = shareObject;
             } else if ([type isEqualToString:@"richText"]) {
             messageObject.text = title;
             UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
             shareObject.thumbImage = [UIImage imageNamed:@"icon"];
             [shareObject setShareImage:picurl];
             messageObject.shareObject = shareObject;
             }
             [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[ZBMethods help_getCurrentVC] completion:^(id data, NSError *error) {
             if (error) {
             NSString *jsonParameter = [self getJSONMessage:@{@"id":@"shareFailed", @"val":@(platformType)}];
             [self.bridge callHandler:@"jsCallBack" data:jsonParameter responseCallback:^(id responseData) {
             }];
             }else{
             NSString *jsonParameter = [self getJSONMessage:@{@"id":@"shareSuccess", @"val":@(platformType)}];
             [self.bridge callHandler:@"jsCallBack" data:jsonParameter responseCallback:^(id responseData) {
             }];
             }
             }];
             }];
             */
        }
    }];
    [self.bridge registerHandler:@"toLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        JSModel *model =  [JSModel yy_modelWithDictionary:@{
                                                                @"methdName":@"toLogin:",
                                                                @"parameterData":@{@"type":@"123"}}];
        weakSelf.glHandler(model, ^(id responseData) {
            
        });
    }];
   
    [self.bridge registerHandler:@"openNative" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        JSModel *model =  [JSModel yy_modelWithDictionary:@{
                                                                @"methdName":@"openNative:",
                                                                @"parameterData":dic}];
        weakSelf.glHandler(model, ^(id responseData) {
        });
    }];
    
    [self.bridge registerHandler:@"nav" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        JSModel *model =  [JSModel yy_modelWithDictionary:@{
                                                                @"methdName":@"nav:",
                                                                @"parameterData":dic}];
        weakSelf.glHandler(model, ^(id responseData) {
        });
    }];
    
    [self.bridge registerHandler:@"closeWin" handler:^(id data, WVJBResponseCallback responseCallback) {
        JSModel *model =  [JSModel yy_modelWithDictionary:@{
                                                                @"methdName":@"closeWin:",
                                                                @"parameterData":@{@"type":@"123"}}];
        weakSelf.glHandler(model, ^(id responseData) {
        });
    }];
    
    [self.bridge registerHandler:@"openBrowser" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (data) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data]];
        } else {
            [SVProgressHUD showErrorWithStatus:@"地址错误"];
        }
    }];
    
    [self.bridge registerHandler:@"webStorage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if ([dic isKindOfClass:NSClassFromString(@"NSDictionary")]) {
            [[NSUserDefaults standardUserDefaults]setObject:dic[@"storageValue"] forKey:dic[@"storageKey"]];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [SVProgressHUD showInfoWithStatus:@"存储成功"];
        }
    }];
    
    [self.bridge registerHandler:@"getStorage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *jsonData = [[NSUserDefaults standardUserDefaults]objectForKey:data];
        NSString *jsonParameter = [self getJSONMessage:@{@"id":@"getStorageData", @"val":jsonData}];
        [weakSelf.bridge callHandler:@"jsCallBack" data:jsonParameter responseCallback:^(id responseData) {
            
        }];
    }];
    
    [self.bridge registerHandler:@"removeStorage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:data];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [SVProgressHUD showInfoWithStatus:@"删除成功"];
    }];
    
}
- (NSString *)getJSONMessage:(NSDictionary *)messageDic {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

@end
