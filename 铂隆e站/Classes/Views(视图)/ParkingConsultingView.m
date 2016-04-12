//
//  ParkingConsultingView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/20.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "ParkingConsultingView.h"

@implementation ParkingConsultingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubView]; // 创建所有子视图
    }
    return self;
}

#pragma mark - 创建所有子视图
- (void)createAllSubView
{
    CGFloat width = CGRectGetWidth(self.frame);
    self.backgroundColor = [UIColor whiteColor];
    
    
    NSArray *array = @[@"最新咨询", @"在线咨询", @"答复"];

    
    
    // 分段视图控制器
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:array];
    self.segmentControl.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 30);
    self.segmentControl.tintColor = [UIColor blackColor];
    [self.segmentControl setSelectedSegmentIndex:0];
    [self.segmentControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segmentControl];
    
    // 滑动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentControl.frame) + 10, width, CGRectGetHeight(self.frame) - 114)];
    _scrollView.contentSize = CGSizeMake(3 * width, CGRectGetHeight(_scrollView.frame));
    _scrollView.bounces = NO; // 边界反弹
    _scrollView.alwaysBounceHorizontal = NO; // 水平
    _scrollView.alwaysBounceVertical = NO; // 垂直
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    CGFloat scrollHeight = CGRectGetHeight(_scrollView.frame);
    
    // 最新咨询
    self.latestTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, scrollHeight)];
    _latestTV.tag = 12500;
    [_scrollView addSubview:_latestTV];
    
    // 发送咨询
    self.senderConsulting = [UIButton buttonWithType:UIButtonTypeCustom];
    self.senderConsulting.frame = CGRectMake(SCREEN_WIDTH - 70, scrollHeight - 90, 50, 50);
    [self.senderConsulting setBackgroundImage:[UIImage imageNamed:@"LS_sender"] forState:UIControlStateNormal];
    [_scrollView addSubview:_senderConsulting];
    [_scrollView bringSubviewToFront:_senderConsulting];
    
    // 在线咨询
    self.onlineTV = [[UITableView alloc] initWithFrame:CGRectMake(width, 0, width, scrollHeight)];
    _onlineTV.tag = 12501;
    [_scrollView addSubview:_onlineTV];
    
    
    // 答复
    self.replyTV = [[UITableView alloc] initWithFrame:CGRectMake(width * 2, 0, width, scrollHeight)];
    _replyTV.tag = 12502;
    [_scrollView addSubview:_replyTV];
    
}

#pragma mark - 分段视图事件
- (void)segmentedControlAction:(UISegmentedControl *)sender
{
    NSInteger index = sender.selectedSegmentIndex;
    
    // 在转换界面时候收回键盘
    if (self.block) {
        self.block(index);
    }
    
    switch (index) {
        case 0: {
            [self setDisplayThePage:index];
            break;
        }
        case 1: {
            [self setDisplayThePage:index];
            break;
        }
        case 2: {
            [self setDisplayThePage:index];
            break;
        }
            
        default:
            break;
    }
}
// 条跳转到对应的tableView
- (void)setDisplayThePage:(NSInteger)index
{
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int a = scrollView.contentOffset.x / scrollView.frame.size.width; // 计算当前显示的那一项
    int index = abs(a); // abs 获取绝对值函数
    [self.segmentControl setSelectedSegmentIndex:index];
    
    // 在转换界面时候收回键盘
    if (self.block) {
        self.block(index);
    }
    
}

@end
