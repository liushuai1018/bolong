//
//  ServiceTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/7.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "ServiceTableViewController.h"
#import "HelpTableViewCell.h"
#import "PresenceViewController.h"
#import "SurroundTableViewController.h"
#import "ParkingConsultingViewController.h"

@interface ServiceTableViewController ()
{
    NSArray *_imageNameArray; // 存储图片名字
    UINavigationController *_navigations; // 导航栏
    PresenceViewController *_presenceVC; // 占道停车控制器
    SurroundTableViewController *_surroundTVC; // 周边控制器
    ParkingConsultingViewController *_parkingConsultingVC; // 停车咨询
}

@end

@implementation ServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"停车";
    [self replaceLeftBarButton]; // 替换系统的左边BarButton
    // 借助了帮助界面的Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HelpTableViewCell" bundle:nil] forCellReuseIdentifier:@"helpCell"];
    
    _imageNameArray = @[@"zhandaotingche.png", @"shangyetingche", @"shequtingche",@"zhoubian.png", @"tingchezixun.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 替换系统的左边BarButton
- (void)replaceLeftBarButton
{
   
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftAction:)];
    self.navigationItem.leftBarButtonItem = left;
    
}
// 自定义左边BarBUtton事件
- (void)didClickLeftAction:(UIBarButtonItem *)bar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imageNameArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpCell" forIndexPath:indexPath];
    
    cell.imageViews.image = [UIImage imageNamed:_imageNameArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.25;
}

// 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            
        case 0: {
            _presenceVC = [[PresenceViewController alloc] init];
            [self.navigationController pushViewController:_presenceVC animated:YES];
            break;
        }
        case 3: {
            _surroundTVC = [[SurroundTableViewController alloc] init];
            [self.navigationController pushViewController:_surroundTVC animated:YES];
            break;
        }
        case 4: {
            _parkingConsultingVC = [[ParkingConsultingViewController alloc] init];
            [self.navigationController pushViewController:_parkingConsultingVC animated:YES];
            break;
        }
        default:
            break;
    }
}



@end
