//
//  OfflineMapsViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/8.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "OfflineMapsViewController.h"
#import "MapView.h"
#import "OfflineCityTableViewController.h"

@interface OfflineMapsViewController ()

@property (nonatomic, strong) OfflineCityTableViewController *cityTVC;


@end

@implementation OfflineMapsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"离线地图";
    self.navigationController.navigationBar.translucent = NO;
    
    [self addLeftBarBUtton]; // 添加左边按钮
    [self addRightBarButton]; // 添加右边按钮
    [self initializMapView]; // 初始化地图并添加
    [self determineTheNetworkCallOfflineMaps];
    
}

- (void)determineTheNetworkCallOfflineMaps
{
    
    
        NSString *file = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"autonavi/data/vmap"];
        CGFloat number = [self folderSizeAtPath:file];
        
        if (number != 0) {
            // 调用离线地图
            [self.mapView offlineDataIntoEffect];
        }
}

// 获取文件总大小
- (CGFloat)folderSizeAtPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 判断文件是否存在
    if (![manager fileExistsAtPath:path]) {
        return 0;
    }
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
    
    NSString *fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
        folderSize += [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
    }
    
    return folderSize / (1024 * 1024);
}

#pragma mark - Initialization
- (void)addLeftBarBUtton
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBarButton:)];
    self.navigationItem.leftBarButtonItem = left;
}
#pragma mark - Initialization
- (void)addRightBarButton
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"城市列表" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtton:)];
    self.navigationItem.rightBarButtonItem = right;
}

// 左边按钮
- (void)clickBarButton:(UIBarButtonItem *)sender
{
    self.block(_mapView);
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 右边按钮
- (void)clickRightBtton:(UIBarButtonItem *)sender
{
    self.cityTVC = [[OfflineCityTableViewController alloc] init];
    _cityTVC.mapView = self.mapView.mapView;
    [self.navigationController pushViewController:_cityTVC animated:YES];
}

#pragma mark - InitializMapView
- (void)initializMapView
{
    self.mapView = [[MapView alloc] initWithFrame:self.view.bounds];
    self.view = _mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [_mapView stopDelegateLocation];
}

@end
