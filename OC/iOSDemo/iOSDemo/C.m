//
//  C.m
//  iOSDemo
//
//  Created by genglei on 2019/4/8.
//  Copyright © 2019年 genglei. All rights reserved.
//

#import "C.h"

@interface C ()

@end

@implementation C

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark - Config UI

- (void)configUI {
    self.navigationItem.title = @"C";
    self.view.backgroundColor = [UIColor blueColor];
    UILabel *lab = [[UILabel alloc]init];
    lab.text = self.arg;
    lab.backgroundColor = [UIColor whiteColor];
    lab.textColor = [UIColor blackColor];
    lab.frame = CGRectMake((self.view.frame.size.width - 200) / 2, 100, 200, 30);
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
}


@end
