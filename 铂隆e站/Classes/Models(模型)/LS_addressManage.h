//
//  LS_addressManage.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/21.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  地址管理
 */
#import <Foundation/Foundation.h>

@interface LS_addressManage : NSObject <NSCoding>

/**
 *  地址id
 */
@property (strong, nonatomic) NSString *address_id;

/**
 *  用户名称
 */
@property (strong, nonatomic) NSString *name;

/**
 *  手机号
 */
@property (strong, nonatomic) NSString *mobile;

/**
 *  邮编
 */
@property (strong, nonatomic) NSString *code;

/**
 *  省份
 */
@property (strong, nonatomic) NSString *province;

/**
 *  城市
 */
@property (strong, nonatomic) NSString *city;

/**
 *  区县
 */
@property (strong, nonatomic) NSString *region;

/**
 *  街道
 */
@property (strong, nonatomic) NSString *street;

/**
 *  详细地址
 */
@property (strong, nonatomic) NSString *full_address;

/**
 *  是否默认地址
 */
@property (assign, nonatomic) BOOL LS_default;

@end
