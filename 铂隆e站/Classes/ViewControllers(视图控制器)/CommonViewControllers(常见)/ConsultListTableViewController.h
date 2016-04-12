//
//  ConsultListTableViewController.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/12.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  咨询列表
 */
#import <UIKit/UIKit.h>

typedef void(^kBlock)();

@interface ConsultListTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) UserInformation *userInfo;

// 发送咨询或回复后跟新数据
@property (copy, nonatomic) kBlock block;

@end
