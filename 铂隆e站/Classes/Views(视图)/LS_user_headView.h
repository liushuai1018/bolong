//
//  LS_user_headView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/15.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LS_user_headView : UIView

// 铂隆币
@property (strong, nonatomic) UILabel *BoLongbi;

// 头像
@property (strong, nonatomic) UIImageView *portraitImage;

// 更换头像
@property (strong, nonatomic) UIButton *portraitBut;

// name
@property (strong, nonatomic) UITextField *name;

// 手机号
@property (strong, nonatomic) UILabel *phoneNumber;

@end
