//
//  LocalStoreManage.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/21.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//


/**
 *  本地存储管理
 */
#import <Foundation/Foundation.h>
@class UserInformation;

@interface LocalStoreManage : NSObject

/**
 *  获取本地管理单利
 *
 *  @return 返回本地管理单利
 */
+ (instancetype)sharInstance;

/**
 *  用户信息存储到本地
 *
 *  @param userInfo 用户信息
 */
- (void)UserInforStoredLocally:(UserInformation *)userInfo;

/**
 *  存储头像到本地
 *
 *  @param image 头像
 */
- (void)storageHeadImage:(UIImage *)image;

/**
 *  存储背景图片到本地
 *
 *  @param image 背景图
 */
- (void)storageBackgroundImage:(UIImage *)image;

/**
 *  获取用户信息
 *
 *  @return 用户信息对象
 */
- (UserInformation *)requestUserInfor;

/**
 *  跟新本地用户头像URL
 *
 *  @param headURL 用户头像URL
 */
- (void)upUserHeadURL:(NSString *)headURL;

@end
