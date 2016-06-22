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
 *  @param account  账号
 *  @param code     验证码
 *  @param password 密码
 *  @param block    注册结果
 */
- (void)registeredAccount:(NSString *)account
                     code:(NSString *)code
                 password:(NSString *)password
                  returns:(void(^)(NSDictionary *isRegisteredAccount))block;

/**
 *  用户登陆
 *
 *  @param account  账号
 *  @param password 密码
 *  @param block    登陆结果
 */
- (void)longinAccount:(NSString *)account
             password:(NSString *)password
              returns:(void(^)(NSDictionary *isLongin))block;

/**
 *  发送手机号获取验证码
 *
 *  @param phone        手机号
 *  @param type         类型
 *  @param verification 结果
 */
- (void)senderVerificationCode:(NSString *)phone
                          type:(NSString *)type
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
 *  获取物业
 *
 *  @param block 获取的物业信息
 */
- (void)getWuYeRetuns:(void(^)(NSArray *array))block;

/**
 *  获取小区
 *
 *  @param wuYeID 物业ID
 *  @param sender 小区信息
 */
- (void)getCommunityWuYeID:(NSString *)wuYeID
           communityInform:(void(^)(NSArray *array))sender;

/**
 *  物业缴费信息
 *
 *  @param user_id     用户ID
 *  @param communityID 小区ID
 *  @param number      身份证号码
 *  @param name        户主姓名
 *  @param wuyeID      物业ID
 *  @param block       户主房屋信息
 */
- (void)wuyeInoformationID:(NSString *)user_id
               communityID:(NSString *)communityID
                    number:(NSString *)number
                      name:(NSString *)name
                    wuyeID:(NSString *)wuyeID
                   returns:(void(^)(WuYeDetails *wuyeDetails))block;


/**
 *  确认物业缴费
 *
 *  @param user_id 缴费用户ID
 *  @param log_ids 缴费的房屋
 */
- (void)wuyePay:(NSString *)user_id
        log_ids:(NSString *)log_ids
          retum:(void(^)(NSDictionary *dict))inform;

/**
 *  其他_水价
 *
 *  @param block 返回水价
 */
- (void)other_WaterMoneyWithPrice:(void(^)(NSString *price))block;

/**
 *  其他_送水
 *
 *  @param wuyeId  物业Id
 *  @param address 地址
 *  @param momey   总价格
 *  @param userId  用户Id
 */
- (void)other_waterWithWuYeId:(NSString *)wuyeId
                      Address:(NSString *)address
                        momey:(NSString *)momey
                     userInfo:(NSString *)userId;

/**
 *  其他_开锁
 *
 *  @param address 开锁地址
 *  @param block   求助电话
 */
- (void)other_UnlockingAddress:(NSString *)address
                        returns:(void(^)(NSString *phone))block;

/**
 *  获取废品单价
 *
 *  @param block 获取到的废品单价
 */
- (void)other_FeipinPriceReturn:(void(^)(NSArray *array))block;

/**
 *  其他_废品回收
 *
 *  @param feipinID 废品ID
 *  @param wuye_id  物业ID
 *  @param address  用户地址
 *  @param phone    用户手机号
 *  @param block    返回是否发送成功
 */
- (void)other_FeipinAcquisitionID:(NSString *)feipinID
                          wuye_id:(NSString *)wuye_id
                          address:(NSString *)address
                            phone:(NSString *)phone
                           returns:(void(^)(BOOL is))block;

/**
 *  其他_报修
 *
 *  @param userID   用户ID
 *  @param wuye_ID  物业ID
 *  @param question 问题
 *  @param address  地址
 *  @param image1   图片1
 *  @param image2   图片2
 *  @param image3   图片3
 *  @param block    返回是否发送成功
 */
- (void)other_repairUserID:(NSString *)userID
                   wuye_id:(NSString *)wuye_ID
                  question:(NSString *)question
                   address:(NSString *)address
                      pic1:(UIImage *)image1
                      pic2:(UIImage *)image2
                      pic3:(UIImage *)image3
                   returns:(void(^)(BOOL is))block;

/**
 *  其他_是否已经签到
 *
 *  @param userID 用户ID
 *  @param block  是否以签到
 */
- (void)other_isSignInUserID:(NSString *)userID
                     returns:(void(^)(BOOL is))block;

/**
 *  其他_签到
 *
 *  @param userID 用户Id
 *  @param block  签到结果
 */
- (void)other_signinUserID:(NSString *)userID
                   returns:(void(^)(BOOL is))block;

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

#pragma mark - IM

/**
 *  获取IM_token
 *
 *  @param userInfo 输入用户信息
 *  @param block    返回令牌token
 */
- (void)obtainIMToken:(UserInformation *)userInfo returns:(void(^)(NSString *token))block;

#pragma mark - 钱包接口

/**
 *  获取账号剩余铂隆币
 *
 *  @param userID 用户ID
 *  @param block  返回剩余的铂隆币
 */
- (void)wallet_obtainMoneyUserID:(NSString *)userID
                         returns:(void(^)(NSString *money))block;

/**
 *  充值铂隆币
 *
 *  @param userID 用户ID
 *  @param RMB    充值的铂隆币
 *  @param block  充值结果
 */
- (void)wallet_top_upMoneyUserID:(NSString *)userID
                      RMB:(NSString *)RMB
                  returns:(void(^)(NSDictionary *dic))block;

/**
 *  查询铂隆币充值记录
 *
 *  @param userID 用户ID
 *  @param block  充值的记录
 */
- (void)wallet_moneyRecordUserID:(NSString *)userID
                         returns:(void(^)(NSArray *array))block;

#pragma mark - 帮助接口

/**
 *  帮助_意见反馈
 *
 *  @param userID  用户ID
 *  @param content 反馈意见
 *  @param phone   手机号
 *  @param block   反馈结果
 */
- (void)help_opinionUserID:(NSString *)userID
                   content:(NSString *)content
                     phone:(NSString *)phone
                   returns:(void(^)(BOOL is))block;


@end
