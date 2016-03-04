//
//  PocketMoneyViewController.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/29.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

/**
 *  零花钱视图控制器
 */
#import <UIKit/UIKit.h>
@class PocketMoneyView;
@interface PocketMoneyViewController : UIViewController

/**
 *  零花钱视图
 */
@property (nonatomic, strong) PocketMoneyView *pocketMoneyV;

/**
 *  剩余零花钱
 */
@property (nonatomic, strong) NSString *remaining;

@end
