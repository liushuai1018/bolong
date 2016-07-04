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

#define cellStr @"leaseCell"

@interface LS_Lease_LeaseList_TableViewController ()

@end

@implementation LS_Lease_LeaseList_TableViewController

- (void)setDataAr:(NSArray *)dataAr {
    _dataAr = dataAr;
    [self.tableView reloadData];
}

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
    
    /*
    [[NetWorkRequestManage sharInstance] downloadImageURL:model.house_image returns:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.icoImage.image = image;
        });
    }];
    */
     
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
    NSLog(@"......");
}

@end
