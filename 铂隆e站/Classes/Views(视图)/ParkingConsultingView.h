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

typedef void(^kBlock)(NSInteger index);

@interface ParkingConsultingView : UIView <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;    //滑动视图

@property (nonatomic, strong) UITableView *latestTV;       //最新咨询

@property (nonatomic, strong) UITableView *onlineTV;       //在线咨询

@property (nonatomic, strong) UITableView *replyTV;        //答复

@property (strong, nonatomic) UISegmentedControl *segmentControl; // 分段视图

@property (strong, nonatomic) UIButton *senderConsulting;   //发送咨询

/**
 *  选择别的界面
 */
@property (copy, nonatomic) kBlock block;

@end
