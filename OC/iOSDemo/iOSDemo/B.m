//
//  B.m
//  iOSDemo
//
//  Created by genglei on 2019/4/8.
//  Copyright © 2019年 genglei. All rights reserved.
//

#import "B.h"

@interface B ()

@end

@implementation B

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark - Config UI

- (void)configUI {
    self.navigationItem.title = @"B";
    self.view.backgroundColor = [UIColor purpleColor];
    UILabel *lab = [[UILabel alloc]init];
    lab.text = self.arg;
    lab.backgroundColor = [UIColor whiteColor];
    lab.textColor = [UIColor blackColor];
    lab.frame = CGRectMake((self.view.frame.size.width - 200) / 2, 100, 200, 30);
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
}


@end
