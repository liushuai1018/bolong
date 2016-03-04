//
//  CustomView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/10.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//


/**
 *  自定义占道停车
 */
#import <UIKit/UIKit.h>
#import "PulldownMenusView.h"
@interface CustomView : UIView
{
    UIView *_backgroundView;
}

@property (nonatomic, strong) CAShapeLayer *progressLayer; // 掩盖蒙版
@property (nonatomic) float progress; // 0~1 之间的数, 掩盖蒙版的圆角比例
@property (nonatomic, strong) UILabel *remainingNum; // 剩余车位
@property (nonatomic, strong) PulldownMenusView *roadPMV; // 所在的路
@property (nonatomic, strong) PulldownMenusView *streetPMV; // 所在的街
@property (nonatomic, strong) UIButton *addButton; // 抢走一个
@property (nonatomic, strong) UIButton *reduceButton; // 我走了

@property (nonatomic, strong) NSArray *roadArray; //路array
@property (nonatomic, strong) NSArray *streetArray; // 街array

@end
