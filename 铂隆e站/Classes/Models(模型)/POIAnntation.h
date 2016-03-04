//
//  POIAnntation.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/14.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  自定义地图标注
 */
#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface POIAnntation : NSObject <MAAnnotation>

/**
 *  初始化一个标注View
 *
 *  @param poi View参数
 *
 *  @return 返回一个标注View
 */
- (instancetype)initWithPOI:(AMapPOI *)poi;

@property (nonatomic, readonly, strong) AMapPOI *poi;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/**
 *  获取annotation标题
 *
 *  @return 返回annotation标题
 */
- (NSString *)title;

/**
 *  获取annotation副标题
 *
 *  @return 返回annotation副标题
 */
- (NSString *)subtitle;

@end
