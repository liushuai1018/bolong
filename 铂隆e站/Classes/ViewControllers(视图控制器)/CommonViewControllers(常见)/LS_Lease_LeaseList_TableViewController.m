//
//  LS_Lease_LeaseList_TableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/28.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Lease_LeaseList_TableViewController.h"
#import "LS_Lease_TableViewCell.h"
#import "LS_LeaseOrSell_Model.h"
#import "LS_LeaseDetails_ViewController.h"

#define cellStr @"leaseCell"

@interface LS_Lease_LeaseList_TableViewController ()

@end

@implementation LS_Lease_LeaseList_TableViewController

- (void)setDataAr:(NSArray *)dataAr {
    _dataAr = dataAr;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Lease_tableView_loadData" object:self];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    [self initRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initRefreshControl
- (void)initRefreshControl {
    UIRefreshControl *refreshC = [[UIRefreshControl alloc] init];
    refreshC.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
    [refreshC addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshC;
}

- (void)refreshControlAction:(UIRefreshControl *)sneder {
    if (self.refreshControl.refreshing) { // 判断状态
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在加载..."];
        __weak LS_Lease_LeaseList_TableViewController *weak_control = self;
        [[NetWorkRequestManage sharInstance] other_LeaseOrSellLiseInfostate:@"1" returns:^(NSArray *dataAr) {
            weak_control.dataAr = dataAr;
            [weak_control endRefreshings];
        }];
    }
}

- (void)endRefreshings {
    __weak LS_Lease_LeaseList_TableViewController *weak_control = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weak_control.refreshControl endRefreshing];
        weak_control.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
    });
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    LS_LeaseOrSell_Model *model = [_dataAr objectAtIndex:indexPath.row];
    
    [[NetWorkRequestManage sharInstance] downloadImageURL:[model.house_image objectAtIndex:0] returns:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.icoImage.image = image;
        });
    }];
     
    cell.geju.text = model.house_style;
    cell.price.text = model.house_price;
    cell.browse.text = [NSString stringWithFormat:@"%@ 人浏览", model.house_count];
    [cell.details addTarget:self action:@selector(datailsAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)datailsAction:(UIButton *)sneder event:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    LS_LeaseOrSell_Model *model = [_dataAr objectAtIndex:indexPath.row];
    
    LS_LeaseDetails_ViewController *control = [[LS_LeaseDetails_ViewController alloc] init];
    control.title = @"租赁详情";
    control.listID = model.listID;
    [self.navigationController pushViewController:control animated:YES];
}
@end
