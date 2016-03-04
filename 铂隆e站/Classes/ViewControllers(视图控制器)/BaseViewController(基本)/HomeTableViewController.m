//
//  HomeTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/26.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeTableViewCell.h"
#import "SDCycleScrollView.h"
#import "ServiceTableViewController.h"
#import "PayTableViewController.h"
#import "MallTableViewController.h"

@interface HomeTableViewController () <SDCycleScrollViewDelegate>

{
    PayTableViewController *_payTVC; // 缴费视图控制器
    ServiceTableViewController *_serviceTVC; // 停车视图控制器
    MallTableViewController *_mallTVC; // 商城视图控制器
    
}

// 首页列表图片组
@property (nonatomic, strong) NSArray *imageNameArray;

// 轮播图图片组
@property (nonatomic, strong) NSMutableArray *shuFflingArray;
// 轮播图
@property (nonatomic, strong) SDCycleScrollView *sdc;


@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone; // tableView的样式
    self.tableView.showsVerticalScrollIndicator = NO; // 隐藏滚动条
    self.navigationItem.title = @"首页";
    
    
    
    // 本地轮播图片
    self.shuFflingArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"L1.jpg"],[UIImage imageNamed:@"L2.jpg"], [UIImage imageNamed:@"L3.jpg"], [UIImage imageNamed:@"L4.jpg"], nil];
    //创建区头轮播图
    _sdc = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT * 0.25) imagesGroup:self.shuFflingArray];
    _sdc.delegate = self;
    _sdc.autoScrollTimeInterval = 2.0; // 设置时间
    self.tableView.tableHeaderView = self.sdc;
    
    
    
    
    // 注册 cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeCell"];
    
    // 背景图片数组
    _imageNameArray = @[@"jiaofei-.png", @"tingche-.png", @"shangcheng-.png", @"jiaofei-3.png", @"tingche-4.png", @"shangcheng-5"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 页面显示、消失
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_sdc start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_sdc suspended];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    
    
    cell.image.image = [UIImage imageNamed:_imageNameArray[indexPath.row]];
    cell.iocImage.image = [UIImage imageNamed:_imageNameArray[indexPath.row + 3]];
    NSInteger number = 1100 + indexPath.row;
    [cell.zanButton setTag:number];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;// 选中背景
    
    return cell;
}

// 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.23;
}

#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"你点击了地%ld张图片", (long)index);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
            _payTVC = [[PayTableViewController alloc] init];
            [self presentViewcontrol:@[_payTVC]];
            break;
        case 1:
            _serviceTVC = [[ServiceTableViewController alloc] init];
            [self presentViewcontrol:@[_serviceTVC]];
            break;
        case 2:
            _mallTVC = [[MallTableViewController alloc] init];
            [self presentViewcontrol:@[_mallTVC]];
            break;
            
        default:
            break;
    }
    
}

// 推出下一级视图控制器
- (void)presentViewcontrol:(NSArray *)array
{
    UINavigationController *navigationC;
    if (!navigationC) {
        
       navigationC = [[UINavigationController alloc] init];
    }
    
    [navigationC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal]; // 设置视图跳转样式
    [navigationC setViewControllers:array];
    [self presentViewController:navigationC animated:YES completion:nil];
}

@end
