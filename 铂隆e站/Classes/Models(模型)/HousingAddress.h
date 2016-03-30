//
//  HousingAddress.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/30.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HousingAddress : NSObject

/**
 *  房屋地址
 */
@property (strong, nonatomic) NSString *address;

/**
 *  房屋标签
 */
@property (assign, nonatomic) NSInteger log_id;

/**
 *  房屋平米
 */
@property (assign, nonatomic) CGFloat area;

/**
 *  物业费用
 */
@property (assign, nonatomic) CGFloat price;

@end
