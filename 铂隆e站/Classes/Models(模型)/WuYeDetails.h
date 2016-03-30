//
//  WuYeDetails.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/30.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  房产信息
 */
#import <Foundation/Foundation.h>

@interface WuYeDetails : NSObject

/**
 *  所属小区
 */
@property (strong, nonatomic) NSString *home;

/**
 *  业主姓名
 */
@property (strong, nonatomic) NSString *name;

/**
 *  证件号码
 */
@property (strong, nonatomic) NSString *number;

/**
 *  总价格
 */
@property (assign, nonatomic) CGFloat total_price;

/**
 *  每平米价格
 */
@property (assign, nonatomic) CGFloat unit_price;

/**
 *  房屋详细地址
 */
@property (strong, nonatomic) NSArray *addressList;

/**
 *  查询状态码： 0 成功 1 失败
 */
@property (assign, nonatomic) NSInteger code;

@end
