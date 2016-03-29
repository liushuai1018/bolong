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

@property (strong, nonatomic) NSArray *dataArray;

@property (copy, nonatomic) kBlock block;

@end
