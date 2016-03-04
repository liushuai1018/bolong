//
//  BankCardTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/5.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "BankCardTableViewController.h"

@interface BankCardTableViewController ()

@end

@implementation BankCardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"银行卡";
    self.navigationController.navigationBar.translucent = NO; // 不透明
    
    
    // 添加barButtonItem按钮
    [self addBarButtonItem];
    
}
#pragma mark 添加右navigation 按钮
- (void)addBarButtonItem
{
    UIBarButtonItem *rigths = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRigthItem:)];
    self.navigationItem.rightBarButtonItem = rigths;
}

// 实现添加银行卡
- (void)clickRigthItem:(UIBarButtonItem *)sender
{
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 判断是否有绑定的银行卡
    if (self.bankCardDic == nil) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = [UIImage imageNamed:@"yihangkabeijing.png"];
        self.view = imageView;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [_bankCardDic count]; // 获得有多少银行卡
    if (0 == count) {
        return 0;
    } else {
        return count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    
    return cell;
}

@end
