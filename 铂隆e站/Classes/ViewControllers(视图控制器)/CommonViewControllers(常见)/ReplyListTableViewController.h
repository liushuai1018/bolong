//
//  ReplyListTableViewController.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/12.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  答复列表
 */
#import <UIKit/UIKit.h>

typedef void(^kBlock)();
@interface ReplyListTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *dataArry;

@property (strong, nonatomic) UserInformation *userInfo;

// 回复完刷新数据
@property (copy, nonatomic) kBlock block;

@end
