//
//  ReplyTableViewCell.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/12.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyTableViewCell : UITableViewCell

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

/**
 *  回复人名称
 */
@property (weak, nonatomic) IBOutlet UILabel *from_name;

/**
 *  回复内容
 */
@property (weak, nonatomic) IBOutlet UILabel *from_info;

/**
 *  咨询内容
 */
@property (weak, nonatomic) IBOutlet UILabel *to_info;

/**
 *  回复按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *reply;

@end
