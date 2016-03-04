//
//  WalletView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/28.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

/**
 *  钱包视图
 */
#import <UIKit/UIKit.h>

@interface WalletView : UIView

/**
 *  零花钱
 */
@property (nonatomic, strong) UIButton *pocketMoneyBut;

/**
 *  银行卡
 */
@property (nonatomic, strong) UIButton *bankCardBut;

/**
 *  手机充值
 */
@property (nonatomic, strong) UIButton *phoneBut;

/**
 *  物业缴费
 */
@property (nonatomic, strong) UIButton *propertyBut;

/**
 *  水电缴费
 */
@property (nonatomic, strong) UIButton *waterAndElectricityBut;

/**
 *  购物车
 */
@property (nonatomic, strong) UIButton *shoppingCartBut;

/**
 *  加油站
 */
@property (nonatomic, strong) UIButton *gasStationBut;

/**
 *  便利店
 */
@property (nonatomic, strong) UIButton *convenienceStoresBut;

/**
 *  美食
 */
@property (nonatomic, strong) UIButton *foodBut;

/**
 *  剩余零花钱
 */
@property (nonatomic, strong) UILabel *pocketMoneyLabel;

/**
 *  绑定银行卡
 */
@property (nonatomic, strong) UILabel *bankCardLabel;

@end
