//
//  WebController.m
//  iOSDemo
//
//  Created by genglei on 2019/4/4.
//  Copyright © 2019年 genglei. All rights reserved.
//

#import "WebController.h"
#import "List.h"
#import "GL_ImageVIew.h"
#import <SDWebImage/SDWebImageManager.h>
#import <UIImageView+WebCache.h>

@interface WebController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic , strong) WKWebView *wkWeb;

@property (nonatomic , strong) WebViewJavascriptBridge* bridge;

@property (nonatomic , copy) GLJSResponseCallback callBack;

@property (nonatomic, copy) NSString *html5Url;

@property (nonatomic, copy) NSString *urlPath;

@end

@implementation WebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadBradgeHandler];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:_model.hideNavigationBar animated:true];
}

#pragma mark - Config UI

- (void)configUI {
    self.navigationItem.title = _model.title;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.wkWeb];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"列表" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn addTarget:self action:@selector(listAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - Load Data
- (void)loadBradgeHandler {
    __weak WebController *weakSelf = self;
    JSManger *manger = [[JSManger alloc]init];
    WebViewJavascriptBridge *bridge ;
    bridge = [manger WK_RegisterJSTool:self.wkWeb hannle:^(id data, GLJSResponseCallback responseCallback) {
        if (responseCallback) {
            weakSelf.callBack = responseCallback;
        }
        JSModel *model = (JSModel *)data;
        NSString *actionString = model.methdName;
        SEL action = NSSelectorFromString(actionString);
        if ([weakSelf respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [weakSelf performSelector:action withObject:model.parameterData];
#pragma clang diagnostic pop
        }
    }];
    [bridge setWebViewDelegate:self];
    self.bridge = bridge;
    [self loadData];
}
- (void)loadData {
    if (_model) {
        self.urlPath = _model.webUrl;
        self.html5Url = _model.htmlUrl;
    }
    if (self.urlPath != nil) {
        self.urlPath = [self.urlPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSURL *url = [NSURL URLWithString:self.urlPath];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
        [self.wkWeb loadRequest:request];
        
    } else if (self.html5Url != nil) {
        NSString* path = [[NSBundle mainBundle] pathForResource:self.html5Url ofType:@"html" inDirectory:@"H5"];
        NSURL *indexUrl = [NSURL fileURLWithPath:path];
        NSURLRequest *req = [NSURLRequest requestWithURL:indexUrl];
        [self.wkWeb loadRequest:req];
    }
}

#pragma mark - WKDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
  
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
   
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
   
}

#pragma mark - Js Method  // H5 Call Native

- (void)openH5:(id)data{
    if ([data isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        NSDictionary *dic = (NSDictionary *)data;
        WebModel *model = [[WebModel alloc]init];
        model.title = dic[@"title"];
        model.webUrl =  dic[@"url"];
        model.parameter = dic[@"nav"];
        model.hideNavigationBar = [dic[@"nav_hidden"] integerValue];
        WebController *control = [[WebController alloc]init];
        control.model = model;
        [self.navigationController pushViewController:control animated:true];
    }
}

- (void)openNative:(id)data {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic = (NSDictionary *)data;
        NSString *className = dataDic[@"n"];
        Class targetCalss = NSClassFromString(className);
        id target = [[targetCalss alloc] init];
        if (target == nil) {
            [SVProgressHUD showErrorWithStatus:@"暂时不能打开"];
            return;
        } else {
            unsigned int outCount = 0;
            NSMutableArray *keyArray = [NSMutableArray array];
            objc_property_t *propertys = class_copyPropertyList([targetCalss class], &outCount);
            for (unsigned int i = 0; i < outCount; i ++) {
                objc_property_t property = propertys[i];
                NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
                [keyArray addObject:propertyName];
            }
            free(propertys);
            NSDictionary *parameterDic = dataDic[@"v"];
            if (parameterDic.allKeys.count > 0) {
                NSArray *array = parameterDic.allKeys;
                for (NSInteger i = 0; i < array.count; i++) {
                    NSString *key = array[i];
                    if ([keyArray containsObject:key]) {
                        [target setValue:parameterDic[key] forKey:key];
                    }
                }
            }
            [self.navigationController pushViewController:target animated:YES];
        }
    }
}

- (void)nav:(id)data {
    if ([data isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        NSDictionary *dataDic = (NSDictionary *)data;
        BOOL nav_hidden = [dataDic[@"nav_hidden"] integerValue];
        [self.navigationController setNavigationBarHidden:nav_hidden animated:YES];
        if (!nav_hidden) {
            self.navigationItem.title = dataDic[@"title"];
            NSArray *leftArray = dataDic[@"left"];
            if (leftArray.count > 0) {
                NSMutableArray *leftItemsArray = [NSMutableArray new];
                for (NSInteger i = 0; i < leftArray.count; i ++) {
                    NSDictionary *dic = leftArray[i];
                    [[SDImageCache sharedImageCache]removeImageForKey:dic[@"icon"]];
                    GL_ImageVIew *imageV = [[GL_ImageVIew alloc]init];
                    imageV.frame = CGRectMake(i * 44, 0, 44, 44);
                    [imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]] placeholderImage:[UIImage imageNamed:@"test"]];
                    imageV.userInteractionEnabled = YES;
                    imageV.parameter = dic;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableBarAction:)];
                    [imageV addGestureRecognizer:tap];
                    imageV.clipsToBounds = true;
                    imageV.contentMode = UIViewContentModeScaleAspectFill;
                    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:imageV];
                    [leftItemsArray addObject:item];
                }
                self.navigationItem.leftBarButtonItems = [leftItemsArray copy];
            }
            NSArray *rightArray = dataDic[@"right"];
            if (rightArray.count > 0) {
                NSMutableArray *rightItemsArray = [NSMutableArray new];
                rightArray = [[rightArray reverseObjectEnumerator] allObjects];
                for (NSInteger i = 0; i < rightArray.count; i ++) {
                    NSDictionary *dic = rightArray[i];
                    [[SDImageCache sharedImageCache]removeImageForKey:dic[@"icon"]];
                    GL_ImageVIew *imageV = [[GL_ImageVIew alloc]init];
                    imageV.frame = CGRectMake(i * 44, 0, 44, 44);
                    [imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]] placeholderImage:[UIImage imageNamed:@"test"]];
                    imageV.userInteractionEnabled = YES;
                    imageV.parameter = dic;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableBarAction:)];
                    [imageV addGestureRecognizer:tap];
                    imageV.clipsToBounds = true;
                    imageV.contentMode = UIViewContentModeScaleAspectFill;
                    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:imageV];
                    [rightItemsArray addObject:item];
                }
                self.navigationItem.rightBarButtonItems = rightItemsArray;
            }
        }
    }
}

- (void)tableBarAction:(UITapGestureRecognizer *)tap {
    GL_ImageVIew *imageView = (GL_ImageVIew *)tap.view;
    if ([imageView.parameter isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)imageView.parameter;
        SEL selecter = NSSelectorFromString(dic[@"func"]);
        if ([self respondsToSelector:selecter]) {
            NSDictionary *data = dic[@"vars"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:selecter withObject:data];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark Event

- (void)listAction{
    List *control = [[List alloc]init];
    [self.navigationController pushViewController:control animated:true];
}

#pragma mark - Lazy Load

- (WKWebView *)wkWeb {
    if (_wkWeb == nil) {
        _wkWeb = [[WKWebView alloc]initWithFrame:self.view.bounds];
        _wkWeb.navigationDelegate = self;
        _wkWeb.UIDelegate = self;
        _wkWeb.scrollView.showsHorizontalScrollIndicator = false;
        _wkWeb.scrollView.showsVerticalScrollIndicator = false;
        _wkWeb.scrollView.keyboardDismissMode  = UIScrollViewKeyboardDismissModeOnDrag;
        _wkWeb.backgroundColor = [UIColor whiteColor];
    }
    return _wkWeb;
}

@end
