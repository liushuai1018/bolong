//
//  ConsultListModel.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/8.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  咨询列表
 */
#import <Foundation/Foundation.h>

@interface ConsultListModel : NSObject

/**
 *  列表ID
 */
@property (strong, nonatomic) NSString *consult_id;

/**
 *  发表用户ID
 */
@property (strong, nonatomic) NSString *user_id;

/**
 *  内容
 */
@property (strong, nonatomic) NSString *info;

/**
 *  发表用户名称
 */
@property (strong, nonatomic) NSString *user_name;

/**
 *  头像地址
 */
@property (strong, nonatomic) NSString *user_avar;

/**
 *  赞
 */
@property (strong, nonatomic) NSString *zan_count;

@end
