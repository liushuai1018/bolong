//
//  LS_Record_TableViewCell.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/8.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LS_Record_TableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *title;      // 题目

@property (weak, nonatomic) IBOutlet UILabel *time;       // 时间

@property (weak, nonatomic) IBOutlet UILabel *money;      // 消费金额

@property (weak, nonatomic) IBOutlet UILabel *zong_money; // 剩余总金额
@end
