//
//  AlipayManage.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/25.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  支付宝交易管理工具
 */
#import <Foundation/Foundation.h>
@class Product;

@interface AlipayManage : NSObject

/**
 *  支付宝订单交易工具
 *
 *  @return 返回管理工具
 */
+ (instancetype)sharInstance;

/**
 *  创建订单并支付
 *
 *  @param product 订到信息
 *  @param retum   返回结果
 */
- (void)createrOrderAndSignature:(Product *)product
                           retum:(void(^)(NSDictionary *ditc))retum;

@end
