//
//  LS_Record_TableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/2.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Record_TableViewController.h"
#import "LS_Record_TableViewCell.h"
#import "LS_Record_Model.h"

@interface LS_Record_TableViewController ()

// 记录充值记录
@property (strong, nonatomic) NSArray *dataAr;

@end

@implementation LS_Record_TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记录";
    self.navigationController.navigationBar.translucent = NO;
    
    [self initTable];
    [self initData];
}


- (void)initTable
{
    [self.tableView setTableFooterView:[UIImageView new]];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LS_Wallet_record.jpg"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"LS_Record_TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void)initData {
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    [[NetWorkRequestManage sharInstance] wallet_moneyRecordUserID:userInfo.user_id returns:^(NSArray *array) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataAr = array;
                [self.tableView reloadData];
            });
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataAr) {
        self.tableView.backgroundView = [UIImageView new];
        return _dataAr.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LS_Record_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    LS_Record_Model *model = [_dataAr objectAtIndex:indexPath.row];
    cell.title.text = @"充值";
    cell.time.text = model.time;
    cell.money.text = [NSString stringWithFormat:@"+%@", model.money];
    cell.zong_money.text = [NSString stringWithFormat:@"余额:%@", model.zong_money];
    
    return cell;
}
@end
