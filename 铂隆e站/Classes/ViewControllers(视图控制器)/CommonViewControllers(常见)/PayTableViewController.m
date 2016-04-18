//
//  PayTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/7.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "PayTableViewController.h"
#import "HelpTableViewCell.h"
#import "WaterAndElectricityViewController.h"
#import "PropertyViewController.h"
#import "HeatingViewController.h"
#import "FuelGasViewController.h"


@interface PayTableViewController ()
{
    // cell背景图片数组
    NSArray *_backgroundImageArray;
    
    // 物业缴费
    PropertyViewController *_propertyVC;
    // 水电缴费
    WaterAndElectricityViewController *_waterAEVC;
    // 暖气缴费
    HeatingViewController *_heatingVC;
    // 燃气缴费
    FuelGasViewController *_fuelGasVC;
    
}
@end

@implementation PayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"缴费";
    self.navigationController.navigationBar.translucent = NO;
    
    [self initData];
    [self initTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void)initData
{
    _backgroundImageArray = @[ @"new_wuyejiaofei",
                               @"new_shuidianjiaofei",
                               @"new_meiqijiaofei",
                               @"new_nuanqijiaofei"];
}

#pragma mark - initTableView
- (void)initTableView
{
    // 设置cell分割线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIImageView new];
    // 注册 cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HelpTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_backgroundImageArray.count != 0) {
        return _backgroundImageArray.count;
    } else {
        
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.imageViews.image = [UIImage imageNamed:_backgroundImageArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            _propertyVC = [[PropertyViewController alloc] init];
            [self.navigationController pushViewController:_propertyVC animated:YES];
            break;
            
        case 1:
            _waterAEVC = [[WaterAndElectricityViewController alloc] init];
            [self.navigationController pushViewController:_waterAEVC animated:YES];
            break;
        case 2:
            _heatingVC = [[HeatingViewController alloc] init];
            [self.navigationController pushViewController:_heatingVC animated:YES];
            break;
        case 3:
            _fuelGasVC = [[FuelGasViewController alloc] init];
            [self.navigationController pushViewController:_fuelGasVC animated:YES];
            break;
        
        default:
            break;
    }
}

@end
