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
@class LS_addressManage;

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

#pragma mark - 首页信息
/**
 *  获取首页信息
 *
 *  @param inform 返回请求数据
 */
- (NSDictionary *)requestHomeInformation;

/**
 *  为服务项点赞
 *
 *  @param user_id 用户id
 *  @param type    那一项点赞
 */
- (void)didZanUser_id:(NSString *)user_id
                 type:(NSString *)type;

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


/**
 *  确认物业缴费
 *
 *  @param user_id 缴费用户ID
 *  @param log_ids 缴费的房屋
 */
- (void)wuyePay:(NSString *)user_id
        log_ids:(NSInteger)log_ids
          retum:(void(^)(NSDictionary *dict))inform;


#pragma mark - 停车咨询接口

/**
 *  获取咨询列表
 *
 *  @param index 参数
 *  @param block 获取到的数据
 */
- (void)consultListPage:(NSString *)index returns:(void(^)(NSArray *array))block;

/**
 *  发送新的咨询
 *
 *  @param user_id 发送者ID
 *  @param info    发送的消息
 */
- (void)senderConsultUser_id:(NSString *)user_id info:(NSString *)info;

/**
 *  赞_咨询
 *
 *  @param user_id    赞的用户
 *  @param consult_id 赞的那一条
 */
- (void)consultZanUser_id:(NSString *)user_id consult_id:(NSString *)consult_id;

/**
 *  回复咨询
 *
 *  @param user_id   回复用户
 *  @param conult_id 回复的那一条
 *  @param info      回复内容
 */
- (void)replyConsultUser_id:(NSString *)user_id consult_id:(NSString *)conult_id info:(NSString *)info;

/**
 *  获取答复列表信息
 *
 *  @param user_id 获取的用户
 *  @param block   获取到的信息
 */
- (void)requestReplyListInfoUser_id:(NSString *)user_id returns:(void(^)(NSArray *array))block;

#pragma mark - 地址管理接口

/**
 *  获取地址列表
 *
 *  @param user_id 用户ID
 *  @param block   返回数据值
 */
- (void)requestAddressUser_id:(NSString *)user_id  returns:(void(^)(NSArray *array))block;

/**
 *  删除地址
 *
 *  @param user_id   用户ID
 *  @param addres_id 地址ID
 */
- (void)removeAddressUser_id:(NSString *)user_id address_id:(NSString *)addres_id;

/**
 *  添加新地址
 *
 *  @param user_id 用户ID
 *  @param address 地址信息
 */
- (void)addNewAddressUser_id:(NSString *)user_id full_address:(LS_addressManage *)address;

/**
 *  修改地址
 *
 *  @param user_id 用户id
 *  @param address 修改后地址
 */
- (void)upAddressUser_id:(NSString *)user_id address:(LS_addressManage *)address;

@end
