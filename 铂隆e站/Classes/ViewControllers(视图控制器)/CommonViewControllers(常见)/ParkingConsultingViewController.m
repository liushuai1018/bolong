//
//  ParkingConsultingViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/20.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "ParkingConsultingViewController.h"
#import "ParkingConsultingView.h"
#import "LatestTableViewCell.h"

@interface ParkingConsultingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ParkingConsultingView *parkingCV; // 停车咨询视图

@end

@implementation ParkingConsultingViewController

- (void)loadView
{
    self.parkingCV = [[ParkingConsultingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    self.view = _parkingCV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializ];
}

#pragma mark - initializ
- (void)initializ
{
    
    [_parkingCV.sendButton addTarget:self action:@selector(sendTheMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    _parkingCV.latestTV.delegate = self;
    _parkingCV.latestTV.dataSource = self;
    _parkingCV.onlineTV.delegate = self;
    _parkingCV.onlineTV.dataSource = self;
    _parkingCV.replyTV.delegate = self;
    _parkingCV.replyTV.dataSource = self;
    [self.parkingCV.latestTV registerNib:[UINib nibWithNibName:@"LatestTableViewCell" bundle:nil] forCellReuseIdentifier:@"latestCell"];
    [self.parkingCV.onlineTV registerNib:[UINib nibWithNibName:@"LatestTableViewCell" bundle:nil] forCellReuseIdentifier:@"latestCell"];
    [self.parkingCV.replyTV registerNib:[UINib nibWithNibName:@"LatestTableViewCell" bundle:nil] forCellReuseIdentifier:@"latestCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (tableView.tag) {
        case 12500: {
            return 1;
            break;
        }
        case 12501: {
            return 2;
            break;
        }
        case 12502: {
            return 3;
            break;
        }
            
        default:
            return 0  ;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LatestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"latestCell" forIndexPath:indexPath];
    
    cell.iocImageView.layer.masksToBounds = YES;
    cell.iocImageView.layer.cornerRadius = CGRectGetHeight(cell.iocImageView.frame) * 0.5;
    [cell.zanButton addTarget:self action:@selector(zanAction:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.huiFuBUtton addTarget:self action:@selector(replyClickAction:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.2;
}

// 当前点击的cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"你点击了 %@", indexPath);
}

#pragma mark - 回复绑定事件
- (void)replyClickAction:(UIButton *)sender event:(id)event
{
    NSIndexPath *indexPath = [self indexPathForSender:sender event:event];
    NSLog(@" 回复 indexPath : %@", indexPath);
    
    [_parkingCV replyActionForName:@"  我是一只猫:"];
    
    
}

#pragma mark - 点赞绑定事件
- (void)zanAction:(UIButton *)sender event:(id)event
{
    NSIndexPath *indexPath = [self indexPathForSender:sender event:event];
    
    NSLog(@" 赞 indexPath : %@", indexPath);
}

// 获取点击 Cell 位置
- (NSIndexPath *)indexPathForSender:(id)sender event:(UIEvent *)event
{
    UIButton *button = (UIButton *)sender; // 当前点击的按钮
    UITouch *touch = [[event allTouches] anyObject]; // 获取按钮event 里包含的 touch 动作
    
    if (![button pointInside:[touch locationInView:button] withEvent:event]) {
        return nil;
    }
    
    CGPoint touchPosition = [touch locationInView:_parkingCV.latestTV];
    
    return [self.parkingCV.latestTV indexPathForRowAtPoint:touchPosition];
}

#pragma mark - 最新资讯发送消息
- (void)sendTheMessage:(UIButton *)sender
{
    // 判断当前是要发送咨询还是回复消息
    if (_parkingCV.interpretation) {
        NSLog(@"发送回复信息！~~~~~");
    } else {
        NSLog(@"发送最新咨询！~~~~~");
    }
    
    [_parkingCV textfieldResignFirstResponder];
}

@end
