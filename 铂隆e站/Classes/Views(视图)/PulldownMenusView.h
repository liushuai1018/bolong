//
//  PulldownMenusView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/11.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//


/**
 *  自定义下拉菜单
 */
#import <UIKit/UIKit.h>

typedef void(^kBlcok)();
typedef void(^chooseBlock)(NSIndexPath *);

@interface PulldownMenusView : UIView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    BOOL showList; // 是否显示下拉列表
    CGFloat tabHeight; // table下拉列表的高度
    CGFloat frameHeight; // frame的高度
}
@property (nonatomic, strong) UITableView *tv; // 菜单
@property (nonatomic, strong) NSArray *tableArray; //数据源
@property (nonatomic, strong) UITextField *textField; // 显示

/**
 *  取消界面上其他第一响应链
 */
@property (nonatomic, copy) kBlcok aBlock;

/**
 *  选择了那个cell
 */
@property (copy, nonatomic) chooseBlock chooseBlcok;

/**
 *  点击其他收回菜单
 */
- (void)clickOnTheOther;

@end
