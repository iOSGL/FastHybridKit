//
//  AppDelegate.m
//  iOSDemo
//
//  Created by genglei on 2019/4/4.
//  Copyright © 2019年 genglei. All rights reserved.
//

#import "AppDelegate.h"
#import "WebController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self SVPConf];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    WebController *control = [[WebController alloc]init];
    WebModel *model = [[WebModel alloc]init];
    model.htmlUrl = @"index";
    model.title = @"Hybrid";
    model.hideNavigationBar = true;
    control.model = model;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:control];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)SVPConf {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setMaximumDismissTimeInterval:1.5];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
