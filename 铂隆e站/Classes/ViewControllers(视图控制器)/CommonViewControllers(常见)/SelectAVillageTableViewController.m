//
//  SelectAVillageTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/23.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "SelectAVillageTableViewController.h"

@interface SelectAVillageTableViewController ()

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation SelectAVillageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择小区";
    self.navigationController.navigationBar.translucent = NO;
    [self setData];
    self.tableView.tableFooterView = [UIImageView new];
}

#pragma mark - 设置数据源
- (void)setData
{
    self.dataArray = @[@"惠润嘉园一区",
                       @"惠润嘉园二区",
                       @"惠润嘉园三区",
                       @"惠润嘉园四区",
                       @"惠润嘉园五区",
                       @"惠润嘉园六区",
                       @"惠润嘉园七区"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断block 是否实现
    if (self.block) {
        self.block(_dataArray[indexPath.row]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
