//
//  SelectAVillageTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/23.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "SelectAVillageTableViewController.h"
#import "CommunityInformation.h"

@interface SelectAVillageTableViewController ()

@end

@implementation SelectAVillageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择小区";
    self.navigationController.navigationBar.translucent = NO;
    
    
    self.tableView.tableFooterView = [UIImageView new];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CommunityInformation *community = _dataArray[indexPath.row];
    
    cell.textLabel.text = community.home;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"物业费每平方米: %.2f元", community.price];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommunityInformation *community = [_dataArray objectAtIndex:indexPath.row];
    
    // 判断block 是否实现
    if (self.block) {
        self.block(community);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
