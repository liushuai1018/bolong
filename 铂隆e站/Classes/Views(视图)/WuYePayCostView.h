//
//  WuYePayCostView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/29.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PulldownMenusView;
typedef void(^kBlock)();
/**
 *  选择缴纳那套房屋物业费
 */
@interface WuYePayCostView : UIView

/**
 *  姓名
 */
@property (strong, nonatomic) UILabel *name;

/**
 *  身份证号
 */
@property (strong, nonatomic) UILabel *number;

/**
 *  选择缴费的房屋
 */
@property (strong, nonatomic) PulldownMenusView *pulldownMenus;

/**
 *  缴费详情
 */
@property (strong, nonatomic) UILabel *paymentDetails;

/**
 *  总计
 */
@property (strong, nonatomic) UILabel *totalFee;

/**
 *  确定
 */
@property (strong, nonatomic) UIButton *button;

@property (copy, nonatomic) kBlock block;

@end
