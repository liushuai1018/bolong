//
//  HomeTableViewCell.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/27.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//


/**
 *  自定义首页的 cell
 */
#import <UIKit/UIKit.h>
typedef void(^kBlock)();

@interface HomeTableViewCell : UITableViewCell

// 背景图片
@property (weak, nonatomic) IBOutlet UIImageView *image;

// 标示图片
@property (weak, nonatomic) IBOutlet UIImageView *iocImage;

// 赞次数
@property (weak, nonatomic) IBOutlet UILabel *zanTime;

// 赞按钮
@property (weak, nonatomic) IBOutlet UIButton *zanButton;

@end
