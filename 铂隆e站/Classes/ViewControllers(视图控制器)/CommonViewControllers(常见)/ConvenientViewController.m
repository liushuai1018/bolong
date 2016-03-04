//
//  ConvenientViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/13.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "ConvenientViewController.h"
#import "MapView.h"

@interface ConvenientViewController ()

// 地图视图
@property (nonatomic, strong) MapView *mapView;

@end

@implementation ConvenientViewController

- (void)loadView
{
    self.mapView = [[MapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"便利店|超市";
    // 创建搜索体
    [_mapView initializeMapSearchKeywords:@"便利店" types:@"生活服务|购物服务"];
    
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
