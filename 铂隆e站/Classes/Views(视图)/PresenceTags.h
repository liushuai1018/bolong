//
//  PresenceTags.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/13.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  电子标签
 */
#import <UIKit/UIKit.h>

@interface PresenceTags : UIView

// 电子标签
@property (strong, nonatomic) UIButton *tagsBut;
// 姓名
@property (strong, nonatomic) UILabel *name;
// 手机号
@property (strong, nonatomic) UILabel *phoneNumber;
// 标签号
@property (strong, nonatomic) UILabel *tagsNumber;
// 车牌号
@property (strong, nonatomic) UILabel *licensePlateNumber;
// 剩余时间
@property (strong, nonatomic) UIButton *dateBut;
// 充值
@property (strong, nonatomic) UIButton *top_upBut;

@end
