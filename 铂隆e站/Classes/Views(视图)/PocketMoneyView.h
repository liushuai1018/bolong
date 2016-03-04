//
//  PocketMoneyView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/29.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//


/**
 *  零花钱视图
 */
#import <UIKit/UIKit.h>

@interface PocketMoneyView : UIView

/**
 *  剩余零花钱
 */
@property (nonatomic, strong) UILabel *pocketMoneyLabel;

/**
 *  去购物
 */
@property (nonatomic, strong) UIButton *shoppingBut;

/**
 *  缴纳
 */
@property (nonatomic, strong) UIButton *payBut;

@end
