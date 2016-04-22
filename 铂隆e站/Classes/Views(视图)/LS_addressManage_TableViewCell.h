//
//  LS_addressManage_TableViewCell.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/20.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LS_addressManage_TableViewCell : UITableViewCell

// name
@property (weak, nonatomic) IBOutlet UILabel *name;
// 手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneNUmber;
// 地址
@property (weak, nonatomic) IBOutlet UILabel *address;
// 默认
@property (weak, nonatomic) IBOutlet UIButton *select;
@end
