//
//  WaterView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/31.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//


/**
 *  水费视图
 */
#import <UIKit/UIKit.h>
@class PulldownMenusView;

@interface WaterView : UIView <UITextFieldDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

/**
 *  水电费选择背景图
 */
@property (nonatomic, strong) UIImageView *xuanZeImage;

/**
 *  显示图标
 */
@property (nonatomic, strong) UIImageView *iocImage;

/**
 *  定位按钮
 */
@property (nonatomic, strong) UIButton *positionButton;

/**
 *  地理位置
 */
@property (nonatomic, strong) UILabel *positionLabel;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
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
 *  水费公司
 */
@property (nonatomic, strong) NSArray *waterCompanyArray; // 水

/**
 *  电力公司
 */
@property (nonatomic, strong) NSArray *electricityArray; // 电

/**
 *  水费视图选择按钮
 */
@property (nonatomic, strong) UIButton *waterButton;

/**
 *  电费视图选择按钮
 */
@property (nonatomic, strong) UIButton *electricityButton;

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

- (void)LSResignFirstResponder;

@end
