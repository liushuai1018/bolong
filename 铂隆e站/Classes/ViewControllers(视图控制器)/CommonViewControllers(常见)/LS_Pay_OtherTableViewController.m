//
//  LS_Pay_OtherTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/15.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Pay_OtherTableViewController.h"
#import "HelpTableViewCell.h"

#import "LS_Other_Unlocking_ViewController.h"
#import "LS_Other_recycling_ViewController.h"
#import "LS_Other_Water_ViewController.h"
#import "LS_Other_BaoXiu_ViewController.h"
#import "LS_Other_Sign_ViewController.h"
#import "LS_Lease_ViewController.h"

@interface LS_Pay_OtherTableViewController ()
// 背景图片
@property (strong, nonatomic) NSArray *backgroundImageAr;

@end

@implementation LS_Pay_OtherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"其他";
    self.navigationController.navigationBar.translucent = NO;
    
    [self initData];
    [self initTableView];
    [self addBarButton];
}

#pragma mark - 添加左边 barBUtton
- (void)addBarButton
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButton:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)clickLeftBarButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void)initData
{
    _backgroundImageAr = @[@"new_jiaofei_other_kaisuo",
                           @"new_jiaofei_other_huishou",
                           @"new_jiaofei_other_songshui",
                           @"new_jiaofei_other_weixiu",
                           @"new_jiaofei_other_qiandao",
                           @"new_jiaofei_other_zulin" // 隐藏租赁选项
                           ];
}

#pragma mark - init TableView
- (void)initTableView
{
    self.tableView.scrollEnabled = NO; // 禁止滑动
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    // 注册 cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HelpTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.tableFooterView = [UIImageView new];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_bangzhu_bg"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    if (_backgroundImageAr.count == 0) {
        return 0;
    } else {
        return _backgroundImageAr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageViews.image = [UIImage imageNamed:[_backgroundImageAr objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH * 0.2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id control = nil;
    switch (indexPath.row) {
        case 0: {
            control = [[LS_Other_Unlocking_ViewController alloc] init];
            break;
        }
        case 1: {
            control = [[LS_Other_recycling_ViewController alloc] init];
            break;
        }
        case 2: {
            control = [[LS_Other_Water_ViewController alloc] init];
            break;
        }
        case 3: {
            control = [[LS_Other_BaoXiu_ViewController alloc] init];
            break;
        }
        case 4: {
            control = [[LS_Other_Sign_ViewController alloc] init];
            break;
        }
        case 5: {
            control = [[LS_Lease_ViewController alloc] init];
            break;
        }
            
        default:
            break;
    }
    [self.navigationController pushViewController:control animated:YES];
}

@end
