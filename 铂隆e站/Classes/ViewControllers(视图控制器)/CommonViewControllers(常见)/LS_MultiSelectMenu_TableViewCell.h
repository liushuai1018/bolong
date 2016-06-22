//
//  LS_MultiSelectMenu_TableViewCell.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/21.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LS_MultiSelectMenu_TableViewCell : UITableViewCell
/**
 *  房屋地址
 */
@property (weak, nonatomic) IBOutlet UILabel *address;
/**
 *  房屋大小
 */
@property (weak, nonatomic) IBOutlet UILabel *area;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *price;
/**
 *  选中
 */
@property (weak, nonatomic) IBOutlet UIButton *select;

@end
