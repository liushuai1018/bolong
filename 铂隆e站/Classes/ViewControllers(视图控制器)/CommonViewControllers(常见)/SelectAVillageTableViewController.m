//
//  SelectAVillageTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/23.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "SelectAVillageTableViewController.h"
#import "CommunityInformation.h"
#import "LS_WuYeInform_Model.h"

@interface SelectAVillageTableViewController ()

@end

@implementation SelectAVillageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.tableFooterView = [UIImageView new];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray) {
        return _dataArray.count;
    } else if (_wuyeAr) {
        return _wuyeAr.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_dataArray) {
        CommunityInformation *community = _dataArray[indexPath.row];
        cell.textLabel.text = community.home;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"物业费每平方米: %.2f元", community.price];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    }
    
    if (_wuyeAr) {
        LS_WuYeInform_Model *model = [_wuyeAr objectAtIndex:indexPath.row];
        cell.textLabel.text = model.fenqu;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray) {
        
        CommunityInformation *community = [_dataArray objectAtIndex:indexPath.row];
        
        // 判断block 是否实现
        if (self.block) {
            self.block(community);
        }
    }
    
    if (_wuyeAr) {
        LS_WuYeInform_Model *model = [_wuyeAr objectAtIndex:indexPath.row];
        if (self.wuyeBlock) {
            self.wuyeBlock(model);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
