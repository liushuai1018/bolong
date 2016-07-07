//
//  LS_Lease_Sell_TableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/28.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Lease_Sell_TableViewController.h"
#import "LS_Lease_TableViewCell.h"
#import "LS_LeaseOrSell_Model.h"
#import "LS_LeaseDetails_ViewController.h"

#define cellStr @"sellCell"

@interface LS_Lease_Sell_TableViewController ()

@end

@implementation LS_Lease_Sell_TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    [self initRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataAr:(NSArray *)dataAr {
    _dataAr = dataAr;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark - initRefreshControl
- (void)initRefreshControl {
    /**
     * 初始化刷新控件 <这个类只能用于表视图类>
     * 关于布局问题可以不用考虑，关于UITableViewController会将其自动放置于表视图中
     */
    UIRefreshControl *refreshC = [[UIRefreshControl alloc] init];
    refreshC.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
    [refreshC addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshC;
}
// 添加的刷新事件
- (void)refreshControlAction:(UIRefreshControl *)sneder {
    if (self.refreshControl.refreshing) { // 判断状态是否处于刷新状态
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在加载..."];
        __weak LS_Lease_Sell_TableViewController *weak_control = self;
        // 网络请求
        [[NetWorkRequestManage sharInstance] other_LeaseOrSellLiseInfostate:@"1" returns:^(NSArray *dataAr) {
            /**
             *  我的网络请求都在子线程中执行的
             */
            weak_control.dataAr = dataAr;
            [weak_control endRefreshings]; // 请求完成要执行停止刷新
        }];
    }
}
// 刷新停止事件
- (void)endRefreshings {
    __weak LS_Lease_Sell_TableViewController *weak_control = self;
    /**
     *  所以这要换成主线程
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [weak_control.refreshControl endRefreshing]; // 停止下来刷新回复初始状态
        weak_control.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
    }); // 文本变回原装
}

#pragma mark - initTableView
- (void)initTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIImageView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LS_Lease_TableViewCell" bundle:nil] forCellReuseIdentifier:cellStr];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataAr) {
        return _dataAr.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LS_Lease_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LS_LeaseOrSell_Model *model = [_dataAr objectAtIndex:indexPath.row];
    
    [[NetWorkRequestManage sharInstance] downloadImageURL:[model.house_image objectAtIndex:0] returns:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.icoImage.image = image;
        });
    }];
    
    cell.geju.text = model.house_style;
    cell.price.text = model.house_price;
    cell.fangshi.text = @"首付 20%";
    cell.browse.text = [NSString stringWithFormat:@"%@ 人浏览", model.house_count];
    
    [cell.details addTarget:self action:@selector(deailsAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)deailsAction:(UIButton *)sender event:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    LS_LeaseOrSell_Model *model = [_dataAr objectAtIndex:indexPath.row];
    
    LS_LeaseDetails_ViewController *control = [[LS_LeaseDetails_ViewController alloc] init];
    control.title = @"出售详情";
    control.listID = model.listID;
    [self.navigationController pushViewController:control animated:YES];
}
@end
