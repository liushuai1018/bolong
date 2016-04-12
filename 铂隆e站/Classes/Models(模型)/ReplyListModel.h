//
//  ReplyListModel.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/11.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyListModel : NSObject

/**
 *  回复你的ID
 */
@property (strong, nonatomic) NSString *from_user_id;

/**
 *  答复列表ID
 */
@property (strong, nonatomic) NSString *reply_id;

/**
 *  回复你的内容
 */
@property (strong, nonatomic) NSString *from_info;

/**
 *  咨询列表ID
 */
@property (strong, nonatomic) NSString *consult_id;

/**
 *  自己的ID
 */
@property (strong, nonatomic) NSString *to_user_id;

/**
 *  自己询问的内容
 */
@property (strong, nonatomic) NSString *to_info;

/**
 *  回复你的用户名
 */
@property (strong, nonatomic) NSString *from_user_name;

/**
 *  回复你的用户头像
 */
@property (strong, nonatomic) NSString *from_user_avar;

@end
