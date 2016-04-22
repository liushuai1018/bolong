//
//  UserInformation.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/21.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//


/**
 *  用户信息模型
 */
#import <Foundation/Foundation.h>

@interface UserInformation : NSObject<NSCoding>

/**
 *  用户头像
 */
@property (nonatomic, strong) UIImage *headPortrait;

/**
 *  背景图片
 */
@property (nonatomic, strong) UIImage *backgroundImage;

/**
 *  用户头像URL
 */
@property (nonatomic, strong) NSString *headPortraitURL;

/**
 *  昵称
 */
@property (nonatomic, strong) NSString *name;

/**
 *  性别
 */
@property (nonatomic, strong) NSString *gender;

/**
 *  生日
 */
@property (nonatomic, strong) NSString *birthday;

/**
 *  城市
 */
@property (nonatomic, strong) NSString *city;

/**
 *  个人签名
 */
@property (nonatomic, strong) NSString *signature;

/**
 *  唯一ID
 */
@property (nonatomic, strong) NSString *user_id;

/**
 *  手机号
 */
@property (nonatomic, strong) NSString *mobile;

/**
 *  金钱
 */
@property (nonatomic, strong) NSString *money;

@end
