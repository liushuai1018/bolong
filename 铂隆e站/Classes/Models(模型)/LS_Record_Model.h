//
//  LS_Record_Model.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/2.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  钱包充值记录模型
 */
#import <Foundation/Foundation.h>

@interface LS_Record_Model : NSObject

/**
 *  用户ID
 */
@property (strong, nonatomic) NSString *user_id;

/**
 *  充值铂隆币
 */
@property (strong, nonatomic) NSString *money;

/**
 *  充值时间
 */
@property (strong, nonatomic) NSString *time;

/**
 *  余额
 */
@property (strong, nonatomic) NSString  *zong_money;
@end
