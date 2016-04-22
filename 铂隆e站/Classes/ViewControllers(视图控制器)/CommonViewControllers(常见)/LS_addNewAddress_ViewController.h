//
//  LS_addNewAddress_ViewController.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/21.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LS_addressManage;

typedef void(^kBlocks)(LS_addressManage *);
@interface LS_addNewAddress_ViewController : UIViewController

// 新地址传到到管理界面
@property (copy, nonatomic) kBlocks sendNewAddress;

// 修改地址时候穿过来的值
@property (strong, nonatomic) LS_addressManage *modeifyAddress;

@end
