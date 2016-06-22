//
//  SelectAVillageTableViewController.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/23.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LS_WuYeInform_Model;
@class CommunityInformation;

typedef void(^kWuYeBlock)(LS_WuYeInform_Model *model);
typedef void(^kBlock)(CommunityInformation *model);

@interface SelectAVillageTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *dataArray; // 小区的数据

@property (strong, nonatomic) NSArray *wuyeAr;    // 物业的数据

@property (copy, nonatomic) kBlock block; // 选择的小区

@property (copy, nonatomic) kWuYeBlock wuyeBlock; // 选择的物业

@end
