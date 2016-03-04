//
//  PropertyView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/11.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  物业缴费视图
 */
#import <UIKit/UIKit.h>
#import "PulldownMenusView.h"

@interface PropertyView : UIView <UITextFieldDelegate>

/**
 *  所在小区
 */
@property (nonatomic, strong) PulldownMenusView *communltyPMV;

/**
 *  所在单元
 */
@property (nonatomic, strong) PulldownMenusView *unitPMV;

/**
 *  楼层
 */
@property (nonatomic, strong) UITextField * storeyTF;

/**
 *  姓名
 */
@property (nonatomic, strong) UITextField *nameTF;

/**
 *  电话
 */
@property (nonatomic, strong) UITextField *phoneTF;

/**
 *  缴费金额
 */
@property (nonatomic, strong) UITextField *payTF;

/**
 *  缴费按钮
 */
@property (nonatomic, strong) UIButton *payButton;

@end
