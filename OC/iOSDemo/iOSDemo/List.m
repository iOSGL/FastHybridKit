

//
//  ListViewController.m
//  iOSDemo
//
//  Created by genglei on 2019/4/8.
//  Copyright © 2019年 genglei. All rights reserved.
//

#import "List.h"

@interface List () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , copy) NSArray *classNames;


@end

@implementation List

- (void)viewDidLoad {
    [super viewDidLoad];
    _classNames = @[@"A", @"B", @"C", @"D"];
    [self configUI];
}

#pragma mark - Config UI

- (void)configUI {
    self.navigationItem.title = @"List";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _classNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _classNames[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class targetClass = NSClassFromString(_classNames[indexPath.row]);
    if (targetClass) {
        id target = [[targetClass alloc]init];
        [self.navigationController pushViewController:target animated:true];
    }
}

#pragma mark - Lazy Load

- (UITableView *)tableView {
    if (_tableView == nil) {
        CGRect rect = self.view.frame;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
