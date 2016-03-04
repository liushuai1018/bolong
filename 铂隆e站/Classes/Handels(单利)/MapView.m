//
//  MapView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/13.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "MapView.h"
#import "POIAnntation.h"
@interface MapView () <MAMapViewDelegate, AMapSearchDelegate>
{
    // 周边请求参数体
    AMapPOIAroundSearchRequest *_request;
    
    BOOL temp;
}
@end

@implementation MapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubView];
        temp = YES;
    }
    return self;
}
#pragma mark 创建所有子视图
- (void)createAllSubView
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 配置用户key
    [MAMapServices sharedServices].apiKey = MA_Map_Key;
    // 初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.bounds];
    // 设置代理
    _mapView.delegate = self;
    
    [self addSubview:_mapView];
    // 比例尺
    _mapView.showsScale = YES;
    // 比例尺位置
    _mapView.scaleOrigin = CGPointMake(10, 10);
    // 地图显示比例
    _mapView.zoomLevel = 15;
    // 打开定位
    _mapView.showsUserLocation = YES;
    // 定位图层显示模式 ： 跟随用户位置移动，并将定位点设置成地图中心点
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow];
    
}

// 实时获取用户地址展示到地图上
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        
        // 实时更新用户信息
//        _mapView.centerCoordinate = userLocation.location.coordinate;
        
        if (temp && _searchAPI != nil) { // 获取用户位置后请求附近搜索
            [self sendRequest:[AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude]];
            temp = NO;
        }
    }
}

#pragma mark 停止代理定位
- (void)stopDelegateLocation
{
    // 停止定位
    _mapView.showsUserLocation = NO;
    _mapView.delegate = nil;
    _searchAPI.delegate = nil;
    
}

#pragma mark 初始化搜索管理对象
- (void)initializeMapSearchKeywords:(NSString *)strings types:(NSString *)types
{
    [AMapSearchServices sharedServices].apiKey = MA_Map_Key;
    // 初始化搜索管理对象
    self.searchAPI = [[AMapSearchAPI alloc] init];
    // 设置代理
    _searchAPI.delegate = self;
    // 构造 AMapPOIAroundSearchRequest对象, 设置周边请求参数
    _request = [[AMapPOIAroundSearchRequest alloc] init];
    // POI周边搜索查询关键字
    _request.keywords = strings;
    // POI周边搜索查询l类型
    _request.types = types;
    // 搜索半径
    _request.radius = 5000;
    // 设置请求的数据排列顺序
    _request.sortrule = 0;
    // 是否返回扩展消息
    _request.requireExtension = YES;
    
}
// 发送搜索附近请求体
- (void)sendRequest:(AMapGeoPoint *)sender
{
    _request.location = sender;
    // 发送请求体
    [_searchAPI AMapPOIAroundSearch:_request];
    
}

// 根据anntation生成对应的标注View
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnntation class]]) {
        
        // 标示符
        static NSString *poiIdentifier = @"poiIdentifier";
        // 从复用内存池中获取制定复用标识的 annotationView
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        // 没有找到
        if (poiAnnotationView == nil)
        {
            // 创建新的 annotationView
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        // 是否显示
        poiAnnotationView.canShowCallout = YES;
        // 显示在气泡右侧的view
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    return nil;
}

#pragma mark 根据中心点坐标来搜索周边POI 回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0) {
        return;
    }
    // 移除存在标注
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // 开辟可变数组存储标注 View
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    // 遍历 POI数组 创建对象添加到 poiAnnotation数组中
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        [poiAnnotations addObject:[[POIAnntation alloc] initWithPOI:obj]];
    }];
    
    // 将结果以 annotation 的形式加载到地图上
    [self.mapView addAnnotations:poiAnnotations];
    
    // 如果只有一个结果，设置其为中心点
    if (poiAnnotations.count == 1) {
        
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
        
    } else { // 如果有多个结果，设置地图使所有annotation都可见
        
        [self.mapView showAnnotations:poiAnnotations animated:NO];
        
    }
    
}

- (void)offlineDataIntoEffect
{
    _mapView.openGLESDisabled = NO;
    [_mapView reloadMap];
}

// 离线数据生效后的回调
- (void)offlineDataDidReload:(MAMapView *)mapView
{
    _mapView = mapView;
    // 打开定位
    _mapView.showsUserLocation = YES;
    // 定位图层显示模式 ： 跟随用户位置移动，并将定位点设置成地图中心点
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow];
    
    _mapView.openGLESDisabled = YES;
}

@end
