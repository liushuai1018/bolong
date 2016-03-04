//
//  POIAnntation.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/14.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "POIAnntation.h"

@interface POIAnntation ()

@property (nonatomic, readwrite, strong) AMapPOI *poi;

@end

@implementation POIAnntation

// 重写 set、get 方法
@synthesize poi = _poi;

- (instancetype)initWithPOI:(AMapPOI *)poi
{
    if (self = [super init]) {
        
        // 初始化 poi信息存储到私有类 poi 里面
        self.poi = poi;
    }
    return self;
}

- (NSString *)title
{
    return self.poi.name;
}

- (NSString *)subtitle
{
    return self.poi.address;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
}

@end
