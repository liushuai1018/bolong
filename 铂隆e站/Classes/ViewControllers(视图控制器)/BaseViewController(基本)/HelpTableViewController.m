//
//  HelpTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/26.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "HelpTableViewController.h"
#import "HelpTableViewCell.h"
#import "AboutUsViewController.h"
#import "FeedbckViewController.h"
#import "OfflineMapsViewController.h"
#import "HelpOperationViewController.h"

#import "MapView.h"

@interface HelpTableViewController ()
{
    UINavigationController *_navigation;
    AboutUsViewController *_aboutUsVC; // 关于我们
    FeedbckViewController *_feedbckVC; // 意见反馈
    OfflineMapsViewController *_offlineMVC; // 离线地图
    HelpOperationViewController *_operationVC; // 操作指南
}


// 背景图片
@property (nonatomic, strong) NSArray *backgroundImage;

@end

@implementation HelpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.navigationItem.title = @"帮助";
    self.tableView.showsVerticalScrollIndicator = NO; // 隐藏滚动条
    
    // 注册 cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HelpTableViewCell" bundle:nil] forCellReuseIdentifier:@"helpCell"];
    
    // 背景图片
    _backgroundImage = @[@"lixianditu.png", @"guanyuwomen.png", @"caozuozhinan.png", @"jianyifanku.png"];
    
    
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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpCell" forIndexPath:indexPath];
    
    cell.imageViews.image = [UIImage imageNamed:_backgroundImage[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone; // 选中背景
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.2;
}


// 点击的那个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_navigation) {
        
        _navigation = [[UINavigationController alloc] init];
    }
    
    switch (indexPath.row) {
        case 0:
            _offlineMVC = [[OfflineMapsViewController alloc] init];
            
            _offlineMVC.block = ^(id obj) {
                MapView *map = obj;
                [map stopDelegateLocation];
            };
            
            [_navigation setViewControllers:@[_offlineMVC]];
            [self presentViewController:_navigation animated:YES completion:nil];
            break;
        case 1:
            _aboutUsVC = [[AboutUsViewController alloc] init];
            [_navigation setViewControllers:@[_aboutUsVC]];
            [self presentViewController:_navigation animated:YES completion:nil];
            break;
        case 2:
            _operationVC = [[HelpOperationViewController alloc] init];
            [_navigation setViewControllers:@[_operationVC]];
            [self presentViewController:_navigation animated:YES completion:nil];
            break;
        case 3:
            _feedbckVC = [[FeedbckViewController alloc] init];
            [_navigation setViewControllers:@[_feedbckVC]];
            [self presentViewController:_navigation animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}


@end
