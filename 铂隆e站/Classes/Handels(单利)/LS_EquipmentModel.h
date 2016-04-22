//
//  LS_EquipmentModel.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/19.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LS_EquipmentModel : NSObject

/**
 *  获取设备型号
 */
+ (instancetype)sharedEquipmentModel;

/**
 *  获取型号
 *
 *  @return 苹果型号
 */
- (NSString *)accessModel;

@end
