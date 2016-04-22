//
//  LS_selectRegion_TableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/21.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_selectRegion_TableViewController.h"

#define cellString @"cell"
@interface LS_selectRegion_TableViewController ()

@property (strong, nonatomic) NSArray *regionAr;

@end

@implementation LS_selectRegion_TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地区";
    
    [self initData];
    self.tableView.tableFooterView = [UIImageView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void)initData
{
    _regionAr = @[@"门头沟区",
                  @"石景山区",
                  @"海淀区",
                  @"东城区",
                  @"西城区",
                  @"崇文区",
                  @"宣武区",
                  @"朝阳区",
                  @"丰台区",
                  @"房山区",
                  @"通州区",
                  @"顺义区",
                  @"昌平区",
                  @"大兴区",
                  @"怀柔区",
                  @"平谷区",
                  @"延庆县",
                  @"密云县"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_regionAr.count == 0) {
        return 0;
    } else {
        return _regionAr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    
    cell.textLabel.text = [_regionAr objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [_regionAr objectAtIndex:indexPath.row];
    if (self.block) {
        _block(str);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
