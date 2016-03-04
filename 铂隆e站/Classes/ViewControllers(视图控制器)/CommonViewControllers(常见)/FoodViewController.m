//
//  FoodViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/13.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "FoodViewController.h"
#import "MapView.h"

@interface FoodViewController () <AMapSearchDelegate>

// 地图视图
@property (nonatomic, strong) MapView *mapView;

@end

@implementation FoodViewController

- (void)loadView
{
    self.mapView = [[MapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"美食";
    
    // 创建搜索体
    [_mapView initializeMapSearchKeywords:@"美食" types:@"餐饮服务|住宿服务"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView stopDelegateLocation]; // 停止代理和定位
}



@end
