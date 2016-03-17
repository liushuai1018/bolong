//
//  LatestTableViewCell.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/20.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  停车咨询View
 */
#import <UIKit/UIKit.h>



@interface LatestTableViewCell : UITableViewCell


// 头像
@property (weak, nonatomic) IBOutlet UIImageView *iocImageView;

// 聊天内容
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

// 点赞
@property (weak, nonatomic) IBOutlet UIButton *zanButton;

// 回复
@property (weak, nonatomic) IBOutlet UIButton *huiFuBUtton;

// 名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

// 获得赞数
@property (weak, nonatomic) IBOutlet UILabel *wellLabel;


@end
