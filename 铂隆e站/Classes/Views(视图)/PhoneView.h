//
//  PhoneView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/29.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

/**
 *  手机充值视图
 */
#import <UIKit/UIKit.h>

@interface PhoneView : UIView <UITextFieldDelegate>

/**
 *  手机号
 */
@property (nonatomic, strong) UITextField *phoneNumber;

/**
 *  10元
 */
@property (nonatomic, strong) UIButton *tenBut;

/**
 *  20元
 */
@property (nonatomic, strong) UIButton *twentyBut;

/**
 *  30元
 */
@property (nonatomic, strong) UIButton *thirtyBut;

/**
 *  50元
 */
@property (nonatomic, strong) UIButton *fiftyBut;

/**
 *  100元
 */
@property (nonatomic, strong) UIButton *oneHundredBut;

/**
 *  其他
 */
@property (nonatomic, strong) UIButton *otherBut;

/**
 *  缴费成功提示框
 */
@property (nonatomic, strong) UIView *promptView;

/**
 *  缴费提示框
 *
 *  @param index   缴费金额
 *  @param actual  实际金额
 *  @param current 当前铂隆币
 *  @param surplus 剩余铂隆币
 *  @param phone   手机号
 */
- (void)createWarningViewWithInt:(CGFloat)index actualNumber:(CGFloat)actual currentNumber:(NSString *)current surplusNumber:(CGFloat)surplus phone:(NSString *)phone;

/**
 *  手机号达不到要求禁止点击
 *
 *  @param is 是否可以被点击
 */
- (void)butUserInteractionEnabled:(BOOL)is;

@end
