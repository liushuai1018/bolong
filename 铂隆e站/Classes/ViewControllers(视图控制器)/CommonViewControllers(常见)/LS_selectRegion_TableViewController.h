//
//  LS_selectRegion_TableViewController.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/21.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  选择地区
 */
#import <UIKit/UIKit.h>

typedef void(^kBlock)(NSString *);
@interface LS_selectRegion_TableViewController : UITableViewController

@property (copy, nonatomic) kBlock block;

@end
