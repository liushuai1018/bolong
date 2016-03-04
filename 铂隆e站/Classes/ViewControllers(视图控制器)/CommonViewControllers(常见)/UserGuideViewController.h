//
//  UserGuideViewController.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/26.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

/**
 *  用户引导页
 * 
 */
#import <UIKit/UIKit.h>
typedef void (^kBlcok) ();

@interface UserGuideViewController : UIViewController

@property (nonatomic, copy) kBlcok block;

@end
