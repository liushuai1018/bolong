//
//  GasStationViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/13.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "GasStationViewController.h"
#import "MapView.h"

@interface GasStationViewController ()

@property (nonatomic, strong) MapView *mapView;

@end

@implementation GasStationViewController

- (void)loadView
{
    self.mapView = [[MapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加油站";
    
    [_mapView initializeMapSearchKeywords:@"加油站" types:@"汽车服务"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView stopDelegateLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
