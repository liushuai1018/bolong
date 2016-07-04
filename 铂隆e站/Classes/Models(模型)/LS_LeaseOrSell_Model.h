//
//  LS_LeaseOrSell_Model.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/7/1.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LS_LeaseOrSell_Model : NSObject

/**
 *  id
 */
@property (strong, nonatomic) NSString *listID;
/**
 *  出售或租赁 1:租赁 2:出售
 */
@property (strong, nonatomic) NSString *state;
/**
 *  小区
 */
@property (strong, nonatomic) NSString *house_name;
/**
 *  门牌号
 */
@property (strong, nonatomic) NSString *house_address;
/**
 *  房屋价格
 */
@property (strong, nonatomic) NSString *house_price;
/**
 *  房屋图片URL
 */
@property (strong, nonatomic) NSString *house_image;
/**
 *  房屋介绍
 */
@property (strong, nonatomic) NSString *house_info;
/**
 *  联系姓名
 */
@property (strong, nonatomic) NSString *people_name;
/**
 *  联系手机
 */
@property (strong, nonatomic) NSString *phone;
/**
 *  房屋格局
 */
@property (strong, nonatomic) NSString *house_style;
/**
 *  浏览量
 */
@property (strong, nonatomic) NSString *house_count;

@end
