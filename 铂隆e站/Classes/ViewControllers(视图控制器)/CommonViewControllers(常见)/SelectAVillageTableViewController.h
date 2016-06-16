//
//  SelectAVillageTableViewController.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/23.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunityInformation;
typedef void(^kBlock)(CommunityInformation *);

@interface SelectAVillageTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *dataArray; // 小区

@property (strong, nonatomic) NSArray *wuyeAr;    // 物业

@property (copy, nonatomic) kBlock block; // 小区

@end
