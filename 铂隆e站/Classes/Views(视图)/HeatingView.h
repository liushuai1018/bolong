//
//  HeatingView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/11.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  暖气视图
 */
#import <UIKit/UIKit.h>
#import "PulldownMenusView.h"

@interface HeatingView : UIView <UITextFieldDelegate>

/**
 *  显示图标
 */
@property (nonatomic, strong) UIImageView *iocImage;

/**
 *  公司选择菜单
 */
@property (nonatomic, strong) PulldownMenusView *pulldownMenusV;

/**
 *  缴费账号
 */
@property (nonatomic, strong) UITextField *accountNumber;

/**
 *  缴费金额
 */
@property (nonatomic, strong) UITextField *paymentAmount;

/**
 *  缴费按钮
 */
@property (nonatomic, strong) UIButton *payBUtton;

/**
 *  缴费公司
 */
@property (nonatomic, strong) NSArray *payArray;

/**
 *  确认缴费提示视图
 */
@property (nonatomic, strong) UIView *confirmView;

/**
 *  创建缴费‘确认’视图
 */
- (void)createConfirmView;

/**
 *  缴费完成视图
 */
@property (nonatomic, strong) UIView *completeView;

/**
 *  创建缴费‘完成’视图
 */
- (void)createCompleteView;

/**
 *  姓名
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 *  缴费账号
 */
@property (nonatomic, strong) UILabel *accountLabel;

/**
 *  账号余额
 */
@property (nonatomic, strong) UILabel *accountBalanceLabel;

/**
 *  铂隆币余额
 */
@property (nonatomic, strong) UILabel *boLongBalanceLabel;

@end
