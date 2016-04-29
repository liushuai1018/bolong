//
//  SurroundTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/7.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "SurroundTableViewController.h"
#import "HelpTableViewCell.h"
#import "GasStationViewController.h"
#import "FoodViewController.h"
#import "ConvenientViewController.h"
#import "OpenBetaViewController.h"

@interface SurroundTableViewController ()
{
    // cell背景图片数组
    NSArray *_backgroundImageArray;
    // 加油站
    GasStationViewController *_gasStationVC;
    // 美食
    FoodViewController *_foodVC;
    // 便利店
    ConvenientViewController *_convenientVC;
    // 公测
    OpenBetaViewController *_openBetaVC;
}
@end

@implementation SurroundTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"周边";
    
    // 背景图
    _backgroundImageArray = @[@"LS_tingche_jiayouzhan",
                              @"LS_tingche_meishi",
                              @"LS_tingche_chaoshi",
                              @"LS_tingche_xishoujian"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HelpTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    
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
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.imageViews.image = [UIImage imageNamed:_backgroundImageArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.25;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            _gasStationVC = [[GasStationViewController alloc] init];
            [self.navigationController pushViewController:_gasStationVC animated:YES];
            break;
        case 1:
            _foodVC = [[FoodViewController alloc] init];
            [self.navigationController pushViewController:_foodVC animated:YES];
            break;
        case 2:
            _convenientVC = [[ConvenientViewController alloc] init];
            [self.navigationController pushViewController:_convenientVC animated:YES];
            break;
        case 3:
            _openBetaVC = [[OpenBetaViewController alloc] init];
            [self.navigationController pushViewController:_openBetaVC animated:YES];
            break;
            
        default:
            break;
    }
}

@end
