//
//  InforSetTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/2/2.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "InforSetTableViewController.h"
#import "InforSetTableViewCell.h"
@interface InforSetTableViewController ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation InforSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO; // navigation 不透明
    self.title = @"信息设置";
    
    _array = @[@"不接受圈子消息",
               @"不接受好友邀请",
               @"不接受消息提醒"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InforSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView setTableFooterView:[[UIImageView alloc] init]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InforSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.infor.text = _array[indexPath.row];
    cell.choose.tag = 13100 + indexPath.row;
    
    [cell.choose addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

- (void)clickSwitch:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    
    BOOL isBut = [switchButton isOn];
    
    switch (switchButton.tag) {
        case 13100: {
            if (isBut) {
                NSLog(@"接受圈子消息");
            } else {
                NSLog(@"拒绝圈子消息");
            }
            break;
        }
        case 13101: {
            if (isBut) {
                NSLog(@"接受好友邀请");
            } else {
                NSLog(@"拒绝好友邀请");
            }
            break;
        }
        case 13102: {
            if (isBut) {
                NSLog(@"接受消息");
            } else {
                NSLog(@"拒绝消息");
            }
            break;
        }
        default:
            break;
    }
    
    
}

@end
