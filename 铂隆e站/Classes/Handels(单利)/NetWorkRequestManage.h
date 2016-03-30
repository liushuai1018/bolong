//
//  NetWorkRequestManage.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/30.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

/**
 *  网络请单利
 */
#import <Foundation/Foundation.h>
@class UserInformation;
@class WuYeDetails;

@interface NetWorkRequestManage : NSObject

/**
 *  获取网络请求单利
 *
 *  @return 返回网络请求单利
 */
+ (instancetype)sharInstance;

#pragma makr - 用户管理

/**
 *  注册用户信息
 *
 *  @param account  注册账号
 *  @param password 注册密码
 *
 *  @return 注册是否成功
 */
- (BOOL)registeredAccount:(NSString *)account
                     code:(NSString *)code
                 password:(NSString *)password;

/**
 *  用户登陆
 *
 *  @param account  登陆账号
 *  @param password 登陆密码
 *
 *  @return 登陆是否成功
 */
- (BOOL)longinAccount:(NSString *)account
             password:(NSString *)password;

/**
 *  第三方登陆
 *
 *  @param openID 用户ID
 *  @param type   用户平台
 *  @param name   用户昵称
 *  @param avar   用户头像
 */
- (BOOL)otherLoginOpenID:(NSInteger)openID
                    type:(NSInteger)type
               user_name:(NSString *)name
               user_avar:(NSString *)avar;

/**
 *  发送手机号获取验证码
 *
 *  @param phone 手机号
 */
- (void)senderVerificationCode:(NSString *)phone
        returnVerificationCode:(void(^)(NSString *str))verification;

/**
 *  修改头像
 *
 *  @param user_id 用户唯一id
 *  @param image   新的头像
 */
- (void)upLoadHead:(NSString *)user_id
             image:(UIImage *)image;


/**
 *  修改昵称
 *
 *  @param name    昵称
 *  @param user_id 唯一ID
 */
- (void)updateUserName:(NSString *)name
               user_id:(NSString *)user_id;


/**
 *  忘记密码
 *
 *  @param phone    手机号
 *  @param password 新密码
 *  @param code     验证码
 */
- (void)forgetPasswordphone:(NSString *)phone
                   password:(NSString *)password
                       code:(NSString *)code
                      retun:(void(^)(NSString *str))block;

#pragma mark - 物业方法接口
/**
 *  获取小区
 *
 *  @param sneder 获取的小区信息
 */
- (void)getCommunity:(void(^)(NSArray *array))sender;

/**
 *  物业缴费
 *
 *  @param user_id 用户ID
 *  @param wuye_id 所在小区ID
 *  @param number  户主身份证号码
 *  @param name    业主姓名
 *
 *  @return 返回户主信息
 */
- (WuYeDetails *)wuyeInoformationID:(NSString *)user_id
                      wuye:(NSString *)wuye_id
                    number:(NSString *)number
                      name:(NSString *)name;

@end
