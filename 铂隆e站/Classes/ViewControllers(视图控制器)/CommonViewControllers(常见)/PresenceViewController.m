//
//  PresenceViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/7.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "PresenceViewController.h"
#import "NearView.h"
#import "CustomView.h"
@interface PresenceViewController ()
{
    // 临时数据
    CGFloat _tempProgress;
}
@property (nonatomic, strong) UISegmentedControl *segmentedControl; // 分段视图控制器
@property (nonatomic, strong) NearView *nearView; // 附近占道停车
@property (nonatomic, strong) CustomView *customView; // 自定义占道停车

@end

@implementation PresenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _tempProgress = 0.1;
    
    self.title = @"占道停车";
    [self replaceLeftBarButton]; //替换系统自带BarButton
    [self addSegment]; // 添加分段视图
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加分段视图
- (void)addSegment
{
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"附近", @"自定义"]];
    _segmentedControl.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 100, 10, 200, 30);
//    _segmentedControl.momentary = NO;
    _segmentedControl.selectedSegmentIndex = 0; // 默认那个界面
    _segmentedControl.tintColor = [UIColor orangeColor];
    [_segmentedControl addTarget:self action:@selector(didClickSegmentedAction:) forControlEvents:UIControlEventValueChanged];
    
    // 创建两个子视图
    self.nearView = [[NearView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentedControl.frame) + 5, SCREEN_WIDTH, CGRectGetHeight(self.view.frame) - 84)];
    
    [_nearView.addButton addTarget:self action:@selector(addButAction:) forControlEvents:UIControlEventTouchUpInside];
    [_nearView.reduceButton addTarget:self action:@selector(reduceButAction:) forControlEvents:UIControlEventTouchUpInside];
#warning mark - 以停车所占比例
    _nearView.progress = _tempProgress; // 比例占得数
    
    self.customView = [[CustomView alloc] initWithFrame:_nearView.frame];
#warning mark 服务器请求下来的街道
    _customView.roadArray = @[@"道路 1", @"道路 2", @"道路 3", @"道路 4", @"道路 5",];
    _customView.streetArray = @[@"街道 1", @"街道 2", @"街道 3", @"街道 4", @"街道 5"];
    
    [self.view addSubview:_segmentedControl];
    [self.view addSubview:_nearView];
}

- (void)addButAction:(UIButton *)but
{
    NSLog(@"点击了抢走一个");
    _tempProgress -= 0.1;
    _nearView.progress = _tempProgress;
    NSInteger number = [_nearView.remainingNum.text intValue];
    _nearView.remainingNum.text = [NSString stringWithFormat:@"%ld", number + 1];
}
- (void)reduceButAction:(UIButton *)but
{
    NSLog(@"点击了我走喽!");
    _tempProgress += 0.1;
    _nearView.progress = _tempProgress;
    
    _nearView.progress = _tempProgress;
    NSInteger number = [_nearView.remainingNum.text intValue];
    _nearView.remainingNum.text = [NSString stringWithFormat:@"%ld", number - 1];
}


#pragma mark - add Left BarButton
- (void)replaceLeftBarButton
{
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftAction:)];
    self.navigationItem.leftBarButtonItem = left;
    
}
// left Action
- (void)didClickLeftAction:(UIBarButtonItem *)bar
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - segmentedDetegate
- (void)didClickSegmentedAction:(UISegmentedControl *)sender
{
    
    NSInteger index = sender.selectedSegmentIndex;
    NSLog(@"你选中了 %ld", (long)index);
    if (0 == index) {
        
        if (_nearView.superview == nil) {
            [_customView removeFromSuperview];
            [self.view addSubview:_nearView];
            [self.view bringSubviewToFront:sender];
        }
    } else if (1 == index) {
        
        if (_customView.superview == nil) {
            [_nearView removeFromSuperview];
            [self.view addSubview:_customView];
            [self.view bringSubviewToFront:sender];
        }
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
