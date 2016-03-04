//
//  MapView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/13.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MapView : UIView 

/**
 *  地图视图
 */
@property (nonatomic, strong) MAMapView *mapView;

/**
 *  搜索管理对象
 */
@property (nonatomic, strong) AMapSearchAPI *searchAPI;

/**
 *  停止代理、定位
 */
- (void)stopDelegateLocation;

/**
 *  初始化搜索管理对象
 *
 *  @param strings POI周边搜索查询关键字
 *  @param types   POI周边搜索查询类型
 */
- (void)initializeMapSearchKeywords:(NSString *)strings types:(NSString *)types;

/**
 *  使用离线地图
 */
- (void)offlineDataIntoEffect;

@end
