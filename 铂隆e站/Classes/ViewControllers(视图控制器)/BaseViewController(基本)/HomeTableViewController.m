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

@property (strong, nonatomic) NSArray *zan_array;

// 记录点击赞的选项
@property (strong, nonatomic) NSMutableDictionary *didZan;

@end

@implementation HomeTableViewController

#pragma mark - 懒加载
- (NSMutableDictionary *)didZan
{
    if (!_didZan) {
        _didZan = [NSMutableDictionary dictionary];
    }
    return _didZan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone; // tableView的样式
    self.tableView.showsVerticalScrollIndicator = NO; // 隐藏滚动条
    self.navigationItem.title = @"首页";
    
    [self obtainData];
    [self createrHeaderView];
    
    // 注册 cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeCell"];
    
}

#pragma mark - 获取数据
- (void)obtainData
{
    // 请求首页信息
    NSDictionary *dict = [[NetWorkRequestManage sharInstance] requestHomeInformation];
    self.zan_array = [dict objectForKey:@"zan_count"];
    
    // 获取那个点击过
    [self.didZan setValuesForKeysWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"didZan"]];
    
    // 本地轮播图片
    self.shuFflingArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"L1.jpg"],
                           [UIImage imageNamed:@"L2.jpg"],
                           [UIImage imageNamed:@"L3.jpg"],
                           [UIImage imageNamed:@"L4.jpg"],
                           nil];
    
    // 背景图片数组
    _imageNameArray = @[@"jiaofei-.png",
                        @"tingche-.png",
                        @"shangcheng-.png",
                        @"jiaofei-3.png",
                        @"tingche-4.png",
                        @"shangcheng-5"];
}

#pragma mark - 创建区头
- (void)createrHeaderView
{
    //创建区头轮播图
    _sdc = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT * 0.25) imagesGroup:self.shuFflingArray];
    _sdc.delegate = self;
    _sdc.autoScrollTimeInterval = 2.0; // 设置时间
    self.tableView.tableHeaderView = self.sdc;
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
    cell.zanTime.text = [NSString stringWithFormat:@"%@", [_zan_array objectAtIndex:indexPath.row]];
    
    // 获取是否点击过去执行显示样式
    BOOL is = [self judgeDidZanIndex:indexPath.row];
    if (is) {
        [cell.zanButton setImage:[UIImage imageNamed:@"zan-2.png"] forState:UIControlStateNormal];
    } else {
        NSInteger number = 1100 + indexPath.row;
        [cell.zanButton setTag:number];
        [cell.zanButton addTarget:self action:@selector(zanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;// 选中背景
    return cell;
}

#pragma mark - 判断当天是否已经点击过赞了
- (BOOL)judgeDidZanIndex:(NSInteger)index
{
    // 获取已经点击的项目
    NSString *keyType = [NSString stringWithFormat:@"type%ld", index];
    NSDictionary *dict = [self.didZan objectForKey:keyType];
    
    // 判断时间
    BOOL isDate = [[dict objectForKey:@"date"] isEqualToString:[self obtainDate]];
    // 判断是否已经赞过
    BOOL isZan = [[dict objectForKey:@"state"] isEqualToString:@"1"];
    
    if (isDate && isZan) {
        return YES;
    } else {
        return NO;
    }
}


// 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.23;
}

#pragma mark - 点赞
- (void)zanButtonAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 1100;
    
    UserInformation *userInformation = [[LocalStoreManage sharInstance] requestUserInfor];
    
    NSString *type = [NSString stringWithFormat:@"%ld", index + 1];
    
    [[NetWorkRequestManage sharInstance] didZanUser_id:userInformation.user_id
                                                  type:type];
    
    HomeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                                       inSection:0]];
    
    NSInteger count = [[_zan_array objectAtIndex:index] integerValue] + 1;
    cell.zanTime.text = [NSString stringWithFormat:@"%ld", count];
    
    [sender setImage:[UIImage imageNamed:@"zan-2.png"] forState:UIControlStateNormal];
    
    
    NSString *date = [self obtainDate];
    
    // 把状态和日期封装一个字典
    NSDictionary *dict = @{@"date" : date,
                           @"state" : @"1"};
    
    NSString *keyStr = [NSString stringWithFormat:@"type%ld", index];
    
    [self.didZan setObject:dict forKey:keyStr];
    
    [[NSUserDefaults standardUserDefaults] setObject:_didZan forKey:@"didZan"];
    
}

#pragma mark - 获取当前日期
- (NSString *)obtainDate
{
    // 当前点击时间
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [dateFormatter setTimeZone:zone];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *datestr = [dateFormatter stringFromDate:date];
    NSLog(@"时间 = %@", datestr);
    return datestr;
}

#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"你点击了地%ld张图片", (long)index);
}

#pragma mark - 点击cell
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
