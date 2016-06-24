//
//  WuYePayCostViewController.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/29.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WuYeDetails;

@interface WuYePayCostViewController : UIViewController

@property (strong, nonatomic) WuYeDetails *wuye;

@property (strong, nonatomic) UserInformation *userInformation;

// 物业ID
@property (strong, nonatomic) NSString *wuyeID;

@end
