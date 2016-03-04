//
//  ParkingConsultingView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/20.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  停车咨询视图
 */
#import <UIKit/UIKit.h>

@interface ParkingConsultingView : UIView <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;    //滑动视图

@property (nonatomic, strong) UITableView *latestTV;       //最新咨询

@property (nonatomic, strong) UITableView *onlineTV;       //在线咨询

@property (nonatomic, strong) UITableView *replyTV;        //答复

@property (nonatomic, strong) UITextField *ziXunTF;        //我要咨询(回复)

@property (nonatomic, strong) UIButton *sendButton;        //发送消息

@property (nonatomic, assign) BOOL interpretation;         //判读发送按钮是回复信息还是最新咨询

/**
 *  键盘回收
 */
- (void)textfieldResignFirstResponder;

/**
 *  回复事件
 */
- (void)replyActionForName:(NSString *)str;

@end
