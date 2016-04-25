//
//  RegisteredViewController.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/4.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//


/**
 *  注册控制器
 */
#import <UIKit/UIKit.h>


typedef void(^kBlock)();
@interface RegisteredViewController : UIViewController

@property (copy, nonatomic) kBlock block;

@end
