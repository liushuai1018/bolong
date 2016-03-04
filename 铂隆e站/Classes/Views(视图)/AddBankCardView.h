//
//  AddBankCardView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/5.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBankCardView : UIView

/**
 *  银行卡View
 */
@property (nonatomic, strong) UIView *bankCardView;

/**
 *  开户名
 */
@property (nonatomic, strong) UITextField *name;

/**
 *  银行卡号
 */
@property (nonatomic, strong) UITextField *bankcardNumber;

/**
 *  下一步
 */
@property (nonatomic, strong) UIButton *nextButon;

@end
