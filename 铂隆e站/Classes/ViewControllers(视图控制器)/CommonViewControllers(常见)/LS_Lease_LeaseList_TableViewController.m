//
//  LS_Lease_LeaseList_TableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/28.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Lease_LeaseList_TableViewController.h"
#import "LS_Lease_TableViewCell.h"

#define cellStr @"leaseCell"

@interface LS_Lease_LeaseList_TableViewController ()

@end

@implementation LS_Lease_LeaseList_TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LS_Lease_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.geju.text = @"坐北朝南 两室一厅";
    cell.price.text = @"价格: 3500/月";
    cell.browse.text = @"2345人浏览";
    [cell.details addTarget:self action:@selector(datailsAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)datailsAction:(UIButton *)sneder event:(UIEvent *)event {
    NSLog(@"......");
}

@end
