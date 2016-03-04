//
//  UserfirstSTableViewCell.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/2.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//


/**
 *  我的界面第一个cell
 */
#import <UIKit/UIKit.h>

@interface UserfirstSTableViewCell : UITableViewCell

// 钱包
@property (nonatomic, strong) UIButton *walletBtn;
// 中间图片
@property (nonatomic, strong) UIImageView *tempImage;
// 设置
@property (nonatomic, strong) UIButton *settingBtu;
// 设置动画
@property (nonatomic, strong) UIImageView *sttingImage;
// 动画图组
@property (nonatomic, strong) NSArray *aimageArray;

- (void)startAnimation;

@end
