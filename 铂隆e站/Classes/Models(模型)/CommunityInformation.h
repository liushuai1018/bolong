//
//  CommunityInformation.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/29.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  小区 
 */
#import <Foundation/Foundation.h>

@interface CommunityInformation : NSObject

/**
 *  小区编号
 */
@property (strong, nonatomic) NSString *wuye_id;

/**
 *  小区名称
 */
@property (strong, nonatomic) NSString *home;

/**
 *  物业价格
 */
@property (assign, nonatomic) CGFloat price;

@end
