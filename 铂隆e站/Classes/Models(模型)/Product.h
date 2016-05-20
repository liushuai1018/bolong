//
//  Product.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/25.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  商品价格模型
 */
#import <Foundation/Foundation.h>

@interface Product : NSObject

{
@private                  // 私有
    float _price;         // 价格
    NSString *_subject;   // 商品标题
    NSString *_body;      // 商品描述
    NSString *_orderId;   // 订单ID
}
/**
 *  商品价格
 */
@property (assign, nonatomic) float price;
/**
 *  商品标题
 */
@property (copy, nonatomic) NSString *subject;
/**
 *  商品介绍
 */
@property (copy, nonatomic) NSString *body;
/**
 *  商品编码
 */
@property (copy, nonatomic) NSString *orderId;

/**
 *  后台通知地址
 */
@property (copy, nonatomic) NSString *notify_url;

@end
