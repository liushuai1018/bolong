//
//  OpenBetaViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/13.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "OpenBetaViewController.h"
#import "MapView.h"

@interface OpenBetaViewController ()

// 地图
@property (nonatomic, strong) MapView *mapView;

@end

@implementation OpenBetaViewController

- (void)loadView
{
    self.mapView = [[MapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公厕";
    // 创建搜索体
    [_mapView initializeMapSearchKeywords:@"公共厕所" types:@"公共设施"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView stopDelegateLocation]; // 停止代理和定位
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
