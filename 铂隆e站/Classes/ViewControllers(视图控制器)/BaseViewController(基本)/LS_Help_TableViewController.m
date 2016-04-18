//
//  LS_Help_TableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/18.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Help_TableViewController.h"
#import "HelpTableViewCell.h"
#import "OfflineMapsViewController.h"
#import "AboutUsViewController.h"
#import "FeedbckViewController.h"
#import "HelpOperationViewController.h"

#define cellStr @"cell"
@interface LS_Help_TableViewController ()
{
    // 离线地图
    OfflineMapsViewController *_offlineMaps;
    // 关于我们
    AboutUsViewController *_aboutUs;
    // 操作指南
    HelpOperationViewController *_operation;
    // 意见反馈
    FeedbckViewController *_feedbck;
    
    // 背景图组
    NSArray *_imageAr;
}
@end

@implementation LS_Help_TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    self.navigationController.navigationBar.translucent = NO;
    
    [self initData];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - initData
- (void)initData
{
    // 背景图片
    _imageAr = @[@"new_lixianditu",
                         @"new_guanyuwomen",
                         @"new_caozuozhinan",
                         @"new_xiergongting"];
}

#pragma mark - initTableView
- (void)initTableView
{
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO; // 隐藏滚动条
    self.tableView.scrollEnabled = NO; // 禁止滑动
    self.tableView.tableFooterView = [UIImageView new];
    // 注册 cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HelpTableViewCell" bundle:nil] forCellReuseIdentifier:cellStr];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_bangzhu_bg"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_imageAr.count != 0) {
        return _imageAr.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    
    cell.imageViews.image = [UIImage imageNamed:[_imageAr objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT *0.1;
}

// 点击的那个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id control = nil;
    
    switch (indexPath.row) {
        case 0:
            control = [[OfflineMapsViewController alloc] init];
            
            break;
        case 1:
            control = [[AboutUsViewController alloc] init];
            
            break;
        case 2:
            control = [[HelpOperationViewController alloc] init];
            
            break;
        case 3:
            control = [[FeedbckViewController alloc] init];
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:control animated:YES];
}

@end
