//
//  LS_Lease_TableViewCell.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/29.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LS_Lease_TableViewCell : UITableViewCell
// 图
@property (weak, nonatomic) IBOutlet UIImageView *icoImage;
// 格局
@property (weak, nonatomic) IBOutlet UILabel *geju;
// 价格
@property (weak, nonatomic) IBOutlet UILabel *price;
// 押一付三
@property (weak, nonatomic) IBOutlet UILabel *fangshi;
// 浏览
@property (weak, nonatomic) IBOutlet UILabel *browse;
// 详情
@property (weak, nonatomic) IBOutlet UIButton *details;

@end
