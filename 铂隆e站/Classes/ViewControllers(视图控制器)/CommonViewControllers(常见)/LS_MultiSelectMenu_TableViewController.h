//
//  LS_MultiSelectMenu_TableViewController.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/21.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  多选下拉菜单
 */
#import <UIKit/UIKit.h>
@class WuYeDetails;

typedef void(^kBlocks)(NSArray *);

@interface LS_MultiSelectMenu_TableViewController : UITableViewController

@property (strong, nonatomic) WuYeDetails *housingInform;

@property (copy, nonatomic) kBlocks block;

@end
