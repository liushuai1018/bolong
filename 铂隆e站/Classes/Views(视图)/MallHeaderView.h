//
//  MallHeaderView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/8.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallHeaderView : UIView

/**
 *  存储所有图标
 */
@property (nonatomic, strong) NSArray *allIconArray;

/**
 *  存储所有标题
 */
@property (nonatomic, strong) NSArray *allTitleArray;

/**
 *  标题图
 */
@property (nonatomic, strong) UIImageView *imageVeiw;

@end
