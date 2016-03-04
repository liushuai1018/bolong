//
//  UserDistrictHeadView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/30.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//


/**
 *  我的界面区头
 */
#import <UIKit/UIKit.h>

typedef void(^kBlocks)(UIImagePickerController *);
typedef void(^kBlcok1)(UIAlertController *);
typedef void(^kBlock2)(void);
@interface UserDistrictHeadView : UIView 

// 背景图片
@property (nonatomic, strong) UIImageView *backgroundImage;

// 头像图片
@property (nonatomic, strong) UIImageView *headPortraitImage;

// 用户名
@property (nonatomic, strong) UILabel *userNameLabel;

// 性别图片
@property (nonatomic, strong) UIImageView *sexImage;

@property (nonatomic, copy) kBlocks blocks; // 推出相册或者摄像头
@property (nonatomic, copy) kBlcok1 block1; // 推出头像来源选择提示框
@property (nonatomic, copy) kBlock2 block2; // 背景手势block

@end
