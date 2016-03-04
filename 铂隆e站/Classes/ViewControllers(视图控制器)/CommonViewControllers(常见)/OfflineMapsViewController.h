//
//  OfflineMapsViewController.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/8.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  离线地图视图控制器
 */
#import <UIKit/UIKit.h>
#import "MapView.h"

typedef void(^kBlock)(id);

@interface OfflineMapsViewController : UIViewController

@property (nonatomic, strong) MapView *mapView;

@property (nonatomic, copy) kBlock block;

@end
